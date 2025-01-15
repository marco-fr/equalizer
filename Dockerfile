FROM ubuntu:latest

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
                        autoconf \
                        bc \
                        bison \
                        build-essential \
                        ca-certificates \
                        ccache \
                        flex \
                        git \
                        help2man \
                        libfl2 \
                        libfl-dev \
                        libgoogle-perftools-dev \
                        numactl \
                        perl \
                        perl-doc \
                        python3 \
                        zlib1g \
                        zlib1g-dev \
                        verilator \
    && apt-get clean

WORKDIR /work

ENTRYPOINT ["bash", "-l", "-c"]