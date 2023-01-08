FROM python:3.8

RUN apt-get update \
 && apt-get install -y libssh2-1-dev

WORKDIR /project
ADD requirements.txt constraints.txt ./

RUN python3 -m venv venv \
 && venv/bin/python -m pip install --upgrade pip wheel \
 && venv/bin/python -m pip install -r requirements.txt -c constraints.txt

ADD setup.py ./
ADD sftpclient ./sftpclient

RUN venv/bin/python -m pip install -e .[test]
