FROM tqxr/arch-build-base

WORKDIR /src
ADD master.zip ./
RUN unzip master.zip
WORKDIR /src/cpython-master

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

