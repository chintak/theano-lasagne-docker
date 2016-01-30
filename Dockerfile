# Start with Ubuntu base image
FROM chintak/cuda-docker:7.5
MAINTAINER Chintak Sheth <chintaksheth@gmail.com>

# Install wget and build-essential
RUN apt-get update && apt-get install -y \
  software-properties-common python-software-properties \
&& add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" \
&& add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" \
&& apt-get update && apt-get install -y \
  build-essential \
  checkinstall \
  cmake \
  libatlas-base-dev \
  libatlas-dev \
  libatlas3gf-base \
  libavcodec-dev \
  libavformat-dev \
  libblas-dev \
  libdc1394-22-dev \
  libeigen3-dev \
  libfaac-dev \
  libgstreamer-plugins-base0.10-dev \
  libgstreamer0.10-dev \
  libgtk2.0-dev \
  libjasper-dev \
  libjpeg-dev \
  libmp3lame-dev \
  libopenblas-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  libopencv-dev \
  libqt4-dev \
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
  unzip \
  v4l-utils \
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
RUN pip install -r /tmp/requirements.txt \
&& pip install -r https://raw.githubusercontent.com/dnouri/nolearn/master/requirements.txt \
&& pip install git+https://github.com/dnouri/nolearn.git@master#egg=nolearn==0.7.git \
&& rm -rf *

EXPOSE 8888
# Build opencv
RUN cd /tmp \
&& wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.9/opencv-2.4.9.zip \
&& unzip opencv-2.4.9.zip && rm opencv-2.4.9.zip* \
&& cd opencv-2.4.9 && mkdir build && cd build \
&& cmake -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D WITH_VTK=ON .. \
&& make -j4 && sudo make install \
&& sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf' && ldconfig \
&& echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig" >> ~/.bashrc \
&& cd .. \
&& rm -r opencv*

# Install caffe
ENV CAFFE_VERSION 0.13.2
RUN cd /root && git clone https://github.com/NVIDIA/caffe.git && cd /root/caffe \
&& git checkout tags/v${CAFFE_VERSION} -b v${CAFFE_VERSION} \
&& make -j8 all \
&& make -j8 py \
&& echo "export CAFFE_HOME=/root/caffe" >> /root/.bashrc \
&& echo "export LD_LIBRARY_PATH=$CAFFE_HOME/lib:$LD_LIBRARY_PATH" >> /root/.bashrc \
&& echo "export PYTHONPATH=$CAFFE_HOME/python:$PYTHONPATH" >> /root/.bashrc \
&& echo "export PATH=$CAFFE_HOME/tools/:$PATH" >> /root/.bashrc
