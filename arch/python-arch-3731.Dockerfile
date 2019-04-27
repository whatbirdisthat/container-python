# WIP

FROM tqxr/centos-base

RUN mkdir -p /newroot/lib64 /newroot/bin /newroot/lib/python

RUN cp /lib64/{\
libpthread.so.0,\
libdl.so.2,\
libutil.so.1,\
libm.so.6,\
libc.so.6,\
ld-linux-x86-64.so.2\
} /newroot/lib64/


RUN cp /opt/rh/rh-python36/root/usr/bin/python3.6 /newroot/bin/python
RUN cp /opt/rh/rh-python36/root/usr/lib64/libpython3.6m.so.rh-python36-1.0 /newroot/lib64/
RUN cp /opt/rh/rh-python36/root/usr/lib64/libpython3.so.rh-python36 /newroot/lib64/
RUN cp -r /opt/rh/rh-python36/root/usr/lib64/python3.6 /newroot/lib/

RUN ls /newroot/lib/python3.6

FROM scratch
COPY --from=0 /newroot/ /

ENV PYTHONHOME /bin/python
ENV PYTHONPATH /lib/python3.6

ENTRYPOINT [ "/bin/python", "-i" ]

