FROM tqxr/python-master-arch-build
ARG WITH_STRACE=no
ARG WITH_LOCALE_ARCHIVE=no
ARG ZONEINFO_COUNTRY=Australia
ARG ZONEINFO_CITY=Melbourne

RUN mkdir -p \
  /src \
  /newroot/lib64 \
  /newroot/tmpLib \
  /newroot/lib/python3.8/lib-dynload \
  /newroot/etc \
  /the-python

RUN cp /etc/{inputrc,locale.conf} /newroot/etc/
RUN mkdir -p /newroot/usr/share/terminfo/x
RUN cp /usr/share/terminfo/x/xterm /newroot/usr/share/terminfo/x/

#python looks for this, but does it reeeeally need it?
RUN if [ "$WITH_LOCALE_ARCHIVE" = "no" ] ; \
  then \
    echo "NOT bloating the image with locale-archive" ; \
  else \
    echo "BLOATING the image with locale-archive" ; \
    (mkdir -p /newroot/usr/lib/locale ; cp /usr/lib/locale/locale-archive /newroot/usr/lib/locale/ ) ; \
  fi

RUN cp /usr/share/zoneinfo/${ZONEINFO_COUNTRY}/${ZONEINFO_CITY} /newroot/etc/localtime
#RUN cp /usr/share/zoneinfo/Australia/Melbourne /newroot/etc/localtime

RUN if [ "$WITH_STRACE" = "no" ]; then echo "NOT installing strace" ; else \
echo "INSTALLING strace" ; \
mkdir -p /newroot/bin ; \
(cp /usr/bin/strace /newroot/bin ; \
cp /lib64/{\
libunwind-ptrace.so.0,\
libgcc_s.so.1,\
librt.so.1,\
libunwind-x86_64.so.8,\
libunwind.so.8,\
liblzma.so.5\
} /newroot/lib64) ; fi

RUN cp /lib64/{\
libcrypt.so.1,\
libfreebl3.so,\
libpthread.so.0,\
libreadline.so.8,\
libncursesw.so.6,\
libtinfo.so.6,\
libdl.so.2,\
libutil.so.1,\
libm.so.6,\
libc.so.6,\
libz.so.1,\
ld-linux-x86-64.so.2\
} /newroot/lib64/

WORKDIR /src/cpython-master/Lib
RUN cp *.py /newroot/tmpLib/

RUN cp -r {\
asyncio,\
collections,\
concurrent,\
ctypes,\
curses,\
dbm,\
encodings,\
html,\
http,\
importlib,\
json,\
logging,\
multiprocessing,\
pydoc_data,\
site-packages,\
sqlite3,\
tkinter,\
turtledemo,\
unittest,\
urllib,\
venv,\
wsgiref,\
xml,\
xmlrpc\
} /newroot/tmpLib/

RUN cp /src/cpython-master/python /newroot/python

WORKDIR /newroot/tmpLib
RUN zip -r9 /newroot/lib/python38.zip .
RUN rm -rf /newroot/tmpLib

WORKDIR /src/cpython-master/build/lib.linux-x86_64-3.8
RUN cp *.so /newroot/lib/python3.8/lib-dynload/

FROM scratch
COPY --from=0 /newroot/ /

ENV PYTHONHOME /
ENV PYTHONPATH /lib/
ENV LD_LIBRARY_PATH /lib64

ENTRYPOINT [ "/python", "-i" ]

