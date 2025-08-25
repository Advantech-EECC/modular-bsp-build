FROM ghcr.io/siemens/kas/kas:4.8.2

# original image doesn't have gfortran installed for some reason
RUN sudo apt update && sudo apt install -y gfortran efitools python3-full python3-dev
