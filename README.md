# Modular BSP build configurations

KAS tool build configurations for Modular BSP.

## Build System Architecture

### Component Overview

The build system follows a layered architecture that ensures reproducibility, isolation, and maintainability:

```
┌─────────────────────────────────────────┐
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
| **Justfile Recipes** | User-friendly command interface | `just bsp`, `just mbsp`, `just ota-mbsp` commands |
| **KAS Configuration Files** | Build definitions and dependencies | YAML configs for boards, distros, and features |
| **Docker Container Engine** | Isolated build environment | Consistent toolchains, isolated dependencies |
| **Yocto Project Build** | Core build system | BitBake, OpenEmbedded, meta-layers |
| **Source Layers & Recipes** | BSP components | Machine configs, recipes, kernel, applications |

# Hardware support

## NXP Boards Compatibility Matrix

Table describes in which combinations yocto releases could be used together with boards.

| Board \ Yocto  | walnascar | styhead | scarthgap | mickledore | langdale | kirkstone | honister | hardknott | gatesgarth | dunfell | Status        |
| -------------- | :-------: | :-----: | :-------: | :--------: | :------: | :-------: | :------: | :-------: | :--------: | :-----: | ------------- |
| **RSB3720**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **RSB3730**    |     ❌     |    ❌    |     ❌     |     ✅      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟡 Development |
| **ROM2620**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **ROM5720**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **ROM5721**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **ROM5722**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **ROM2820**    |     ✅     |    ✅    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **AOM5521 A1** |     🟡     |    ❌    |     ✅     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |
| **AOM5521 A2** |     ✅     |    ❌    |     ❌     |     ❌      |    ❌     |     ❌     |    ❌     |     ❌     |     ❌      |    ❌    | 🟢 Stable      |

**Status Legend:**
- 🟢 **Stable**: Production-ready, fully tested and supported
- 🟡 **Development**: Under active development, may have limitations
- 🔴 **EOL**: End of Life, not recommended for new projects

### Alternative Compact View

| Board | Supported Yocto Releases | Status |
|-------|--------------------------|--------|
| **RSB3720** | walnascar, styhead, scarthgap | 🟢 Stable |
| **RSB3730** | mickledore | 🟡 Development |
| **ROM2620** | walnascar, styhead, scarthgap | 🟢 Stable |
| **ROM5720** | walnascar, styhead, scarthgap | 🟢 Stable |
| **ROM5721** | walnascar, styhead, scarthgap | 🟢 Stable |
| **ROM5722** | walnascar, styhead, scarthgap | 🟢 Stable |
| **ROM2820** | walnascar, styhead, scarthgap | 🟢 Stable |
| **AOM5521 A1** | scarthgap | 🟢 Stable |
| **AOM5521 A1** | walnascar | 🟡 Development |
| **AOM5521 A2** | walnascar | 🟢 Stable |

# Assemble

To build modular bsp using KAS configuration follow steps below.

### Setup Python virtual environment

It is recommended to install python based tools and packages in a separate python virtual envronment, which could be created
using python virtualenv package.

```bash
python3 -m venv venv
source venv/bin/activate
```

#### Install Python packages

Repository contains `requirements.txt` file with the list of python modules required to run configuration and build.

```bash
pip3 install -r requirements.txt
```

## Build Modular BSP

### Docker

The BSP images build would run in a docker container, meaning host system should have docker installed.
Check <https://docs.docker.com/engine/install/ubuntu/>.

To run docker from a non root user (which is required) please follow instructions from the official docker documentation
<https://docs.docker.com/engine/install/linux-postinstall/>. But, in most cases, one command have to be executed

```bash
sudo usermod -aG docker $USER
```

and reboot or re-login the system for the changes to take affect.

#### BuildX

<https://github.com/docker/buildx?tab=readme-ov-file#manual-download>

### Setup environment

The `.env` file in the root of repository with contents

```
KAS_WORKDIR=<path-to>/modular-bsp-build
KAS_CONTAINER_ENGINE=docker
KAS_CONTAINER_IMAGE=advantech/bsp-registry/ubuntu:20.04
GITCONFIG_FILE=<path-to>/.gitconfig
DL_DIR=<path-to>/data/cache/downloads/
SSTATE_DIR=<path-to>/data/cache/sstate/
```

is used to pre-configure the build environment. It is populated automatically by `just env` rule. 

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
# just image {{board name}} {{yocto release}}
just bsp rsb3720 scarthgap
```

### Running Modular BSP build

Use command below to build basic "Modular BSP" image

```bash
# just image {{board name}} {{yocto release}}
just mbsp rsb3720 scarthgap
```

Use command below to build i.MX images with OTA

```bash
just ota-mbsp rsb3720 rauc scarthgap
```

Use command below to build i.MX images with ROS2 support

```bash
just ros-mbsp rsb3720 humble scarthgap
```

# Links

* [KAS Container](https://kas.readthedocs.io/en/latest/userguide/kas-container.html)
* [KAS](https://kas.readthedocs.io/en/latest/intro.html)
