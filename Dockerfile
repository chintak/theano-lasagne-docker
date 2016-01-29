FROM python:2.7.10
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

RUN apt-get update && apt-get install -y \
  tmux \
  vim \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY requirements-dep.txt .
RUN pip install --upgrade pip && \
  pip install -r requirements-dep.txt

COPY requirements.txt .
RUN pip install -r requirements.txt && \
  pip install -r https://raw.githubusercontent.com/dnouri/nolearn/master/requirements.txt && \
  pip install git+https://github.com/dnouri/nolearn.git@master#egg=nolearn==0.7.git && \
  rm -rf *

EXPOSE 8888
