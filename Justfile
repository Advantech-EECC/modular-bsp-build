set dotenv-load

docker:
    docker build . -t mbsp:latest

mbsp machine yocto:
    kas-container build adv-mbsp-oenxp-{{yocto}}-{{machine}}.yaml

