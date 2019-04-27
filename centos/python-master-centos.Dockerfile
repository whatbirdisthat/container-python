FROM tqxr/python-master-centos-build

RUN cp /usr/bin/strace /newroot/bin/
RUN cp /lib64/libgcc_s.so.1 /newroot/lib64


FROM scratch
COPY --from=0 /newroot/ /

ENV LD_LIBRARY_PATH /lib64
ENV PYTHONHOME /usr
#ENV PYTHONPATH /lib64
#ENV TERM=xterm

#ENTRYPOINT [ "/bin/strace", "/python", "-i" ]
ENTRYPOINT [ "/bin/python", "-i" ]

