SYSTEM_PYTHON := $(shell which python2)
VENV          := venv
PIP           := pip
DOCKER_IMAGE  := sftpclient:latest
PWD           := $(shell pwd)

venv:
	$(SYSTEM_PYTHON) -m virtualenv $(VENV)
	$(PIP) install --upgrade pip wheel

.PHONY: install
install:
	$(PIP) install -r requirements.txt -c constraints.txt
	$(PIP) install -e .[test]

.PHONY: test
test:
	pytest tests

.PHONY: constraints.txt
constraints.txt:
	$(PIP) freeze \
		--exclude-editable \
		--exclude pp-sftpclient > constraints.txt


.PHONY: docker-build
docker-build:
	docker build . -t $(DOCKER_IMAGE)

.PHONY: docker-test
docker-test:
	docker run -it \
		-v $(PWD)/sftpclient:/project/sftpclient \
		-v $(PWD)/tests:/project/tests \
		$(DOCKER_IMAGE) \
		venv/bin/pytest tests/
