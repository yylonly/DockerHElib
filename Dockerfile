FROM buildpack-deps

LABEL Description="MCloud HElib"

RUN apt-get update && apt install cmake -y

# For Mount you code
RUN mkdir /sourcerepo
VOLUME /sourcerepo

# GMP: C++ Multiple Precision Arithmetic Library
RUN wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2 \
    && tar -jxvf gmp-6.1.2.tar.bz2 \
    && cd gmp-6.1.2 \
    && ./configure --prefix=/usr/local/gmp \
    && make \
    && make check \
    && make install \
    && cd /

# NTL: C++ A Library for doing Number Theory
RUN wget http://www.shoup.net/ntl/ntl-10.5.0.tar.gz \
	&& tar -zxvf ntl-10.5.0.tar.gz \
	&& cd ntl-10.5.0/src \
	&& ./configure PREFIX=/usr/local/ntl NTL_GMP_LIP=on GMP_PREFIX=/usr/local/gmp NTL_THREAD_BOOST=on \
	&& make \
	&& make install \
	&& cd / 

# HELib: C++ Homomorphic Encryption Library
RUN git clone https://github.com/shaih/HElib 
COPY Makefile /HElib/src
Run cd HElib/src \
	&& make \
	&& make check \
	&& cd /

# Eigen: C++ Matrix Library 
# Install in /usr/local/include/eigen3/Eigen
RUN wget http://bitbucket.org/eigen/eigen/get/3.3.4.tar.gz \
    && tar -zxvf 3.3.4.tar.gz \
	&& cd eigen-eigen-5a0156e40feb \
	&& mkdir build \
	&& cd build \
	&& cmake .. \
	&& make install \
	&& cd / 
