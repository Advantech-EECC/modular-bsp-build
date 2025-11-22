# Modular BSP build configurations

KAS tool build configurations for Modular BSP.

# Hardware support

## NXP

Table describes in which combinations yocto releases could be used together.

| Yocto \ Board | RSB3720 |   RSB3730   | ROM2620 | ROM5720 | ROM5721 | ROM5722 | ROM2820 | AOM5521 A1 | AOM5521 A2 |
| :------------ | :-----: | :---------: | :-----: | :-----: | :-----: | :-----: | :-----: | :--------: | :--------: |
| walnascar     |    x    |             |    x    |    x    |    x    |    x    |    x    |            |     x      |
| styhead       |    x    |             |    x    |    x    |    x    |    x    |    x    |            |            |
| scarthgap     |    x    |             |    x    |    x    |    x    |    x    |    x    |     x      |            |
| mickledore    |         |      x      |         |         |         |         |         |            |            |
| langdale      |         |             |         |         |         |         |         |            |            |
| kirkstone     |         |             |         |         |         |         |         |            |            |
| honister      |         |             |         |         |         |         |         |            |            |
| hardknott     |         |             |         |         |         |         |         |            |            |
| gatesgarth    |         |             |         |         |         |         |         |            |            |
| dunfell       |         |             |         |         |         |         |         |            |            |
|               | stable  | development | stable  | stable  | stable  | stable  | stable  |   stable   |   stable   |

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
