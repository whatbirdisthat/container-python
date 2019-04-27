FROM alpine:latest

# why three RUN apk add layers?
# because we can use `dive` to see
# the filesystem after the package(s) install
# [dive](https://github.com/wagoodman/dive)

RUN apk add --no-cache \
  git git-doc git-bash-completion \
  openssh-client \
  readline readline-doc \
  make

RUN apk add --no-cache \
  bash less tree coreutils

RUN apk add --no-cache \
    python3

WORKDIR /

