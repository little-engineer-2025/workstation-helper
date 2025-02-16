#!/bin/bash

set -e

FLAVOR="Fedora-Server"
FILE_CHECKSUM="${FLAVOR}-41-1.4-aarch64-CHECKSUM"
FILE_IMAGE="${FLAVOR}-41-1.4.aarch64.raw.xz"
FILE_QCOW2="${FLAVOR}-KVM-41-1.4.aarch64.qcow2"
FILE_ISO="${FLAVOR}-dvd-aarch64-41-1.4.iso"

BASE_URL_FEDORA_SERVER="https://ftp-stud.hs-esslingen.de/pub/fedora/linux/releases/41/Server/aarch64/images"

# Download public key
[ -e "${HOME}/Downloads/images/fedora.gpg" ] || curl -o "$HOME/Downloads/images/fedora.gpg" "https://fedoraproject.org/fedora.gpg"

# FEDORA SERVER
[ -e "${HOME}/Downloads/images/${FILE_CHECKSUM}" ] || curl -o "${HOME}/Downloads/images/${FILE_CHECKSUM}" "${BASE_URL_FEDORA_SERVER}/${FILE_CHECKSUM}"
[ -e "${HOME}/Downloads/images/${FILE_IMAGE}" ] || curl -o "${HOME}/Downloads/images/${FILE_IMAGE}" "${BASE_URL_FEDORA_SERVER}/${FILE_IMAGE}"
[ -e "${HOME}/Downloads/images/${FILE_QCOW2}" ] || curl -o "${HOME}/Downloads/images/${FILE_QCOW2}" "${BASE_URL_FEDORA_SERVER}/${FILE_QCOW2}"
[ -e "${HOME}/Downloads/images/${FILE_ISO}" ] || curl -o "${HOME}/Downloads/images/${FILE_ISO}" "${BASE_URL_FEDORA_SERVER}/${FILE_ISO}"

# Check CHECKSUM
gpgv --keyring "$HOME/Downloads/images/fedora.gpg" "$HOME/Downloads/images/${FILE_CHECKSUM}"

# Verify
(cd "$HOME/Downloads/images"; sha256sum -c "${FILE_CHECKSUM}" --ignore-missing)

lsblk
echo sudo arm-image-installer --image=/home/avisiedo/Downloads/images/${FILE_IMAGE} --target=rpi4 --showboot --relabel --resizefs --args '"lockdown=integrity ipv4.disable=1 rd.driver.blacklist=cfg80211,btusb,bluetooth driver.blacklist=cfg80211,btusb,bluetooth"' --media=/dev/mmcblkX

