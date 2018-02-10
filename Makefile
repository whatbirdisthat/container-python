exec = python
item = python27
image = wbit/$(item)

clean:
	docker rmi $(image)
	rm /usr/local/bin/$(exec)

define RUN_COMMAND

#!/bin/bash
docker run -it --rm        \
	-v `pwd`:`pwd` -w `pwd`  \
	$(image) "$$@"

endef

export RUN_COMMAND

install:
	docker build -t $(image) .
	echo "$$RUN_COMMAND" > "/usr/local/bin/${exec}"
	@chmod u+x "/usr/local/bin/${exec}"
