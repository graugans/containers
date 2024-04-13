# SPDX-License-Identifier: MIT
#
# Copyright (c) 2024 Christian Ege
# Copyright (c) 2023 Benjamin Wilking

FROM golang:1.22-bookworm

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
                          wget \
                          curl \
                          lsb-release \
                          software-properties-common \
                          gnupg \
                          unzip \
                          fontconfig \
                          fonts-noto \
                          bash-completion \
                          locales \
                          jq \
    && rm -rf /var/lib/apt/lists/*

# set Locale to en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# set user to start and working directory
USER $USERNAME
WORKDIR /home/$USERNAME

# bring in a nice shell prompt
COPY ./prompt.sh /home/dev/.prompt
RUN echo 'source /home/dev/.prompt' >> /home/dev/.bashrc
RUN echo 'export PATH=/usr/local/go/bin:$PATH' >> /home/dev/.bashrc

# Install Go Tools
#  gotests
RUN go install github.com/cweill/gotests/gotests@latest \
    && go install github.com/fatih/gomodifytags@latest \
    && go install github.com/josharian/impl@latest \
    && go install github.com/haya14busa/goplay/cmd/goplay@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install golang.org/x/tools/gopls@latest \
    && go install github.com/ramya-rao-a/go-outline@latest \
    && go install github.com/spf13/cobra-cli@latest \
    && go install -v golang.org/x/tools/cmd/godoc@latest \
    && go install github.com/godoctor/godoctor@latest \
    && go install github.com/goreleaser/goreleaser@latest \
    && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.55.2




# Install bash autocompletion for some go tools
COPY ./bash_completion.sh /home/dev/.bash_completion
RUN mkdir  /home/dev/.bash_completion.d \
    && echo 'source /home/dev/.bash_completion' >> /home/dev/.bashrc \
    && cobra-cli completion bash > /home/dev/.bash_completion.d/cobra-cli

# configure the git default branch name
RUN git config --global init.defaultBranch main
