FROM tqxr/centos-build-base

RUN mkdir -p /newroot/{etc,lib64/python3.6,bin,usr/share/terminfo/x,root}

RUN cp /usr/bin/strace /newroot/bin/
RUN cp /lib64/libgcc_s.so.1 /newroot/lib64/

RUN cp /lib64/{\
libpthread.so.0,\
libdl.so.2,\
libutil.so.1,\
libm.so.6,\
libc.so.6,\
libreadline.so.6,\
libtinfo.so.5,\
libncursesw.so.5,\
ld-linux-x86-64.so.2\
} /newroot/lib64/

RUN cp /etc/inputrc /newroot/etc/
RUN cp /usr/share/terminfo/x/xterm /newroot/usr/share/terminfo/x/

ARG PYUSR=/opt/rh/rh-python36/root/usr

RUN cp ${PYUSR}/bin/python3.6 /newroot/bin/python
RUN cp ${PYUSR}/lib64/libpython3.6m.so.rh-python36-1.0 /newroot/lib64/
RUN cp ${PYUSR}/lib64/libpython3.so.rh-python36 /newroot/lib64/
RUN cp -r ${PYUSR}/lib64/python3.6 /newroot/lib64

ENTRYPOINT [ "/bin/bash" ]

