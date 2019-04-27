FROM centos:latest

# Why so many layers?
# Because this is a *builder image*
# it is used as a source for the
# artifact images (which are single layer)

# the multiple layers actually helps
# when using `dive` to see what actually
# happens to the filesystem when each
# package(s) installs

RUN yum update -y

RUN yum install -y centos-release-scl
RUN yum install -y rh-python36

RUN yum group install -y "Development Tools"

RUN yum install -y \
    make gcc gcc-c++

RUN yum install -y \
    bash less tree which strace binutils

RUN yum install -y \
    grep awk sed \
    readline readline-doc \
    readline-devel \
    readline-static

RUN yum install -y \
    man asciidoc xmlto

RUN yum install -y \
    openssh-client openssh-clients bind-utils \
    curl-devel expat-devel gettext-devel \
    openssl-devel zlib-devel perl-CPAN perl-devel \
    libffi-devel zlib zlib-devel

WORKDIR /
CMD [ "/usr/bin/bash" ]
