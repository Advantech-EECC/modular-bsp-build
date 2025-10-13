# loads .env file from the current working dir
#
# minimal .env contents could be 
#
# KAS_WORKDIR=build
# KAS_CONTAINER_ENGINE=docker
# KAS_CONTAINER_IMAGE=kas:latest
# GITCONFIG_FILE=<user-home-dir>/.gitconfig
# DL_DIR=<user-home-dir>/cache/downloads/
# SSTATE_DIR=<user-home-dir>/cache/sstate/ 
#
set dotenv-load

env:
    echo " \
    KAS_CONTAINER_ENGINE=docker\n \
    KAS_CONTAINER_IMAGE=kas:latest\n \
    GITCONFIG_FILE=${HOME}/.gitconfig\n \
    DL_DIR=${HOME}/cache/downloads/\n \
    SSTATE_DIR=${HOME}/cache/sstate/\n \
    " > .env

docker:
    docker build . -t kas:latest

bsp machine yocto: docker
    @KAS_BUILD_DIR="$PWD/build-bsp-{{yocto}}-{{machine}}" kas-container build adv-bsp-oenxp-{{yocto}}-{{machine}}.yaml

bsp-shell machine yocto: docker
    @KAS_BUILD_DIR="$PWD/build-bsp-{{yocto}}-{{machine}}" kas-container shell adv-bsp-oenxp-{{yocto}}-{{machine}}.yaml

mbsp machine yocto: docker
    @KAS_BUILD_DIR="$PWD/build-mbsp-{{yocto}}-{{machine}}" kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

mbsp-shell machine yocto: docker
    @KAS_BUILD_DIR="$PWD/build-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

ota-mbsp machine ota yocto: docker
    @KAS_BUILD_DIR="$PWD/build-ota-{{ota}}-mbsp-{{yocto}}-{{machine}}" kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

ota-shell machine ota yocto: docker
    @KAS_BUILD_DIR="$PWD/build-ota-{{ota}}-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

ros-mbsp machine ros yocto: docker
    @KAS_BUILD_DIR="$PWD/build-ros-{{ros}}-mbsp-{{yocto}}-{{machine}}" kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml

ros-shell machine ros yocto: docker
    @KAS_BUILD_DIR="$PWD/build-ros-{{ros}}-mbsp-{{yocto}}-{{machine}}" kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml
