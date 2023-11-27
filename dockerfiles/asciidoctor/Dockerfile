# SPDX-License-Identifier: MIT
#
# Copyright (c) 2023 Christian Ege

FROM ghcr.io/graugans/base:latest

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# install everythin we need
RUN apt-get -y update \
    && apt-get install -y ruby \
                          ruby-dev \
                          ruby-bundler \
                          python3-blockdiag \
                          build-essential \
                          graphviz \
                          npm \
    && rm -rf /var/lib/apt/lists/*

# Install the Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli

# set user to start and working directory
USER $USERNAME
WORKDIR /home/$USERNAME

# configure the git default branch name
RUN git config --global init.defaultBranch main



# Install Asciidoctor
COPY  ./Gemfile /usr/src/asciidoctor/
RUN cd /usr/src/asciidoctor \
    && sudo bundle