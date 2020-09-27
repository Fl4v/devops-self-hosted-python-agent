FROM python:3.7-buster

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libunwind8 \
        netcat \
        software-properties-common \
        zip \
        wget

WORKDIR /azp

# Get Python from ftp server
RUN wget https://www.python.org/ftp/python/3.7.9/Python-3.7.9.tgz \
https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tgz

# Extract archives
RUN tar -xzf Python-3.7.9.tgz \
&& tar -xzf Python-3.8.5.tgz

# Clean up
RUN rm Python-3.7.9.tgz Python-3.8.5.tgz

RUN cd /azp/Python-3.7.9 \
&& ./configure --prefix=/azp/agent/_work/_tool/Python/3.7.9/x64/ --enable-optimizations --with-ensurepip=install \
&& make -j 8

RUN cd /azp/Python-3.8.5 \
&& ./configure --prefix=/azp/agent/_work/_tool/Python/3.8.5/x64/ --enable-optimizations --with-ensurepip=install \
&& make -j 8

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
