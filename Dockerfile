FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    bash \
    bc \
    binutils \
    bzip2 \
    cpio \
    g++ \
    gcc \
    git \
    gzip \
    locales \
    libncurses5-dev \
    libdevmapper-dev \
    libsystemd-dev \
    make \
    mercurial \
    whois \
    patch \
    perl \
    python3 \
    rsync \
    sed \
    tar \
    vim \ 
    unzip \
    wget \
    bison \
    flex \
    libssl-dev \
    libfdt-dev \
    nano \
    graphviz \
    python3-pip

# This packages are required to run `utils/scanpypi` to
# fetch a python-package from the PyPI repository:
# https://pypi.python.org/
# and to improve its licenses detection.
RUN pip install six spdx_lookup

# Sometimes Buildroot need proper locale, e.g. when using a toolchain
# based on glibc.
RUN locale-gen en_US.utf8

# This will be a folder used to link content from the host related to
# Buildroot's external mechanism
RUN mkdir -p /buildroot_externals

WORKDIR /root/buildroot

ENV O=/buildroot_output

RUN touch .config
RUN touch kernel.config

# This will be volume that will contain Buildroot's results
VOLUME /buildroot_output

RUN ["/bin/bash"]
