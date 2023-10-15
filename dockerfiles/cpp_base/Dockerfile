# SPDX-License-Identifier: MIT
#
# Copyright (c) 2023 Christian Ege
# Copyright (c) 2023 Benjamin Wilking

FROM debian:bookworm-slim

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# fix the timezone asking when creating the container
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
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
                          software-properties-common \
                          gnupg \
                          unzip \
                          fontconfig \
    && rm -rf /var/lib/apt/lists/*

# bring in latest clang toolchain
# Please check https://github.com/llvm/llvm-project/issues/62475 for the details
RUN set -ex &&\
    echo "deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-16 main" > /etc/apt/sources.list.d/apt.llvm.org.list \
    && wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key |  tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc \
    && apt update \
    && apt-get install -y clang-16 \
                          lldb-16 \
                          lld-16 \
                          clangd-16 \
                          clang-tidy-16 \
                          clang-format-16 \
                          clang-tools-16 \
                          llvm-16-dev \
                          lld-16 \
                          lldb-16 \
                          llvm-16-tools \
                          libomp-16-dev \
                          libc++-16-dev \
                          libc++abi-16-dev \
                          libclang-common-16-dev \
                          libclang-16-dev \
                          libclang-cpp16-dev \
                          libunwind-16-dev \
                          libclang-rt-16-dev \
                          libpolly-16-dev \
    && rm -rf /var/lib/apt/lists/*

# bring in latest cmake
RUN wget -qO- "https://cmake.org/files/v3.27/cmake-3.27.0-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr

# Install the {fmt} lib
RUN cd /usr/src && git clone --depth 1 --branch 10.1.1 https://github.com/fmtlib/fmt.git \
    && cd fmt \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_SHARED_LIBS=TRUE \
            -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE \
            -D CMAKE_INSTALL_PREFIX=/usr \
            -GNinja  .. \
    && ninja \
    && ninja install \
    && cd /usr/src \
    && rm -rf fmt

# Install the spdlog lib
RUN cd /usr/src && git clone --depth 1 --branch v1.12.0 https://github.com/gabime/spdlog.git \
    && cd spdlog \
    && mkdir build \
    && cd build \
    && cmake -DSPDLOG_FMT_EXTERNAL=ON \
             -DBUILD_SHARED_LIBS=ON \
             -DSPDLOG_BUILD_PIC=ON \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja  .. \
    && ninja \
    && ninja install \
    && cd /usr/src \
    && rm -rf spdlog

# Install the Catch2 testing framework
RUN cd /usr/src && git clone --depth 1 --branch v3.4.0 https://github.com/catchorg/Catch2.git catch2\
    && cd catch2 \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_TESTING=OFF \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja  .. \
    && ninja \
    && ninja install \
    && cd /usr/src \
    && rm -rf catch2

# Install the CLI11 lib
RUN cd /usr/src && git clone --depth 1 --branch v2.3.2 https://github.com/CLIUtils/CLI11.git cli11 \
    && cd cli11 \
    && mkdir build \
    && cd build \
    && cmake -DCLI11_BUILD_TESTS=OFF \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja  .. \
    && ninja \
    && ninja install \
    && cd /usr/src \
    && rm -rf cli11

# Install the Nlohman JSON lib
RUN cd /usr/src && git clone --depth 1 --branch v3.11.2 https://github.com/nlohmann/json.git\
    && cd json \
    && mkdir build \
    && cd build \
    && cmake -DBUILD_TESTING=OFF \
             -D CMAKE_INSTALL_PREFIX=/usr \
             -GNinja  .. \
    && ninja \
    && ninja install \
    && cd /usr/src \
    && rm -rf json



# set user to start and working directory
USER $USERNAME
WORKDIR /home/$USERNAME

RUN wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip \
    && unzip FiraCode.zip -d ~/.fonts && rm FiraCode.zip \
    && fc-cache -fv


# bring in a nice shell prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y\
    && echo 'eval "$(starship init bash)"' >> /home/dev/.bashrc

# configure the git default branch name
RUN git config --global init.defaultBranch main