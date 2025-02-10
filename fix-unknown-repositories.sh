#!/bin/bash

set -e

# This only reinstall from the repositories the installed packages
# from unknown source repository.
# If your system was installed using dnf5, you should not have
# installed packages with an unknonwn source repository.

pkgs=($(dnf list --installed | grep unknown | awk '{print $1}'))
if [ ${#pkgs[@]} -gt 0 ]; then
  sudo dnf reinstall "${pkgs[@]}"
fi
sudo rpm -qVa

