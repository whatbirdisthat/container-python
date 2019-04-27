FROM tqxr/python3610-centos

FROM scratch
COPY --from=0 /newroot/ /

ENV PYTHONHOME /
WORKDIR /root
ENTRYPOINT [ "/bin/python", "-i" ]


