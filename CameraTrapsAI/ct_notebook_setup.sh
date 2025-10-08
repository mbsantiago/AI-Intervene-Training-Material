#!/bin/bash

# Need to avoid using the system python
export UV_SYSTEM_PYTHON=false

# Download colab utils
if [ ! -f colab_utils.py ]; then
    echo "Downloading colab_utils.py"
    wget -q https://gist.github.com/mbsantiago/f51815e0255f3b6ae6047d6115a119da/raw/e37d2722ae956bd41e59bf13c888467b0b22f740/colab_utils.py 
fi

# Download ct notebook utils
if [ ! -f ct_notebook_utils.py ]; then
    echo "Downloading ct_notebook_utils.py"
    wget -q https://gist.github.com/mbsantiago/872f49a0656aea0b43377619bdbacb4b/raw/59dbc82ab6bbbe0376badb751d5668886f0b33ef/ct_notebook_utils.py
fi

# Create virtual environment
if [ ! -d .mdvenv/ ]; then
    uv venv .mdvenv/
fi

# Activate virtual environment
source .mdvenv/bin/activate

# Install megadetector
if ! uv pip show megadetector; then
    uv pip install megadetector
fi

# Install speciesnet
if ! uv pip show speciesnet; then
    uv pip install speciesnet
fi

# Unzip data
if [ ! -d data ]; then
    unzip drive/MyDrive/AI-Intervene-Camera-Traps/data.zip -d .
fi
