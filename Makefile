# BASE images

image-alpine-build-base:
	cat alpine/alpine.Dockerfile | docker build -t tqxr/alpine-build-base -

image-centos-build-base:
	cat centos/centos.Dockerfile | docker build -t tqxr/centos-build-base -

image-arch-build-base:
	cat arch/arch.Dockerfile | docker build -t tqxr/arch-build-base -


# CENTOS based images

image-python3-centos-scratch: image-python3-centos
	cat centos/python3610-centos-scratch.Dockerfile | docker build -t tqxr/python3610-centos-scratch -

image-python3-centos: image-centos-build-base
	cat centos/python3610-centos.Dockerfile | docker build -t tqxr/python3610-centos -

image-python-master-centos-build: image-centos-build-base
	cat centos/python-master-centos-build.Dockerfile | docker build -t tqxr/python-master-centos-build -

#image-python-master-centos:
image-python-master-centos: image-python-master-centos-build
	cat centos/python-master-centos.Dockerfile | docker build -t tqxr/python-master-centos -


# trying to figure out why no readline / history in the `FROM scratch` build
# when it works in the full version...
strace-python3-centos-scratch:
	docker run -it --rm --privileged --entrypoint /bin/strace tqxr/python3610-centos-scratch /bin/python -i
strace-python3-centos:
	docker run -it --rm --privileged --entrypoint /usr/bin/strace \
		tqxr/python3610-centos /opt/rh/rh-python36/root/usr/bin/python3.6 -i
python3-centos-scratch:
	docker run -it --rm --privileged tqxr/python3610-centos-scratch
python3-centos:
	docker run -it --rm --privileged tqxr/python3610-centos

# build from github master branch on centos
# privileged so we can strace to figure out things etc
python-master-centos-build:
	docker run -it --rm --privileged tqxr/python-master-centos-build
python-master-centos:
	docker run -it --rm --privileged tqxr/python-master-centos


# ARCH based images
#
# -- from source: master branch from github

wget-python-master:
	if [ ! -f master/master.zip ] ; then \
		wget https://github.com/python/cpython/archive/master.zip -O master/master.zip ;\
	fi

image-python-master-arch-build: wget-python-master image-arch-build-base
	cd master && \
	tar cvf - master.zip python-master-arch-build.Dockerfile | \
		docker build -t tqxr/python-master-arch-build \
		-f python-master-arch-build.Dockerfile \
		-

# invoke with `WITH_STRACE=yes make image-python-master-arch`
# and the image build will include strace
WITH_STRACE ?= 'no'
image-python-master-arch: image-python-master-arch-build
	cat arch/python-master-arch.Dockerfile | docker \
		build --build-arg WITH_STRACE=$(WITH_STRACE) -t tqxr/python-master-arch -

python-master-arch-build:
	docker run -it --rm tqxr/python-master-arch-build
python-master-arch:
	docker run -it --rm tqxr/python-master-arch
strace-python-master-arch:
	docker run -it --rm --privileged --entrypoint /bin/strace \
		tqxr/python-master-arch /python -i

# specific source release from python.org

image-373-build: image-arch-build-base
	cat arch-python-ver-build.Dockerfile | docker build -t tqxr/python-373-build -

image-373: image-373-build
	cat python-ver.Dockerfile | docker build -t tqxr/python-373 -



tqxr/cpython-master: image-python-master-arch
	@:

tqxr/cpython-373: image-373
	@:


run-master:
	docker run -it --rm tqxr/python-master-arch

run:
	docker run -it --rm tqxr/python-373


# Careful! These are running privileged so we can
# strace all the things

alpine:
	docker run -it --rm --privileged tqxr/alpine-build-base
centos:
	docker run -it --rm --privileged tqxr/centos-build-base
arch:
	docker run -it --rm --privileged tqxr/arch-build-base

clean:
	rm -f master/master.zip
	docker rmi tqxr/alpine-build-base
	docker rmi tqxr/python-master-centos-build tqxr/python-master-centos tqxr/centos-build-base
	docker rmi tqxr/python-master-arch-build tqxr/python-master-arch tqxr/arch-build-base
	docker rmi tqxr/python-373 tqxr/python-373-build


.PHONY: alpine centos arch
