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
    && rm -rf /var/lib/apt/lists/*

# set Locale to en_US.UTF-8
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en


# bring in a nice shell prompt
COPY --chown=${USER_UID}:${USER_GID}  ./prompt.sh /home/dev/.prompt
RUN echo 'source /home/dev/.prompt' >> /home/dev/.bashrc \
    $$ chown ${USER_UID}:${USER_GID} /home/dev/.bashrc
