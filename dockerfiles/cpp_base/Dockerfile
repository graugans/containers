# SPDX-License-Identifier: MIT
#
# Copyright (c) 2026 Christian Ege
# Copyright (c) 2023 Benjamin Wilking
ARG DEBIAN_CODENAME=trixie

FROM debian:${DEBIAN_CODENAME}-slim
ARG DEBIAN_CODENAME
ARG LLVM_VERSION=22
ARG CMAKE_VERSION=4.4.0

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# fix the timezone asking when creating the container
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -s /bin/bash -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# install everythin we need
RUN \
    apt-get -y update \
    && apt-get install -y git \
                          build-essential \
                          gdb \
                          lldb \
                          ninja-build \
                          ccache \
                          wget \
                          curl \
                          lsb-release \
                          gnupg \
                          unzip \
                          fontconfig \
                          fonts-noto \
                          bash-completion \
                          locales \
                          libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# set Locale to en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en

# bring in latest clang toolchain
# Please check https://github.com/llvm/llvm-project/issues/62475 for the details
# bring in latest clang toolchain
RUN set -eux; \
    echo "deb http://apt.llvm.org/${DEBIAN_CODENAME}/ llvm-toolchain-${DEBIAN_CODENAME}-${LLVM_VERSION} main" > /etc/apt/sources.list.d/apt.llvm.org.list; \
    wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc; \
    apt update \
    && apt-get install -y clang-${LLVM_VERSION} \
                          lldb-${LLVM_VERSION} \
                          lld-${LLVM_VERSION} \
                          clangd-${LLVM_VERSION} \
                          clang-tidy-${LLVM_VERSION} \
                          clang-format-${LLVM_VERSION} \
                          clang-tools-${LLVM_VERSION} \
                          llvm-${LLVM_VERSION}-dev \
                          lld-${LLVM_VERSION} \
                          lldb-${LLVM_VERSION} \
                          llvm-${LLVM_VERSION}-tools \
                          libomp-${LLVM_VERSION}-dev \
                          libc++-${LLVM_VERSION}-dev \
                          libc++abi-${LLVM_VERSION}-dev \
                          libclang-common-${LLVM_VERSION}-dev \
                          libclang-${LLVM_VERSION}-dev \
                          libclang-cpp${LLVM_VERSION}-dev \
                          libunwind-${LLVM_VERSION}-dev \
                          libclang-rt-${LLVM_VERSION}-dev \
                          libpolly-${LLVM_VERSION}-dev \
    && rm -rf /var/lib/apt/lists/*

# bring in latest cmake
RUN set -eux; \
    CMAKE_SERIES="${CMAKE_VERSION%.*}"; \
    wget -qO- "https://cmake.org/files/v${CMAKE_SERIES}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr

# Install the {fmt} lib
RUN cd /usr/src && git clone --depth 1 --branch 12.2.0 https://github.com/fmtlib/fmt.git \
    && cd fmt \
    && cmake -B build -DBUILD_SHARED_LIBS=TRUE \
            -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE \
            -D CMAKE_INSTALL_PREFIX=/usr \
            -GNinja \
    && cmake --build build \
    && cmake --install build \
    && cd /usr/src \
    && rm -rf fmt

# Install the spdlog lib
RUN cd /usr/src && git clone --depth 1 --branch v1.17.0 https://github.com/gabime/spdlog.git \
    && cd spdlog \
    && cmake -B build -DSPDLOG_FMT_EXTERNAL=ON \
             -DBUILD_SHARED_LIBS=ON \
             -DSPDLOG_BUILD_PIC=ON \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja \
    && cmake --build build \
    && cmake --install build \
    && cd /usr/src \
    && rm -rf spdlog

# Install the Catch2 testing framework
RUN cd /usr/src && git clone --depth 1 --branch v3.16.1 https://github.com/catchorg/Catch2.git catch2\
    && cd catch2 \
    && cmake -B build -DBUILD_TESTING=OFF \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja \
    && cmake --build build \
    && cmake --install build \
    && cd /usr/src \
    && rm -rf catch2

# Install the CLI11 lib
RUN cd /usr/src && git clone --depth 1 --branch v2.7.2 https://github.com/CLIUtils/CLI11.git cli11 \
    && cd cli11 \
    && cmake -B build -DCLI11_BUILD_TESTS=OFF \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja \
    && cmake --build build \
    && cmake --install build \
    && cd /usr/src \
    && rm -rf cli11

# Install the Nlohman JSON lib
RUN cd /usr/src && git clone --depth 1 --branch v3.12.0 https://github.com/nlohmann/json.git\
    && cd json \
    && cmake -B build -DBUILD_TESTING=OFF \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja \
    && cmake --build build \
    && cmake --install build \
    && cd /usr/src \
    && rm -rf json



# set user to start and working directory
USER $USERNAME
WORKDIR /home/$USERNAME

# bring in a nice shell prompt
COPY ./prompt.sh /home/dev/.prompt
RUN echo 'source /home/dev/.prompt' >> /home/dev/.bashrc

# configure the git default branch name
RUN git config --global init.defaultBranch main
