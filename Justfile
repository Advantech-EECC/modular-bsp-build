# loads .env file from the current working dir
#
# minimal .env contents could be 
#
# KAS_WORKDIR=$PWD
# KAS_CONTAINER_ENGINE=docker
# KAS_CONTAINER_IMAGE=<docker-image-tag>
# GITCONFIG_FILE=<user-home-dir>/.gitconfig
# DL_DIR=<user-home-dir>/cache/downloads/
# SSTATE_DIR=<user-home-dir>/cache/sstate/ 
#
set dotenv-load

repo_root := absolute_path(justfile_directory())
repo_name := file_name(repo_root)

dotenv := repo_root / ".env"

# Print available commands
help:
    just --list

# Populate .env file 
env distro="debian:12":
    echo " \
    # generated automatically, to adjust change env rule in the Justfile \n \
    KAS_WORKDIR=$PWD\n \
    KAS_CONTAINER_ENGINE=docker\n \
    KAS_CONTAINER_IMAGE=advantech/bsp-registry/{{distro}}\n \
    GITCONFIG_FILE=${HOME}/.gitconfig\n \
    DL_DIR=${HOME}/data/cache/downloads/\n \
    SSTATE_DIR=${HOME}/data/cache/sstate/\n \
    " > .env

# Build official KAS Docker image based on Debian Linux
docker distro="debian:12": (env distro)
    docker build -f Dockerfile -t advantech/bsp-registry/{{distro}} .

# Build KAS Docker image based on Ubuntu Linux
docker-ubuntu distro="ubuntu:20.04" kas="4.7": (env distro)
    docker build -f Dockerfile.ubuntu -t advantech/bsp-registry/{{distro}} --build-arg DISTRO="{{distro}}" --build-arg KAS_VERSION="{{kas}}" .

# Build BSP for a specified machine
bsp machine yocto: docker-ubuntu
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-bsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-bsp-oenxp-{{yocto}}-{{machine}}.yaml

# Enter a BSP build environment shell for a machine 
bsp-shell machine yocto: docker-ubuntu
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-bsp-{{yocto}}-{{machine}}" kas-container shell adv-bsp-oenxp-{{yocto}}-{{machine}}.yaml

# Build Modular BSP for a specified machine
mbsp machine="rsb3720" yocto="walnascar": docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-mbsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

# Enter a "Modular BSP" build environment shell for a machine 
mbsp-shell machine yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

# Build Modular BSP with OTA support for a specified machine
ota-mbsp machine ota yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ota-{{ota}}-mbsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

# Enter a "Modular BSP" build environment shell with OTA support for a machine 
ota-shell machine ota yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ota-{{ota}}-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

# Enter a "Modular BSP" build environment shell for a machine 
ros-mbsp machine ros yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ros-{{ros}}-mbsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml

# Enter a "Modular BSP" build environment shell with ROS support for a machine 
ros-shell machine ros yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ros-{{ros}}-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml
