#!/bin/bash

# Need to avoid using the system python
export UV_SYSTEM_PYTHON=false

# Download colab utils
if [ ! -f colab_utils.py ]; then
    echo "Downloading colab_utils.py"
    wget -q https://github.com/mbsantiago/AI-Intervene-Training-Material/raw/refs/heads/main/CameraTrapsAI/colab_utils.py
fi

# Download ct notebook utils
if [ ! -f ct_notebook_utils.py ]; then
    echo "Downloading ct_notebook_utils.py"
    wget -q https://github.com/mbsantiago/AI-Intervene-Training-Material/raw/refs/heads/main/CameraTrapsAI/ct_notebook_utils.py
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
