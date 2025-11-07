#!/bin/bash

# Install additional dependencies
uv pip install "wavio>=0.0.9"
uv pip install "batdetect2==1.0.8"

# Download data
gdown 1UWPoP6J9bh9l7Q-cRYsd2I6rrQGnjMUJ

# Unzip data
unzip data.zip
