set dotenv-load

docker:
    docker build . -t mbsp:latest

image machine yocto: docker
    kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

rauc-image machine yocto: docker
    kas-container build adv-mbsp-oenxp-rauc-{{yocto}}-{{machine}}.yaml
