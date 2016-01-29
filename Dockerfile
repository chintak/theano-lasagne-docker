FROM python:2.7.10
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

WORKDIR /tmp/
COPY requirements.txt .
RUN pip install -i requirements.txt

WORKDIR /root
