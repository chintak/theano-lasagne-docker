# Start with Ubuntu base image
FROM chintak/cuda-docker:7.5
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

# Install wget and build-essential
RUN apt-get update && apt-get install -y \
  software-properties-common python-software-properties \
&& add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" \
&& add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" \
&& apt-get update && apt-get install -y --force-yes \
  build-essential \
  checkinstall \
  cmake \
  gfortran \
  git \
  libatlas-base-dev \
  libatlas-dev \
  libatlas3gf-base \
  libavcodec-dev \
  libavformat-dev \
  libblas-dev \
  libboost-all-dev \
  libdc1394-22-dev \
  libeigen3-dev \
  libfaac-dev \
  libffi-dev \
  libgflags-dev \
  libgoogle-glog-dev \
  libgflags-dev libgoogle-glog-dev \
  libprotobuf-dev protobuf-compiler \
  libatlas-base-dev \
  libgstreamer-plugins-base0.10-dev \
  libgstreamer0.10-dev \
  libjasper-dev \
  libjpeg-dev \
  libleveldb-dev libsnappy-dev liblmdb-dev libhdf5-serial-dev \
  libmp3lame-dev \
  libopenblas-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libopencv-dev \
  libopenexr-dev \
  libprotobuf-dev protobuf-compiler \
  libssl-dev \
  libswscale-dev \
  libtbb-dev \
  libtheora-dev \
  libtiff5-dev \
  libv4l-dev \
  libvorbis-dev \
  libx264-dev \
  libxine2-dev \
  libxvidcore-dev \
  pkg-config \
  python \
  python-dev \
  python-pip \
  openssl \
  tmux \
  unzip \
  v4l-utils \
  vim \
  wget \
  yasm \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Build numpy, scipy and matplotlib
COPY requirements-dep.txt /tmp/
RUN pip install --upgrade pip && \
  pip install -r /tmp/requirements-dep.txt

# Build theano, nolearn and lasagne
COPY requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt
RUN wget -O req.txt https://raw.githubusercontent.com/dnouri/nolearn/master/requirements.txt \
&& pip install -r req.txt \
&& pip install git+https://github.com/dnouri/nolearn.git@master#egg=nolearn==0.7.git \
&& rm -rf /tmp/*

EXPOSE 8888
# Build opencv
WORKDIR /tmp
RUN wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.9/opencv-2.4.9.zip \
&& unzip opencv-2.4.9.zip && rm opencv-2.4.9.zip* \
&& mkdir opencv-2.4.9/build

WORKDIR opencv-2.4.9/build
RUN cmake -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_GTK=OFF -D WITH_CUDA=OFF .. \
&& make -j8 && make -j8 install
RUN sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf' && ldconfig

WORKDIR /tmp
RUN rm -rf opencv*

# Install caffe
WORKDIR /root
ENV CAFFE_VERSION 0.13.2
RUN wget https://github.com/NVIDIA/caffe/archive/v${CAFFE_VERSION}.zip \
&& unzip v${CAFFE_VERSION}.zip \
&& rm v${CAFFE_VERSION}.zip
WORKDIR caffe-${CAFFE_VERSION}

RUN for req in $(cat python/requirements.txt); do pip install $req; done
RUN cp Makefile.config.example Makefile.config \
&& make -j8 all \
&& make -j8 py
ENV CAFFE_HOME /root/caffe-0.13.2

RUN echo "export CAFFE_HOME=$CAFFE_HOME" >> /root/.bashrc \
&& echo "export CUDA_HOME=$CUDA_HOME" >> /root/.bashrc \
&& echo "export LD_LIBRARY_PATH=\$CAFFE_HOME/lib:\$CUDA_HOME/lib64:\$LD_LIBRARY_PATH" >> /root/.bashrc \
&& echo "export PYTHONPATH=\$CAFFE_HOME/python:\$PYTHONPATH" >> /root/.bashrc \
&& echo "export PATH=\$CAFFE_HOME/tools/:\$PATH" >> /root/.bashrc \
&& echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> ~/.bashrc

WORKDIR /root
CMD ["/bin/bash"]
