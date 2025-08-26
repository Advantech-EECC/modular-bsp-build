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

docker:
    docker build . -t kas:latest

image machine yocto: docker
    kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

shell machine yocto: docker
    kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

ota-image machine ota yocto: docker
    kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

ota-shell machine ota yocto: docker
    kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ota/{{ota}}/adv-ota-{{yocto}}.yml

ros-image machine ros yocto: docker
    kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml

ros-shell machine ros yocto: docker
    kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml:features/ros2/{{ros}}.yml


