#!/bin/bash

pkgs=($(dnf list --installed | grep unknown | awk '{print $1}'))
[ ${#pkgs[@]} -gt 0 ] || {
  echo "No packages to fix" >&2
  exit 0
}

OUTPUT="$PWD/fix-unknown-rpms.md"
exec 1>>"${OUTPUT}"

printf "\n\n%s\n" "$(date)"
dnf list --installed | grep unknown

echo "Reinstall the packages require higher privileges" >&2
sudo dnf reinstall "${pkgs[@]}"
