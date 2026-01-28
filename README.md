# Advantech BSP configurations registry

[![Validate KAS Configurations](https://github.com/Advantech-EECC/bsp-registry/actions/workflows/validate-kas-configs.yml/badge.svg)](https://github.com/Advantech-EECC/bsp-registry/actions/workflows/validate-kas-configs.yml)
[![Docker containers validation](https://github.com/Advantech-EECC/bsp-registry/actions/workflows/validate-docker-containers.yml/badge.svg)](https://github.com/Advantech-EECC/bsp-registry/actions/workflows/validate-docker-containers.yml)

A Board Support Package (`BSP`) build configuration registry defines environment variables, build systems and configurations to build a BSP images. It ensures that the BSP can be consistently built and customized, providing a structured way to manage hardware features, initialization routines, and software components required for embedded systems. This registry allows reproducible builds across different environments and makes it easier to tailor BSPs for unique hardware platforms while maintaining compatibility with the broader OS stack.

# Table of Contents

- [Advantech BSP configurations registry](#advantech-bsp-configurations-registry)
- [Table of Contents](#table-of-contents)
- [Build System Architecture](#build-system-architecture)
  - [Component Overview](#component-overview)
    - [Details](#details)
- [Supported Hardware](#supported-hardware)
  - [NXP Boards Compatibility Matrix](#nxp-boards-compatibility-matrix)
    - [Alternative View](#alternative-view)
      - [Yocto releases](#yocto-releases)
    - [OTA Update Support](#ota-update-support)
      - [Supported OTA Technologies](#supported-ota-technologies)
      - [OTA Support Matrix](#ota-support-matrix)
      - [Building Images with OTA Support](#building-images-with-ota-support)
- [BSP Registry Manager](#bsp-registry-manager)
  - [Overview](#overview)
  - [Installation](#installation)
  - [Basic Usage](#basic-usage)
  - [Container Management](#container-management)
  - [Configuration File Structure](#configuration-file-structure)
  - [Command Reference](#command-reference)
- [HowTo Assemble BSPs](#howto-assemble-bsps)
  - [Host System dependencies](#host-system-dependencies)
    - [Setup Python virtual environment](#setup-python-virtual-environment)
      - [Advanced Tools for Managing Multiple Python Environments](#advanced-tools-for-managing-multiple-python-environments)
      - [Install Python packages dependencies](#install-python-packages-dependencies)
    - [Setting up Docker engine](#setting-up-docker-engine)
      - [Docker `buildx`](#docker-buildx)
  - [Building BSP](#building-bsp)
    - [Setup build environment](#setup-build-environment)
    - [Overview of shortcuts available in Justfile](#overview-of-shortcuts-available-in-justfile)
    - [Running BSP build](#running-bsp-build)
    - [Running Modular BSP build](#running-modular-bsp-build)
    - [Bitbake development shell](#bitbake-development-shell)
  - [HowTo build a BSP using KAS](#howto-build-a-bsp-using-kas)
    - [Building a BSP image using KAS in a container](#building-a-bsp-image-using-kas-in-a-container)
    - [Bitbake development shell](#bitbake-development-shell-1)
- [Advanced Topics](#advanced-topics)
  - [Export KAS configuration](#export-kas-configuration)
  - [Lock KAS configuration](#lock-kas-configuration)
  - [Reusing BSP Registry configurations](#reusing-bsp-registry-configurations)
- [Links](#links)

---

# Build System Architecture

Build System Architecture defines the structure and workflow of how source code, configurations, and dependencies are transformed into deployable artifacts.

## Component Overview

The build system follows a layered architecture that ensures reproducibility, isolation, and maintainability:

```bash
┌─────────────────────────────────────────┐
│         BSP Registry Manager            │  # BSP management and container orchestration
├─────────────────────────────────────────┤
│            Justfile Recipes             │  # User-facing commands
├─────────────────────────────────────────┤
│          KAS Configuration Files        │  # Build definitions
├─────────────────────────────────────────┤
│         Docker Container Engine         │  # Isolated build environment
├─────────────────────────────────────────┤
│           Yocto Project Build           │  # Core build system
├─────────────────────────────────────────┤
│        Source Layers & Recipes          │  # BSP components
└─────────────────────────────────────────┘
```

### Details

| Layer | Purpose | Key Components |
|-------|---------|----------------|
| **BSP Registry Manager** | BSP management and container orchestration | `bsp.py` script, YAML configuration, container definitions |
| **Justfile Recipes** | User-friendly command interface | `just bsp`, `just mbsp`, `just ota-mbsp` commands |
| **KAS Configuration Files** | Build definitions and dependencies | YAML configs for boards, distros, and features |
| **Docker Container Engine** | Isolated build environment | Consistent toolchains, isolated dependencies |
| **Yocto Project Build** | Core build system | BitBake, OpenEmbedded, meta-layers |
| **Source Layers & Recipes** | BSP components | Machine configs, recipes, kernel, applications |

---

# Supported Hardware

The BSP build system is designed to support a wide range of hardware platforms, including reference boards, evaluation kits, and custom embedded devices. Each supported target is defined through configuration files that specify processor architecture, memory layout, peripherals, and drivers, ensuring that builds are tailored to the unique requirements of the hardware.

## NXP Boards Compatibility Matrix

Table describes in which combinations yocto releases could be used together with boards.

| Board \ Yocto  | walnascar | styhead | scarthgap | mickledore | langdale | kirkstone | Status        |
| -------------- | :-------: | :-----: | :-------: | :--------: | :------: | :-------: | ------------- |
| **RSB3720**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     🟡     | 🟢 Stable      |
| **RSB3720 4G** |     ✅     |    ❌    |     ❌     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **RSB3720 6G** |     ✅     |    ❌    |     ❌     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **RSB3730**    |     ❌     |    ❌    |     ❌     |     ✅      |    ❌     |     ❌     | 🟡 Development |
| **ROM2620**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **ROM5720**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **ROM5721**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **ROM5721 1G** |     ✅     |    ❌    |     ❌     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **ROM5721 2G** |     ✅     |    ❌    |     ❌     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **ROM5722**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **ROM2820**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **AOM5521 A1** |     🟡     |    ❌    |     ✅     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |
| **AOM5521 A2** |     ✅     |    ❌    |     ❌     |     ❌      |    ❌     |     ❌     | 🟢 Stable      |

**Status Legend:**

* 🟢 **Stable**: Production-ready, fully tested and supported
* 🟡 **Development**: Under active development, may have limitations
* 🔴 **EOL**: End of Life, not recommended for new projects

### Alternative View

| **Hardware**   | **Supported Releases** | **Status** | **Documentation** |
|----------------|-------------------------|------------|-------------------|
| **RSB3720**    | walnascar, styhead, scarthgap | 🟢 Stable | [Advantech RSB-3720 Product Page](https://www.advantech.com/en-us/products/5912096e-f242-4b17-993a-1acdcaada6f6/rsb-3720/mod_d2f1b0bc-650b-449a-8ef7-b65ce4f69949) · [User Manual](https://www.manualslib.com/manual/2293645/Advantech-Rsb-3720.html) |
| **RSB3720 4G** | walnascar | 🟢 Stable | *(Same as RSB3720, variant-specific)* |
| **RSB3720 6G** | walnascar | 🟢 Stable | *(Same as RSB3720, variant-specific)* |
| **RSB3730**    | mickledore | 🟡 Development | [Advantech RSB-3730 Product Page](https://www.advantech.com/en-eu/products/5912096e-f242-4b17-993a-1acdcaada6f6/rsb-3730/mod_5d7887e6-b7e3-427c-8729-b81ac7d89ccd) · [RSB-3730 User Manual (PDF)](https://advdownload.advantech.com/productfile/Downloadfile4/1-2HACYHA/RSB-3730_User_Manual_Eng_yocto%20Ed.1_FINAL.pdf) · [Yocto BSP Guide](https://ess-wiki.advantech.com.tw/view/Yocto_Linux_BSP_Ver.A_User_Guide_for_RSB-3730_series-Yocto_4.2) |
| **ROM2620**    | walnascar, styhead, scarthgap | 🟢 Stable | [Advantech ROM-2620 Product Page](https://www.advantech.com/en-eu/products/8fc6f753-ca1d-49f9-8676-10d53129570f/rom-2620/mod_294031c8-4a21-4b95-adf2-923c412ef761) |
| **ROM5720**    | walnascar, styhead, scarthgap | 🟢 Stable | [Advantech ROM-5720 Product Page](https://www.advantech.com/en-eu/products/77b59009-31a9-4751-bee1-45827a844421/rom-5720/mod_4fbfe9fa-f5b2-4ba8-940e-e47585ad0fef) |
| **ROM5721**    | walnascar, styhead, scarthgap | 🟢 Stable | [Advantech ROM-5721 Product Page](https://www.advantech.com/en-eu/products/77b59009-31a9-4751-bee1-45827a844421/rom-5721/mod_271dbc68-878b-486d-85cf-30cc9f1f8f16) |
| **ROM5721 1G** | walnascar | 🟢 Stable | *(Same as ROM5721, variant-specific)* |
| **ROM5721 2G** | walnascar | 🟢 Stable | *(Same as ROM5721, variant-specific)* |
| **ROM5722**    | walnascar, styhead, scarthgap | 🟢 Stable | [Advantech ROM-5722 Product Page](https://www.advantech.com/en-eu/products/77b59009-31a9-4751-bee1-45827a844421/rom-5722/mod_11aa0c77-868e-4014-8151-ac7a7a1c5c1b) |
| **ROM2820**    | walnascar, styhead, scarthgap | 🟢 Stable | [Advantech ROM-2820 Product Page](https://www.advantech.com/en-eu/products/8fc6f753-ca1d-49f9-8676-10d53129570f/rom-2820/mod_bb82922e-d3a2-49d7-80ff-dc57f400185e) |
| **AOM5521 A1** | scarthgap | 🟢 Stable | [Advantech AOM-5521 Product Page](https://www.advantech.com/en-eu/products/77b59009-31a9-4751-bee1-45827a844421/aom-5521/mod_75b36e99-ac3f-4801-8b2b-1706ade1025d) |
| **AOM5521 A1** | walnascar | 🟡 Development | *(Same as above)* |
| **AOM5521 A2** | walnascar | 🟢 Stable | *(Same as above)* |

#### Yocto releases

This list below covers the most recent and commonly referenced Yocto releases:

* [Walnascar (Yocto 5.2)](https://docs.yoctoproject.org/walnascar/releases.html)  
* [Styhead (Yocto 5.1)](https://docs.yoctoproject.org/dev/migration-guides/release-5.1.html)  
* [Scarthgap (Yocto 5.0 LTS)](https://docs.yoctoproject.org/scarthgap/releases.html)  
* [Mickledore (Yocto 4.2)](https://docs.yoctoproject.org/mickledore/releases.html)  
* [Kirkstone (Yocto 4.0 LTS)](https://docs.yoctoproject.org/kirkstone/releases.html)  

The full overview of Yocto releases can be found here https://www.yoctoproject.org/development/releases/

### OTA Update Support

The BSP registry includes Over-The-Air (OTA) update configurations for supported boards. OTA updates enable remote software updates without physical access to devices, critical for production deployments.

#### Supported OTA Technologies

* **RAUC** (Robust Auto-Update Controller): A safe and reliable software update framework that supports atomic updates with rollback capabilities
* **SWUpdate**: A software update framework designed for embedded systems with support for multiple update strategies
* **OSTree**: An upgrade system for Linux-based operating systems that performs atomic upgrades of complete filesystem trees

#### OTA Support Matrix

The following boards support OTA updates with the indicated technologies and Yocto releases:

| Board | RAUC | SWUpdate | OSTree | Supported Releases |
|-------|:----:|:--------:|:------:|-------------------|
| **RSB3720** | ✅ | ✅ | ✅ | walnascar, styhead, scarthgap |
| **RSB3720-4G** | ✅ | ✅ | ❌ | walnascar |
| **RSB3720-6G** | ✅ | ✅ | ❌ | walnascar |
| **ROM2620-ED91** | ✅ | ✅ | ✅ | walnascar, styhead, scarthgap |
| **ROM2820-ED93** | ✅ | ✅ | ✅ | walnascar, styhead, scarthgap |
| **ROM5720-DB5901** | ✅ | ✅ | ✅ | walnascar, styhead, scarthgap |
| **ROM5721-1G-DB5901** | ✅ | ✅ | ✅ | walnascar |
| **ROM5721-2G-DB5901** | ✅ | ✅ | ✅ | walnascar |
| **ROM5722-DB2510** | ✅ | ✅ | ✅ | walnascar, styhead, scarthgap |

#### Building Images with OTA Support

To build a BSP image with OTA support, use the `just ota-mbsp` command:

```bash
# Build with RAUC OTA support
just ota-mbsp rsb3720 rauc walnascar

# Build with RAUC OTA support for RSB3720 4G variant
just ota-mbsp rsb3720-4g rauc walnascar

# Build with SWUpdate OTA support
just ota-mbsp rsb3720 swupdate scarthgap

# Build with OSTree OTA support
just ota-mbsp rom5722-db2510 ostree styhead
```

Alternatively, you can use the `bsp.py` tool directly:

```bash
# List all available OTA configurations
python bsp.py list | grep ota

# Build a specific OTA configuration
python bsp.py build adv-ota-mbsp-oenxp-rauc-walnascar-rsb3720-6g

# Build RSB3720 4G variant with RAUC OTA support
python bsp.py build adv-ota-mbsp-oenxp-rauc-walnascar-rsb3720-4g
```

---

# BSP Registry Manager

The BSP Registry Manager (`bsp.py`) is a comprehensive Python script that provides a command-line interface for managing and building Yocto-based BSPs using the KAS build system. It features Docker container management, cached builds, and sophisticated configuration management for embedded Linux development.

## Overview

The BSP Registry Manager supports:

- **BSP registry management** via YAML configuration files
- **Docker container building and management** for reproducible builds
- **KAS build system integration** for Yocto-based builds
- **Interactive shell access** to build environments
- **Comprehensive error handling** and configuration validation
- **Advanced cache management** for faster incremental builds
- **Environment variable configuration management** with expansion support
- **KAS configuration export** functionality

## Installation

The BSP Registry Manager requires Python 3.7+ and can be installed using the provided requirements:

```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install bsp manager
pip install -e .
```

## Basic Usage

```bash
# List available BSPs in the registry
python bsp.py list

# Checkout and validate a BSP configuration without building (fast)
python bsp.py build <bsp_name> --checkout

# Build a specific BSP
python bsp.py build <bsp_name>

# Enter interactive shell for a BSP
python bsp.py shell <bsp_name>

# Export BSP configuration
python bsp.py export <bsp_name>

# List available container definitions
python bsp.py containers
```

## Container Management

The BSP Registry Manager supports container definitions that can be shared across multiple BSPs:

```bash
# List all available containers
python bsp.py containers

# Example output:
# Available Containers:
# - ubuntu-20.04:
#     Image: advantech/bsp-registry/ubuntu-20.04/kas:4.7
#     File: Dockerfile.ubuntu
#     Args: DISTRO=ubuntu:20.04, KAS_VERSION=4.7
# - ubuntu-22.04:
#     Image: advantech/bsp-registry/ubuntu-22.04/kas:5.0
#     File: Dockerfile.ubuntu
#     Args: DISTRO=ubuntu:22.04, KAS_VERSION=5.0
```

## Configuration File Structure

The BSP registry uses a YAML configuration file (default: `bsp-registry.yml`) with the following structure:

```yaml
specification:
  version: '1.0'

# Global environment variables (supports $ENV{VAR} expansion)
environment:
  - name: "DL_DIR"
    value: "$ENV{HOME}/yocto-cache/downloads"
  - name: "SSTATE_DIR"
    value: "$ENV{HOME}/yocto-cache/sstate-cache"

# Container definitions (reusable across BSPs)
containers:
  - ubuntu-20.04:
      file: Dockerfile.ubuntu
      image: "advantech/bsp-registry/ubuntu-20.04/kas:4.7"
      args:
        - name: "DISTRO"
          value: "ubuntu:20.04"
        - name: "KAS_VERSION"
          value: "4.7"
  - ubuntu-22.04:
      file: Dockerfile.ubuntu
      image: "advantech/bsp-registry/ubuntu-22.04/kas:5.0"
      args:
        - name: "DISTRO"
          value: "ubuntu:22.04"
        - name: "KAS_VERSION"
          value: "5.0"

# BSP definitions
registry:
  bsp:
    - name: "imx8mpevk"
      description: "i.MX8MP EVK Board"
      os:
        name: "linux"
        build_system: "yocto"
        version: "scarthgap"
      build:
        path: "build/imx8mpevk"
        environment:
          container: "ubuntu-22.04"  # Reference to container definition
        docker: "docker"
        configuration:
          - "conf/imx8mpevk.yml"
          - "conf/scarthgap.yml"
```

## Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `list` | List all available BSPs | `python bsp.py list` |
| `build <bsp_name>` | Build a specific BSP | `python bsp.py build imx8mpevk` |
| `build <bsp_name> --checkout` | Checkout and validate BSP configuration without building (fast) | `python bsp.py build imx8mpevk --checkout` |
| `shell <bsp_name>` | Enter interactive shell | `python bsp.py shell imx8mpevk` |
| `export <bsp_name>` | Export KAS configuration | `python bsp.py export imx8mpevk` |
| `containers` | List available containers | `python bsp.py containers` |

### Checkout and Validation

The `--checkout` flag provides a fast way to checkout and validate BSP configurations without performing time-consuming Docker builds and Yocto compilations. This follows the KAS command naming convention (`kas checkout`). It is particularly useful for:

- **CI/CD pipelines**: Quickly verify configuration validity before committing resources to a full build
- **Development iteration**: Test configuration changes without waiting for complete builds
- **Pre-build checks**: Ensure all required files and repositories are accessible before starting a build

**How it works:**

1. Validates BSP configuration files and dependencies
2. Skips Docker image build (uses native KAS installation)
3. Runs `kas checkout` to verify repository configurations
4. Validates that all required source repositories can be cloned
5. Confirms build configuration is valid without performing actual compilation

**Example:**

```bash
# Checkout and validate configuration for RSB3720 6G board
python bsp.py build adv-mbsp-oenxp-walnascar-rsb3720-6g --checkout

# Checkout and validate configuration for RSB3720 4G board
python bsp.py build adv-mbsp-oenxp-walnascar-rsb3720-4g --checkout

# If validation passes, proceed with full build
python bsp.py build adv-mbsp-oenxp-walnascar-rsb3720-6g
```

---

# HowTo Assemble BSPs

This chapter explains how to assemble modular BSPs using KAS configuration files. It provides step‑by‑step instructions for setting up prerequisites, selecting the right configuration, and running builds to generate reproducible BSP images tailored to specific hardware platforms.

## Host System dependencies

The host system must provide essential tools and libraries required for building BSPs, including compilers, version control systems, and scripting environments. Ensuring these dependencies are installed and up to date guarantees a stable build process and consistent results across different development environments.

**Host system initial setup must include:**

* Python 3.x
  * Including python virtual environment module
* `pip` package manager is available
* Docker
* Git
* Just

The build have been tested on the following host systems: `Ubuntu 22.04`, `Ubuntu 24.04`

### Setup Python virtual environment

It is recommended to install python based tools and packages in a separate python virtual envronment, which could be created
using python virtualenv package.

```bash
python3 -m venv venv
```

To activate virtual environment use following command:

```bash
source venv/bin/activate
```

#### Advanced Tools for Managing Multiple Python Environments  

While venv and virtualenv cover most basic needs, advanced tools provide additional functionality for dependency management, reproducibility, and handling multiple Python versions.

* [pipenv](https://pipenv.pypa.io/en/latest/)
* [pyenv](https://github.com/pyenv/pyenv)
* [conda](https://docs.conda.io/projects/conda/en/stable/user-guide/install/index.html) 

#### Install Python packages dependencies

BSP registry repository contains `requirements.txt` file with the list of python modules required to run configuration and build.

```bash
pip3 install -r requirements.txt
```

### Setting up Docker engine

The BSP images build would run in a docker container, meaning host system should have docker installed.
If your host system is Ubuntu, check official docker installation guide at <https://docs.docker.com/engine/install/ubuntu/>.

To run docker from a non root user (which is required) please follow instructions from the official docker documentation
<https://docs.docker.com/engine/install/linux-postinstall/>. But, in most cases, one command have to be executed

```bash
sudo usermod -aG docker $USER
```

and reboot or re-login the system for the changes to take affect.

#### Docker `buildx`

Docker `buildx` extends the standard Docker build command with advanced capabilities powered by BuildKit. It enables developers to build multi‑platform images, leverage efficient caching, and run builds in parallel, ensuring faster and more consistent results across diverse environments.

To download `buildx` binary for your host system use link below:
<https://github.com/docker/buildx?tab=readme-ov-file#manual-download>

## Building BSP

Building a Board Support Package (BSP) combining Yocto, KAS, and Docker. Yocto provides the framework for creating custom Linux distributions tailored to specific hardware platforms. KAS simplifies the process by managing layered build configurations through YAML files, ensuring reproducibility and modularity. Docker adds portability by encapsulating the build environment, eliminating host system inconsistencies and making it easy to run builds across different machines.

Together, these tools enable developers to assemble BSP images in a consistent, automated, and scalable way. By defining configurations in KAS, leveraging Yocto recipes, and running builds inside Docker containers, teams can ensure reliable results while reducing setup complexity and dependency issues.

### Setup build environment

To prepare build environment for the [KAS](https://kas.readthedocs.io/en/latest/) build tool, [Just](https://just.systems/man/en/functions.html#environment-variables) scripts use `.env` file in the root directory of current repository. `.env` file contains a set of typical environment variables used by `kas` tool. 

**Example `.env` file:**

```
KAS_WORKDIR=<path-to>/modular-bsp-build
KAS_CONTAINER_ENGINE=docker
KAS_CONTAINER_IMAGE=advantech/bsp-registry/ubuntu:20.04
GITCONFIG_FILE=<path-to>/.gitconfig
DL_DIR=<path-to>/data/cache/downloads/
SSTATE_DIR=<path-to>/data/cache/sstate/
```

is populated automatically by `just env` rule. 

Path to the `.gitconfig` file can be adjusted

```
GITCONFIG_FILE=<absolute-path>/.gitconfig
```

and paths to the yocto cache

```
DL_DIR=<absolute-path>/cache/downloads/
SSTATE_DIR=<absolute-path>/cache/sstate/ 
```

in the `Justfile`.

### Overview of shortcuts available in Justfile

```
Available recipes:
    help                                           # Print available commands

    [docker]
    env distro="debian:12"                         # Populate .env file
    docker-debian distro="debian:12"               # Build official KAS Docker image based on Debian Linux
    docker-ubuntu distro="ubuntu:20.04" kas="4.7"  # Build KAS Docker image based on Ubuntu Linux

    [yocto]
    yocto action="build" bsp="mbsp" machine="rsb3720" version="walnascar" docker="ubuntu:22.04" kas="5.0" args="" # Build a Yocto BSP for a specified machine
    walnascar bsp="mbsp" machine="rsb3720"         # Build Yocto Walnascar BSP for a specified machine
    styhead bsp="mbsp" machine="rsb3720"           # Build Yocto Styhead BSP for a specified machine
    scarthgap bsp="mbsp" machine="rsb3720"         # Build Yocto Scathgap BSP for a specified machine
    mickledore bsp="bsp" machine="rsb3730"         # Build Yocto Mickledore BSP for a specified machine
    kirkstone bsp="bsp" machine="rsb3720"          # Build Yocto Kirkstone BSP for a specified machine

    [bsp]
    bsp machine="rsb3720" yocto="scarthgap" docker="ubuntu:22.04" kas="5.0" # Build BSP for a specified machine
    bsp-shell machine="rsb3720" yocto="scarthgap" docker="ubuntu:22.04" kas="5.0" # Enter a BSP build environment shell for a machine

    [mbsp]
    mbsp machine="rsb3720" yocto="walnascar"       # Build Modular BSP for a specified machine
    mbsp-shell machine="rsb3720" yocto="walnascar" # Enter a "Modular BSP" build environment shell for a machine

    [ota]
    ota-mbsp machine="rsb3720" ota="rauc" yocto="walnascar" # Build Modular BSP with OTA support for a specified machine
    ota-shell machine="rsb3720" ota="rauc" yocto="walnascar" # Enter a "Modular BSP" build environment shell with OTA support for a machine

    [ros]
    ros-mbsp machine="rsb3720" ros="humble" yocto="walnascar" # Enter a "Modular BSP" build environment shell for a machine
    ros-shell machine="rsb3720" ros="humble" yocto="walnascar" # Enter a "Modular BSP" build environment shell with ROS support for a machine
```

### Running BSP build

Use command below to build basic BSP image

```bash
# just bsp {{board name}} {{yocto release}}
just bsp rsb3720 scarthgap
```

### Running Modular BSP build

BSP registry repository contains a Justfile with shortcuts to simplify assembling of BSP images. 
To build a BSP image for a specific Yocto release use command below:

```bash
# just mbsp {{board name}} {{yocto release}}
just mbsp rsb3720 scarthgap
```

Use command below to build i.MX images with OTA support

```bash
# just ota-mbsp {{board name}} {{ota}} {{yocto release}}
just ota-mbsp rsb3720 rauc scarthgap
```

Use command below to build i.MX images with ROS2 support

```bash
# just ros-mbsp {{board name}} {{ros}} {{yocto release}}
just ros-mbsp rsb3720 humble scarthgap
```

### Bitbake development shell

To enter a docker container shell initialized with yocto bitbake environment run a `just` shortcut:

```bash
# just mbsp {{board name}} {{yocto release}}
just mbsp-shell rsb3720 scarthgap
```

## HowTo build a BSP using KAS

To assemble BSP images using KAS tool following commands can be used

```bash
# activate python virtual environment
source venv/bin/activate

# add proper KAS configuration variables to your environment
source .env

# run the build
# kas build <path-to-kas-yaml-file>
kas build adv-mbsp-oenxp-walnascar-rsb3720-6g.yaml

# Build RSB3720 4G variant
kas build adv-mbsp-oenxp-walnascar-rsb3720-4g.yaml
```

### Building a BSP image using KAS in a container

Define environment variables `KAS_CONTAINER_ENGINE` and `KAS_CONTAINER_IMAGE`. 

For example:
```bash
export KAS_CONTAINER_ENGINE=docker
export KAS_CONTAINER_IMAGE=advantech/bsp-registry/ubuntu:22.04
```

Container image should have `kas` tool installed inside and use [scripts/kas/container-entrypoint](./scripts/kas/container-entrypoint) script. Check [Dockerfile.ubuntu](./Dockerfile.ubuntu) for reference.

To run build inside a docker container use `kas-container` tool

```bash
kas-container build adv-mbsp-oenxp-walnascar-rsb3720-6g.yaml

# Build RSB3720 4G variant
kas-container build adv-mbsp-oenxp-walnascar-rsb3720-4g.yaml
```

### Bitbake development shell

Using pure `kas` it is possible to enter bitbake shell via command:

```bash
kas shell adv-mbsp-oenxp-walnascar-rsb3720-6g.yaml

# Or for RSB3720 4G variant
kas shell adv-mbsp-oenxp-walnascar-rsb3720-4g.yaml
```

or in a `docker` container using following command:

```bash
kas-container shell adv-mbsp-oenxp-walnascar-rsb3720-6g.yaml

# Or for RSB3720 4G variant
kas-container shell adv-mbsp-oenxp-walnascar-rsb3720-4g.yaml
```

---

# Advanced Topics

This chapter provides overview of advanced topics working with KAS build configurations.

## Export KAS configuration

kas tool can dump final configuration in standart output with `kas dump` command

```bash
kas dump adv-mbsp-oenxp-walnascar-rsb3720-6g.yaml > final.yaml

# Or for RSB3720 4G variant
kas dump adv-mbsp-oenxp-walnascar-rsb3720-4g.yaml > final.yaml
```

For details check https://kas.readthedocs.io/en/latest/userguide/plugins.html#module-kas.plugins.dump

`final.yaml` would contain all the included `yaml` configuration files and can be reused later.

## Lock KAS configuration

Similar to `kas dump` there is a `kas lock` command, it would generate a yaml file with all layer revisions. 
For datailed overview check official kas documentation https://kas.readthedocs.io/en/latest/userguide/plugins.html#module-kas.plugins.lock

## Reusing BSP Registry configurations

It is possible to include BSP registry YAML configurations in your images (provided your project uses kas to assemble OS images). An example KAS configuration 

To extend an existing BSP with a custom Yocto layer create a following kas config:

```yaml
header:
  version: 19
  includes:
    - repo: bsp-registry
      file: adv-mbsp-oenxp-walnascar-rsb3720-6g.yaml

repos:
  this:
    layers:
      meta-custom:

  bsp-registry:
    url: "https://github.com/Advantech-EECC/modular-bsp-build"
    branch: "main"
    layers:
      .: "disabled"
```

where `meta-custom` repository scructure looks like:

```bash
(venv) ➜  meta-custom
.
├── .config.yaml
└── meta-custom
    ├── conf
    │   └── layer.conf
    └── recipes-core
        └── imx-image-%.bbappend
```

where `imx-image-%.bbappend` recipes contains:

```bitbake
CORE_IMAGE_EXTRA_INSTALL += "mpv"
LICENSE_FLAGS_ACCEPTED += "commercial"
```

and layer configuration:

```bitbake
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \
            ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "custom"
BBFILE_PATTERN_custom = "^${LAYERDIR}/"
BBFILE_PRIORITY_custom = "10"
LAYERVERSION_custom = "0.1"
LAYERSERIES_COMPAT_custom = "scarthgap"
LAYERDEPENDS_custom = "eecc-nxp"
```

---

# Links

* [KAS Container](https://kas.readthedocs.io/en/latest/userguide/kas-container.html)
* [KAS](https://kas.readthedocs.io/en/latest/intro.html)
