# SPDX-License-Identifier: MIT
#
# Copyright (c) 2026 Christian Ege
#
ARG CPP_IMAGE_VERSION=2.0.0
FROM ghcr.io/graugans/cpp:${CPP_IMAGE_VERSION}

ARG USERNAME=dev

USER root

# install STM32 embedded tooling for cortex-m3 / stm32f103 development
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc-arm-none-eabi \
        binutils-arm-none-eabi \
        gdb-multiarch \
        libnewlib-arm-none-eabi \
        libstdc++-arm-none-eabi-newlib \
        openocd \
        stlink-tools \
        cppcheck \
        python3 \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

# provide a ready-to-use CMake toolchain for STM32F103 targets
RUN mkdir -p /opt/toolchains \
    && cat <<'EOF' > /opt/toolchains/stm32f103-gcc-toolchain.cmake
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(TOOLCHAIN_PREFIX arm-none-eabi)
set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_AR           ${TOOLCHAIN_PREFIX}-ar)
set(CMAKE_OBJCOPY      ${TOOLCHAIN_PREFIX}-objcopy)
set(CMAKE_OBJDUMP      ${TOOLCHAIN_PREFIX}-objdump)
set(CMAKE_SIZE         ${TOOLCHAIN_PREFIX}-size)

set(CPU_FLAGS "-mcpu=cortex-m3 -mthumb")

set(CMAKE_C_FLAGS_INIT "${CPU_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${CPU_FLAGS} -fno-exceptions -fno-rtti")
set(CMAKE_ASM_FLAGS_INIT "${CPU_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS_INIT "${CPU_FLAGS} -Wl,--gc-sections")
EOF

# helper entrypoint for openocd with common stm32f103 + st-link setup
RUN cat <<'EOF' > /usr/local/bin/stm32f103-openocd
#!/usr/bin/env bash
set -euo pipefail
exec openocd -f interface/stlink.cfg -f target/stm32f1x.cfg "$@"
EOF
RUN chmod +x /usr/local/bin/stm32f103-openocd

USER $USERNAME
WORKDIR /home/$USERNAME

RUN echo 'export STM32F103_CMAKE_TOOLCHAIN_FILE=/opt/toolchains/stm32f103-gcc-toolchain.cmake' >> /home/$USERNAME/.bashrc \
    && echo "alias openocd-stm32f103='stm32f103-openocd'" >> /home/$USERNAME/.bashrc \
    && echo "alias gdb-stm32='gdb-multiarch'" >> /home/$USERNAME/.bashrc
