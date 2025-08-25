set dotenv-load

docker:
    docker build . -t kas:latest

image machine yocto: docker
    kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

shell machine yocto: docker
    kas-container shell adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml
