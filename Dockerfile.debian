FROM ghcr.io/siemens/kas/kas:5.0-debian-bookworm

RUN sudo apt update 

# original kas image doesn't have gfortran installed for some reason
RUN sudo apt install -y gfortran efitools python3-full python3-dev

# meta-updater dependencies
RUN sudo apt install -y cpu-checker default-jre

# add parted for wic
RUN sudo apt install -y parted mtools
