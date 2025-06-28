#!/bin/bash

curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_START=true sh -
sudo systemctl enable --now k3s