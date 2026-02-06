# Building Modular BSP using Repo Tool

This guide describes how to build Advantech modular BSP using the `repo` tool and the [imx-manifest](https://github.com/Advantech-EECC/imx-manifest) repository. This method provides an alternative to the KAS-based workflow for assembling Yocto-based Board Support Packages.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
  - [Install Repo Tool](#install-repo-tool)
  - [Install Essential Host Packages](#install-essential-host-packages)
- [Download Yocto Project BSP](#download-yocto-project-bsp)
  - [Available Releases](#available-releases)
  - [Supported Branches](#supported-branches)
- [Setup Build Environment](#setup-build-environment)
  - [Enabling Advantech BSP Layer](#enabling-advantech-bsp-layer)
- [Build Images](#build-images)
  - [Available Image Recipes](#available-image-recipes)
- [Supported Boards](#supported-boards)
- [Comparison with KAS-based Workflow](#comparison-with-kas-based-workflow)
- [Additional Resources](#additional-resources)

---

## Overview

The `repo` tool is a repository management tool built on top of Git by Google. It allows you to manage multiple Git repositories as a single workspace. The Advantech modular BSP uses repo manifests to define and synchronize all the required Yocto layers and metadata for building embedded Linux images.

**Key Benefits:**
- Standard Yocto workflow using `bitbake` directly
- Compatible with NXP i.MX BSP releases
- Flexible layer management
- Easy synchronization of multiple repositories

---

## Prerequisites

### Install Repo Tool

The `repo` utility must be installed first before you can download the BSP sources.

```bash
# Create a directory for repo tool
mkdir -p ~/bin

# Download the repo tool
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo

# Make it executable
chmod a+x ~/bin/repo

# Add to your PATH
export PATH=${PATH}:~/bin

# Optionally, add to your shell profile for persistence
echo 'export PATH=${PATH}:~/bin' >> ~/.bashrc
```

**Verify Installation:**
```bash
repo version
```

### Install Essential Host Packages

Your build host must have required packages for Yocto builds. The specific packages depend on your Linux distribution.

**For Ubuntu 22.04 / Ubuntu 24.04:**

```bash
sudo apt-get update
sudo apt-get install -y \
    gawk wget git diffstat unzip texinfo gcc build-essential \
    chrpath socat cpio python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping python3-git python3-jinja2 \
    libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev \
    zstd liblz4-tool file locales libacl1
```

**Reference:**
For detailed host package requirements, refer to the [Yocto Project Quick Build Guide](https://docs.yoctoproject.org/5.2.4/brief-yoctoprojectqs/index.html#build-host-packages).

---

## Download Yocto Project BSP

### Available Releases

The Advantech i.MX manifest repository provides several BSP releases based on different kernel versions:

| Release | Kernel Version | Yocto Release | Branch |
|---------|----------------|---------------|--------|
| 6.12.49-2.2.0 | Linux 6.12.49 | Walnascar | imx-linux-walnascar-adv |
| 6.12.34-2.1.0 | Linux 6.12.34 | Walnascar | imx-linux-walnascar-adv |
| 6.12.20-2.0.0 | Linux 6.12.20 | Walnascar | imx-linux-walnascar-adv |

### Download Process

Create a workspace directory and initialize the repo:

```bash
# Create a workspace directory
mkdir -p ~/imx-yocto-bsp
cd ~/imx-yocto-bsp

# Initialize repo with a specific release manifest
repo init -u https://github.com/Advantech-EECC/imx-manifest -b imx-linux-walnascar-adv -m imx-6.12.49-2.2.0-adv.xml

# Download all the source repositories
repo sync
```

**Examples for Different Releases:**

```bash
# For 6.12.20-2.0.0 release
repo init -u https://github.com/Advantech-EECC/imx-manifest -b imx-linux-walnascar-adv -m imx-6.12.20-2.0.0-adv.xml
repo sync

# For 6.12.34-2.1.0 release
repo init -u https://github.com/Advantech-EECC/imx-manifest -b imx-linux-walnascar-adv -m imx-6.12.34-2.1.0-adv.xml
repo sync

# For 6.12.49-2.2.0 release (latest)
repo init -u https://github.com/Advantech-EECC/imx-manifest -b imx-linux-walnascar-adv -m imx-6.12.49-2.2.0-adv.xml
repo sync
```

### Supported Branches

The imx-manifest repository contains different branches for different Yocto releases:

- `imx-linux-walnascar-adv` - Yocto Walnascar (Latest)
- Additional branches may be available for other Yocto releases

---

## Setup Build Environment

After downloading the sources, you need to set up the build environment. The `imx-setup-release.sh` script initializes the build configuration.

**Basic Syntax:**
```bash
MACHINE=<machine> DISTRO=fsl-imx-<backend> source ./imx-setup-release.sh -b bld-<backend>
```

**Parameters:**
- `<machine>` - Target board/machine name (defaults to `imx6qsabresd`)
- `<backend>` - Graphics backend type:
  - `xwayland` - Wayland with X11 support (default, recommended)
  - `wayland` - Pure Wayland
  - `fb` - Framebuffer (not supported for i.MX8)

**Examples for Advantech Boards:**

```bash
# For RSB3720 board with XWayland
MACHINE=rsb3720 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b bld-xwayland

# For ROM2620-ED91 board with XWayland
MACHINE=rom2620-ed91 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b bld-xwayland

# For ROM5722-DB2510 board with XWayland
MACHINE=rom5722-db2510 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b bld-xwayland

# For ROM2820-ED93 board with XWayland
MACHINE=rom2820-ed93 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b bld-xwayland

# For ROM5720-DB5901 board with XWayland
MACHINE=rom5720-db5901 DISTRO=fsl-imx-xwayland source ./imx-setup-release.sh -b bld-xwayland
```

This script will:
1. Create a build directory (`bld-xwayland`, `bld-wayland`, etc.)
2. Set up `conf/local.conf` and `conf/bblayers.conf`
3. Initialize the BitBake environment

### Enabling Advantech BSP Layer

**IMPORTANT:** To access Advantech-specific machine configurations, you must enable the Advantech BSP layer.

After running the setup script, add the following line to the **end** of `conf/bblayers.conf`:

```bash
# Edit the bblayers.conf file
cd bld-xwayland  # or your build directory name
vi conf/bblayers.conf
```

Add this line at the end:
```
BBLAYERS += "${BSPDIR}/sources/meta-eecc-nxp"
```

**Alternative (automatic method):**
```bash
# From your build directory
echo 'BBLAYERS += "${BSPDIR}/sources/meta-eecc-nxp"' >> conf/bblayers.conf
```

**Verify the layer is enabled:**
```bash
bitbake-layers show-layers | grep meta-eecc-nxp
```

---

## Build Images

Once the environment is set up, you can build images using BitBake.

```bash
# Make sure you're in the build directory
cd bld-xwayland  # or your build directory

# Build an image
bitbake <image-recipe>
```

### Available Image Recipes

| Image Recipe | Description |
|--------------|-------------|
| `imx-image-core` | Core image with basic graphics and no multimedia |
| `imx-image-multimedia` | Image with multimedia and graphics support |
| `imx-image-full` | Full-featured image with multimedia, machine learning, and Qt |

**Examples:**

```bash
# Build core image for RSB3720
bitbake imx-image-core

# Build multimedia image
bitbake imx-image-multimedia

# Build full-featured image with Qt and ML
bitbake imx-image-full
```

**Build Output Location:**

After a successful build, images will be located at:
```
tmp/deploy/images/<machine>/
```

For example, for RSB3720:
```
tmp/deploy/images/rsb3720/
```

---

## Supported Boards

The following Advantech boards are supported in the modular BSP:

### i.MX8M Plus Boards
- **RSB3720** - Industrial Single Board Computer (4G and 6G variants)

### i.MX93 Boards
- **ROM2620-ED91** - Embedded Development Board
- **ROM2820-ED93** - Embedded Development Board

### i.MX95 Boards
- **ROM5720-DB5901** - Development Board
- **ROM5721-DB5901** - Development Board (1G and 2G variants)
- **ROM5722-DB2510** - Development Board

For a complete list of supported boards and their compatibility with different Yocto releases, refer to the [main README.md](README.md#nxp-boards-compatibility-matrix).

---

## Comparison with KAS-based Workflow

This repository supports two build workflows:

### Repo Tool Workflow (This Guide)
- **Pros:**
  - Standard Yocto workflow using BitBake directly
  - Compatible with NXP reference documentation
  - Familiar to Yocto developers
  - Fine-grained control over layers and configurations
  
- **Cons:**
  - Manual layer management
  - More setup steps required
  - Less container integration

### KAS-based Workflow (See [README.md](README.md))
- **Pros:**
  - Simplified configuration using YAML files
  - Integrated Docker container support
  - Automated layer management
  - Reproducible builds with locked configurations
  - Pre-configured board and feature combinations
  
- **Cons:**
  - Requires KAS tool installation
  - Different workflow from standard Yocto

**Recommendation:**
- Use **Repo Tool** if you're familiar with standard Yocto workflows or need to follow NXP reference documentation
- Use **KAS** if you want automated, reproducible builds with minimal configuration

---

## Additional Resources

### Official Documentation
- [Yocto Project Documentation](https://docs.yoctoproject.org/)
- [Yocto Project Quick Build Guide](https://docs.yoctoproject.org/5.2.4/brief-yoctoprojectqs/index.html)
- [BitBake User Manual](https://docs.yoctoproject.org/bitbake/)

### Advantech Resources
- [Main BSP Registry README](README.md)
- [imx-manifest Repository](https://github.com/Advantech-EECC/imx-manifest)
- [meta-eecc-nxp Layer](https://github.com/Advantech-EECC/meta-eecc-nxp)

### Google Repo Tool
- [Repo Command Reference](https://source.android.com/docs/setup/reference/repo)
- [Repo Tool Overview](https://gerrit.googlesource.com/git-repo/)

### NXP i.MX Resources
- [NXP i.MX Software](https://www.nxp.com/design/software/embedded-software/i-mx-software:IMX-SW)
- [NXP Community](https://community.nxp.com/)

---

## Troubleshooting

### Common Issues

**1. Repo sync fails with permission errors:**
```bash
# Ensure you have SSH keys set up for GitHub
ssh -T git@github.com

# Or use HTTPS instead
repo init -u https://github.com/Advantech-EECC/imx-manifest ...
```

**2. BitBake cannot find Advantech machines:**
```bash
# Verify meta-eecc-nxp is in bblayers.conf
grep meta-eecc-nxp conf/bblayers.conf

# Add if missing
echo 'BBLAYERS += "${BSPDIR}/sources/meta-eecc-nxp"' >> conf/bblayers.conf
```

**3. Build fails with "No space left on device":**
```bash
# Clean up old build artifacts
bitbake -c cleansstate <image-recipe>

# Check available disk space (builds require 50GB+ free space)
df -h
```

**4. Python version issues:**
```bash
# Ensure Python 3 is the default
python3 --version

# Update alternatives if needed
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
```

### Getting Help

If you encounter issues:
1. Check the [Yocto Project FAQ](https://www.yoctoproject.org/faq/)
2. Review [Advantech BSP Registry Issues](https://github.com/Advantech-EECC/bsp-registry/issues)
3. Consult the [Yocto Project Mailing Lists](https://lists.yoctoproject.org/g/yocto)

---

## Contributing

If you find issues with this documentation or the build process, please:
1. Check existing [Issues](https://github.com/Advantech-EECC/bsp-registry/issues)
2. Open a new issue with detailed information
3. Submit a pull request with improvements

---

**Last Updated:** 2026-02-06  
**BSP Version:** 6.12.49-2.2.0  
**Yocto Release:** Walnascar
