FROM tqxr/centos-build-base

RUN mkdir -p \
  /src \
  /newroot/lib64 \
  /newroot/bin \
  /newroot/usr/lib/python3.8/lib-dynload \
  /newroot/etc

RUN mkdir -p /newroot/usr/share/terminfo/x
RUN cp /usr/share/terminfo/x/xterm /newroot/usr/share/terminfo/x/
RUN cp /etc/inputrc /newroot/etc/

RUN mkdir -p /newroot/usr/lib/locale
RUN cp /usr/lib/locale/locale-archive /newroot/usr/lib/locale/

RUN cp /usr/share/zoneinfo/Australia/Melbourne /newroot/etc/localtime

RUN cp /lib64/{\
libcrypt.so.1,\
libfreebl3.so,\
libpthread.so.0,\
libreadline.so.6,\
libtinfo.so.5,\
libdl.so.2,\
libutil.so.1,\
libm.so.6,\
libc.so.6,\
ld-linux-x86-64.so.2\
} /newroot/lib64/

WORKDIR /src
ADD https://github.com/python/cpython/archive/master.zip ./
RUN unzip master.zip
WORKDIR /src/cpython-master
RUN ./configure --prefix=/usr
RUN make -j`nproc`

# to make this the lightest possible image
# we aren't copying everything
# so things like pip and idle are left out

WORKDIR /src/cpython-master/build/lib.linux-x86_64-3.8
RUN cp *.so /newroot/usr/lib/python3.8/lib-dynload/

WORKDIR /src/cpython-master/Lib
RUN cp *.py /newroot/usr/lib/python3.8/

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
} /newroot/usr/lib/python3.8/

RUN cp /src/cpython-master/python /newroot/bin/python

