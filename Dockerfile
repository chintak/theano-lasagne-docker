# Start with Ubuntu base image
FROM chintak/cuda-docker:7.5
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

# Install wget and build-essential
RUN apt-get update && apt-get install -y \
  ant \
  cmake \
  default-jdk \
  gfortran \
  git \
  libatlas-base-dev \
  libatlas-dev \
  libatlas3gf-base \
  libavcodec-dev \
  libavformat-dev \
  libblas-dev checkinstall \
  libblas-doc checkinstall \
  libdc1394-22-dev \
  libeigen3-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  libgtk2.0-dev \
  libjasper-dev \
  libjpeg-dev \
  liblapack-doc checkinstall \
  liblapacke-dev checkinstall \
  libleveldb-dev libsnappy-dev liblmdb-dev libhdf5-serial-dev \
  libopenblas-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libopencv-dev \
  libopenexr-dev \
  libprotobuf-dev protobuf-compiler \
  libqt4-dev \
  libqt4-opengl-dev \
  libswscale-dev \
  libtbb-dev \
  libtheora-dev \
  libtiff4-dev \
  libv4l-dev \
  libvorbis-dev \
  libvtk5-qt4-dev \
  libx264-dev \
  libxvidcore-dev \
  python \
  python-dev \
  python-pip \
  python-tk \
  sphinx-common \
  texlive-latex-extra \
  tmux \
  vim \
  yasm \
  zip \
&& apt-get install --no-install-recommends -y libboost-all-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Build numpy, scipy and matplotlib
COPY requirements-dep.txt /tmp/
RUN pip install --upgrade pip && \
  pip install -r /tmp/requirements-dep.txt
# Build theano, nolearn and lasagne
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt && \
  pip install -r https://raw.githubusercontent.com/dnouri/nolearn/master/requirements.txt && \
  pip install git+https://github.com/dnouri/nolearn.git@master#egg=nolearn==0.7.git && \
  rm -rf *

EXPOSE 8888
