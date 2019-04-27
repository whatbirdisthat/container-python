# A pretty small python REPL

---

### Lessons from this exercise:

> `readelf -l` `strace` and `ldd` are your friends.
> `ldd` is really useful - try `cat $(which ldd)` to see what it actually is

Building a tiny container image is mostly pointless, unless you
want to build really tiny images. I think it's really neat.

---

* Clone

```bash
git clone git@github.com:whatbirdisthat/container-python
```

* Build

```bash
make image-python-master-arch
```

* Run

```bash
make python-master-arch
```

---

> There are other Dockerfiles in this repo, and other make targets.
> This was mostly experimentation, to find out what it would take
> to build a python container from various distros, sources, etc

```
:)
```

---

# 14.9mb
And there are more things I could strip out if I really wanted to.

## Take away:
## `What does this container *actually need to do*`

---
