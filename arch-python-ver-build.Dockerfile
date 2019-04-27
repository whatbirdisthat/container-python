FROM tqxr/arch-build-base

ARG PYTHON_VERSION=3.7.3
ARG PYTHON_SRC_ARCHIVE=Python-${PYTHON_VERSION}.tar.xz
ARG MD5_CHECKSUM="93df27aec0cd18d6d42173e601ffbbfd ${PYTHON_SRC_ARCHIVE}"

WORKDIR /src
ADD https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_SRC_ARCHIVE} ./
RUN echo "${MD5_CHECKSUM}" | md5sum -c -
RUN tar xvf ${PYTHON_SRC_ARCHIVE}
WORKDIR /src/Python-${PYTHON_VERSION}

#### Disable bundled pip & setuptools
#### enabling optimizations increases build time
#### by really really a lot
#              --enable-optimizations \
# not supported on .. linux? arch? docker?
#             --with-system-ffi \

RUN  ./configure \
              --prefix=/the-python \
              --disable-shared \
              --with-computed-gotos \
              --with-lto \
              --disable-ipv6 \
              --with-system-expat \
              --with-dbmliborder=gdbm:ndbm \
              --with-system-libmpdec \
              --enable-loadable-sqlite-extensions \
              --without-ensurepip \
              --without-pydebug

RUN CFLAGS="-Os -g0" LDFLAGS="-Wl,--strip-all" make -j`nproc`
RUN make install

