FROM tqxr/python-373-build

ARG PYVER=3.7
ARG PYSRC=/src/Python-3.7.3

RUN mkdir -p \
  /newroot/lib64 \
  /newroot/bin \
  /newroot/lib/python${PYVER}/lib-dynload \
  /newroot/etc

RUN mkdir -p /newroot/usr/share/terminfo/x
RUN cp /usr/share/terminfo/x/xterm /newroot/usr/share/terminfo/x/
RUN cp /etc/inputrc /newroot/etc/

RUN cp /lib64/{\
libcrypt.so.1,\
libfreebl3.so,\
libpthread.so.0,\
libreadline.so.8,\
libtinfo.so.6,\
libdl.so.2,\
libutil.so.1,\
libm.so.6,\
libc.so.6,\
libncursesw.so.6,\
ld-linux-x86-64.so.2\
} /newroot/lib64/

WORKDIR ${PYSRC}/build/lib.linux-x86_64-${PYVER}
RUN cp *.so /newroot/lib/python${PYVER}/lib-dynload/

WORKDIR ${PYSRC}/Lib
RUN cp *.py /newroot/lib/

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
} /newroot/lib/

RUN cp ${PYSRC}/python /newroot/python

FROM scratch
COPY --from=0 /newroot/ /
ENV TERM xterm
ENV PYTHONHOME /
ENV PYTHONPATH /lib/
ENV LD_LIBRARY_PATH /lib64
ENTRYPOINT [ "/python", "-i" ]

