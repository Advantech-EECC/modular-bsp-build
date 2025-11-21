# loads .env file from the current working dir
#
# minimal .env contents could be 
#
# KAS_WORKDIR=$PWD
# KAS_CONTAINER_ENGINE=docker
# KAS_CONTAINER_IMAGE=kas:latest
# GITCONFIG_FILE=<user-home-dir>/.gitconfig
# DL_DIR=<user-home-dir>/cache/downloads/
# SSTATE_DIR=<user-home-dir>/cache/sstate/ 
#
set dotenv-load

repo_root := absolute_path(justfile_directory())
repo_name := file_name(repo_root)

dotenv := repo_root / ".env"

help:
    just --list

env distro="debian:12":
    echo " \
    KAS_WORKDIR=$PWD\n \
    KAS_CONTAINER_ENGINE=docker\n \
    KAS_CONTAINER_IMAGE=advantech/bsp-registry/{{distro}}\n \
    GITCONFIG_FILE=${HOME}/.gitconfig\n \
    DL_DIR=${HOME}/data/cache/downloads/\n \
    SSTATE_DIR=${HOME}/data/cache/sstate/\n \
    " > .env

docker distro="debian:12": (env distro)
    docker build -f Dockerfile -t advantech/bsp-registry/{{distro}} .

docker-ubuntu distro="ubuntu:20.04" kas="4.7": (env distro)
    docker build -f Dockerfile.ubuntu -t advantech/bsp-registry/{{distro}} --build-arg DISTRO="{{distro}}" --build-arg KAS_VERSION="{{kas}}" .

bsp machine yocto: docker-ubuntu
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-bsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-bsp-oenxp-{{yocto}}-{{machine}}.yaml

bsp-shell machine yocto: docker-ubuntu
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-bsp-{{yocto}}-{{machine}}" kas-container shell adv-bsp-oenxp-{{yocto}}-{{machine}}.yaml

mbsp machine="rsb3720" yocto="walnascar": docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-mbsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

mbsp-shell machine yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

ota-mbsp machine ota yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ota-{{ota}}-mbsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

ota-shell machine ota yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ota-{{ota}}-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

ros-mbsp machine ros yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ros-{{ros}}-mbsp-{{yocto}}-{{machine}}" kas-container build --provenance=mode=max adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml

ros-shell machine ros yocto: docker
    @. "{{ dotenv }}" && \
    KAS_BUILD_DIR="$PWD/build-ros-{{ros}}-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml
