# Installation and Setup

RISK is available on PyPI and supports Python 3.8 or later on major operating systems (Windows, macOS, Linux). Install the latest release with:

```bash
pip install risk-network --upgrade
```

To install from source:

```bash
git clone https://github.com/riskportal/risk.git
cd risk
pip install .
pip install -e .  # for editable/development install
```

## Importing RISK

Verify the installation and import the package:

```python
import risk as r
print(f"RISK version: {r.__version__}")
```

The core functionality is accessed through the `RISK` class:

```python
from risk import RISK
```

For Jupyter notebooks, enable inline plotting:

```python
%matplotlib inline
```

## Initializing RISK

`RISK` provides modular access to clustering, statistics, and visualization components. Initialize it to start analysis:

**Parameters:**

- `verbose` (bool): Controls whether log messages are printed. If `True`, log messages are printed to the console. Defaults to True.

```python
risk = RISK(verbose=True)
```

## Next Step

[Loading Networks into RISK](2_network_input.md)
