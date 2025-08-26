# Modular BSP build configurations

KAS tool configurations for Modular BSP.

# Hardware support 

## NXP

Table describes in which combinations yocto releases could be used together with hardware.

| Yocto \ Board | RSB3720 | ROM2620-ED91 | ROM5720-DB5901 | ROM5721-DB5901 | ROM5722-DB2510 | ROM2820-ED93 |
| :------------ | :-----: | :----------: | :------------: | :------------: | :------------: | :----------: |
| walnascar     |    x    |      x       |       x        |       x        |       x        |      x       |
| styhead       |    x    |      x       |       x        |       x        |       x        |      x       |
| scarthgap     |    x    |      x       |       x        |       x        |       x        |      x       |
| nanbield      |    x    |      x       |       x        |       x        |       x        |      x       |
| mickledore    |         |              |                |                |                |              |
| langdale      |         |              |                |                |                |              |
| kirkstone     |         |              |                |                |                |              |
| honister      |         |              |                |                |                |              |
| hardknott     |         |              |                |                |                |              |
| gatesgarth    |         |              |                |                |                |              |
| dunfell       |         |              |                |                |                |              |
|               |         |              |                |                |                |              |
|               | stable  |    stable    |     stable     |     stable     |     stable     |    stable    |

# Assemble

To build modular bsp using KAS configuration follow steps below.

## Setup Python virtual environment

It is recommended to install python based tools and packages in a separate python virtual envronment, which could be created 
using python virtualenv package. 

```bash
python3 =m venv venv
source venv/bin/activate
```

## Install tools

Repository contains `requirements.txt` file with the list of python modules required to run configuration and build.

```bash
pip3 install -r requirements.txt
```

## Build Modular BSP

### Setup environment

Add `.env` file with contents to the root of the repo

```
KAS_WORKDIR=build
KAS_CONTAINER_ENGINE=docker
KAS_CONTAINER_IMAGE=kas:latest
GITCONFIG_FILE=<absolute-path>/.gitconfig
```

to preserve cache and downloads between the builds you can add 

```
DL_DIR=<absolute-path>/cache/downloads/
SSTATE_DIR=<absolute-path>/cache/sstate/ 
```

### Running the build

Run the build using command below

```bash
# just image {{board name}} {{yocto release}}
just image rsb3720 scarthgap
```

example command to build imx core image with OTA

```bash
just ota-image rsb3720 rauc scarthgap
```

example command to build ROS image

```bash
just ros-image rsb3720 humble scarthgap
```


# Links

* [KAS Container](https://kas.readthedocs.io/en/latest/userguide/kas-container.html)
* [KAS](https://kas.readthedocs.io/en/latest/intro.html)
