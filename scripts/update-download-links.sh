#!/bin/bash

# Script to update the download/install related version references when a new
# Dash Core version is released
find . -iname "*.rst" -exec sed -i 's~/v19.1.0/dashcore-19.1.0-~/v19.2.0/dashcore-19.2.0-~g' {} +
find . -iname "*.rst" -exec sed -i 's~dashcore-19.1.0-~dashcore-19.2.0-~g' {} +
find . -iname "*.rst" -exec sed -i 's~dashcore-19.1.0~dashcore-19.2.0~g' {} +