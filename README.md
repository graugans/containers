# containers

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository provides development containers for the *Software Development*

The containers are meant to be used e.g. as **VSCode Devcontainers** (using [GitHub Codespaces](https://docs.github.com/en/codespaces/overview), [GitPod](https://gitpod.io/), locally, or the like)

## C++ Container

The [C++ base contaier](dockerfiles/cpp_base) defines a container which can be used for C++ programming tasks.

```sh
docker run -it ghcr.io/graugans/cpp:latest
```

## STM32F103 C++ Container

The [STM32F103 container](dockerfiles/stm32f103) extends the C++ base image and is meant for embedded C++ development on STM32F103 (Cortex-M3) targets.

Included helpful tooling:

- cross-compiler toolchain: `gcc-arm-none-eabi`, `binutils-arm-none-eabi`
- debugging: `gdb-multiarch`
- flashing/debug server: `openocd`, `stlink-tools`
- static analysis: `cppcheck`
- preconfigured CMake toolchain file: `/opt/toolchains/stm32f103-gcc-toolchain.cmake`

```sh
docker run -it --rm \
  --privileged \
  --device /dev/bus/usb \
  ghcr.io/graugans/stm32f103:latest
```

Inside the container you can use:

- `openocd-stm32f103` for the default ST-Link + STM32F1 OpenOCD setup
- `gdb-stm32` as shorthand for `gdb-multiarch`

## License

This project is licensed under the [MIT license](LICENSE).