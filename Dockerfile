FROM ubuntu

RUN echo 'installing dependencies'
RUN apt update
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt install -y build-essential unzip cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
    libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev wget git python3 python3-pip ffmpeg libsm6 libxext6 curl

WORKDIR /source
RUN echo 'Compiling opencv'
RUN git clone https://github.com/opencv/opencv
WORKDIR /source/opencv
RUN git checkout 3.4.1
RUN mkdir /source/opencv/build
WORKDIR /source/opencv/build
RUN cmake .. && make && make install

WORKDIR /source
RUN echo 'alias python=python3' > /root/.bashrc
RUN pip install numpy opencv-python

RUN echo 'Unfortunately, it is not possible to mount host dir during build. Please use "--mount type=bind,source=<host dir>,target=/test" when starting the docker. You can run sh OneClick.sh after'