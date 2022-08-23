FROM ubuntu:18.04
#docker run --platform linux/x86_64 <image>
WORKDIR /app

RUN apt-get update && apt-get install -y python3.7 python3-pip git zlib1g-dev perl gcc make libdbi-perl
RUN pip3 install --upgrade pip

RUN pip install numpy cython

#SVDB
RUN pip install SVDB

#RetroSeq
RUN git clone https://github.com/kristinebilgrav/RetroSeq.git
ENV PATH="/RetroSeq/bin:${PATH}"
