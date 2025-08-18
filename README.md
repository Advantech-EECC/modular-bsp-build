# Modular BSP KAS Configurations

KAS tool configurations for Modular BSP.

# Assemble

To build modular bsp using KAS configuration follow steps below.

## Setup Python virtual environment

```bash
python3 =m venv venv
source venv/bin/activate
```

## Install tools

```bash
pip3 install -r requirements.txt
```

## Build Modular BSP

```bash
# just build {{board name}} {{yocto release}}
just build rsb3720 scarthgap
```

# Links

* [KAS Container](https://kas.readthedocs.io/en/latest/userguide/kas-container.html)
* [KAS](https://kas.readthedocs.io/en/latest/intro.html)
