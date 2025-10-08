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
    echo "Installing megadetector"
    uv pip install megadetector
fi

# Install speciesnet
if ! uv pip show speciesnet; then
    echo "Installing speciesnet"
    uv pip install speciesnet
fi

# Unzip data
if [ ! -d data ]; then
    echo "Unzipping data"
    unzip drive/MyDrive/AI-Intervene-Camera-Traps/data.zip -d .
fi

# Download models
if [ ! -d models ]; then
    mkdir models
fi

# Download speciesnet model
if [ ! -d models/speciesnet ]; then
    echo "Downloading speciesnet model"
    mkdir models/speciesnet
    wget -q -o model.tar.gz https://www.kaggle.com/api/v1/models/google/speciesnet/pyTorch/v4.0.1a/1/download
    tar -xvf model.tar.gz --directory models/speciesnet
    rm model.tar.gz
fi
