FROM ubuntu:18.04
#docker run --platform linux/x86_64 <image>
WORKDIR /app

RUN apt-get update && apt-get install -y python3.7 python3-pip git zlib1g-dev perl gcc make libdbi-perl wget
RUN pip3 install --upgrade pip
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh && bash Miniconda3-py38_4.10.3-Linux-x86_64.sh -p /miniconda -b
ENV PATH=/miniconda/bin:$PATH
RUN conda update -y conda \
    && rm Miniconda3-py38_4.10.3-Linux-x86_64.sh

RUN conda config --add channels defaults 
RUN conda config --add channels conda-forge 
RUN conda config --add channels bioconda 

RUN conda install -c bioconda pysam bcftools delly 


RUN pip install numpy cython

#MobileAnn
RUN git clone https://github.com/kristinebilgrav/MobileAnn.git
RUN chmod 777 MobileAnn/MobileAnn.py
ENV PATH="/MobileAnn:${PATH}"

#SVDB
RUN pip install SVDB


#RetroSeq
RUN git clone https://github.com/kristinebilgrav/RetroSeq.git
ENV PATH="/RetroSeq/bin:${PATH}"
