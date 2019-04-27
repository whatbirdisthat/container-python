FROM archlinux/base:latest

RUN pacman -Syyu --noconfirm

#RUN pacman -Sg --noconfirm --needed devel
# readline-doc 
# readline-devel \
# readline-static \
# openssh-client openssh-clients 
# openssl-devel 
# bind-utils \
# curl-devel expat-devel gettext-devel zlib-devel perl-CPAN perl-devel \
# libffi-devel 
# gcc-c++ 
# zlib-devel
#

RUN pacman -Sg --noconfirm base-devel

RUN pacman -S --noconfirm --needed \
    bash less tree \
    readline \
    make strace man asciidoc xmlto \
    gcc zlib \
    openssh openssl bind-tools \
    nss \
    curl expat gettext zlib libffi \
    perl python \
    zip unzip \
    grep awk sed binutils

RUN pacman -S --noconfirm clang

WORKDIR /
CMD [ "/usr/bin/bash" ]


