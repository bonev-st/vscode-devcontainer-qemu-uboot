# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-lc"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo ca-certificates gnupg curl wget git nano xz-utils file \
    build-essential bc bison flex \
    device-tree-compiler swig graphviz imagemagick \
    libssl-dev libgnutls28-dev libncurses-dev pkg-config \
    python3 python3-venv python3-pip \
    python3-asteval python3-coverage python3-filelock \
    python3-pkg-resources python3-pycryptodome python3-pyelftools \
    python3-pytest python3-pytest-xdist python3-sphinxcontrib.apidoc \
    python3-sphinx-rtd-theme python3-subunit python3-testtools \
    ninja-build \
    libsdl2-dev \
    uuid-dev \
    libguestfs-tools \
    gdisk \
    lz4 \
    openssl \
    coccinelle \
    rsync \
    # helpful extras
    less vim tmux unzip ripgrep \
    dfu-util efitools liblz4-tool libpython3-dev lzma lzma-alone

RUN apt-get update && apt-get install -y \
	libncursesw5 \
	gdb-multiarch \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user matching VS Code defaults
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspaces/project

# Default shell
ENV TERM xterm-256color
