#!/bin/bash

set -e

# donwload_iso "Server" "aarch64" "
function download_iso {
	local FLAVOR_BASE="$1"
	local ARCH="$2"

	local FLAVOR="Fedora-${FLAVOR}"

	# FLAVOR="Fedora-Server"
	FILE_CHECKSUM="${FLAVOR}-41-1.4-${ARCH}-CHECKSUM"
	FILE_IMAGE="${FLAVOR}-41-1.4.${ARCH}.raw.xz"
	FILE_QCOW2="${FLAVOR}-KVM-41-1.4.${ARCH}.qcow2"
	FILE_ISO="${FLAVOR}-dvd-${ARCH}-41-1.4.iso"

	BASE_URL_FEDORA_SERVER="https://ftp-stud.hs-esslingen.de/pub/fedora/linux/releases/41/${FLAVOR_BASE}/${ARCH}/images"
	BASE_URL_FEDORA_SERVER_ISO="https://download.fedoraproject.org/pub/fedora/linux/releases/41/${FLAVOR_BASE}/${ARCH}/iso"

	# Download public key
	[ -e "${HOME}/Downloads/images/fedora.gpg" ] || curl -o "$HOME/Downloads/images/fedora.gpg" "https://fedoraproject.org/fedora.gpg"

	[ -e "${HOME}/Downloads/images/${FILE_CHECKSUM}" ] || curl -o "/tmp/${FILE_CHECKSUM}" "${BASE_URL_FEDORA_SERVER}/${FILE_CHECKSUM}"
	mv "/tmp/${FILE_CHECKSUM}" "${HOME}/Downloads/images/${FILE_CHECKSUM}"
	[ -e "${HOME}/Downloads/images/${FILE_IMAGE}" ] || curl -o "/tmp/${FILE_IMAGE}" "${BASE_URL_FEDORA_SERVER}/${FILE_IMAGE}"
	mv "/tmp/${FILE_IMAGE}" "${HOME}/Downloads/images/${FILE_IMAGE}"
	[ -e "${HOME}/Downloads/images/${FILE_QCOW2}" ] || curl -o "/tmp/${FILE_QCOW2}" "${BASE_URL_FEDORA_SERVER}/${FILE_QCOW2}"
	mv "/tmp/${FILE_QCOW2}" "${HOME}/Downloads/images/${FILE_QCOW2}"
	[ -e "${HOME}/Downloads/images/${FILE_ISO}" ] || curl -L -o "/tmp/${FILE_ISO}"
	mv "/tmp/${FILE_ISO}" "${HOME}/Downloads/images/${FILE_ISO}"

	# Check CHECKSUM
	gpgv --keyring "$HOME/Downloads/images/fedora.gpg" "$HOME/Downloads/images/${FILE_CHECKSUM}"

	# Verify images
	(cd "$HOME/Downloads/images"; sha256sum -c "${FILE_CHECKSUM}" --ignore-missing)
}


ARCH="${ARCH:-aarch64}"
FLAVOR="${FLAVOR:-Fedora-Server}"
FILE_CHECKSUM="${FLAVOR}-41-1.4-${ARCH}-CHECKSUM"
FILE_IMAGE="${FLAVOR}-41-1.4.${ARCH}.raw.xz"
FILE_QCOW2="${FLAVOR}-KVM-41-1.4.${ARCH}.qcow2"
FILE_ISO="${FLAVOR}-dvd-${ARCH}-41-1.4.iso"

BASE_URL_FEDORA_SERVER="https://ftp-stud.hs-esslingen.de/pub/fedora/linux/releases/41/Server/${ARCH}/images"
BASE_URL_FEDORA_SERVER_ISO="https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/${ARCH}/iso"

# Download public key
[ -e "${HOME}/Downloads/images/fedora.gpg" ] || curl -o "$HOME/Downloads/images/fedora.gpg" "https://fedoraproject.org/fedora.gpg"

# FEDORA SERVER
[ -e "${HOME}/Downloads/images/${FILE_CHECKSUM}" ] || curl -o "${HOME}/Downloads/images/${FILE_CHECKSUM}" "${BASE_URL_FEDORA_SERVER}/${FILE_CHECKSUM}"
[ -e "${HOME}/Downloads/images/${FILE_IMAGE}" ] || curl -o "${HOME}/Downloads/images/${FILE_IMAGE}" "${BASE_URL_FEDORA_SERVER}/${FILE_IMAGE}"
[ -e "${HOME}/Downloads/images/${FILE_QCOW2}" ] || curl -o "${HOME}/Downloads/images/${FILE_QCOW2}" "${BASE_URL_FEDORA_SERVER}/${FILE_QCOW2}"
[ -e "${HOME}/Downloads/images/${FILE_ISO}" ] || curl -L -o "${HOME}/Downloads/images/${FILE_ISO}" "${BASE_URL_FEDORA_SERVER_ISO}/${FILE_ISO}"

# Check CHECKSUM
gpgv --keyring "$HOME/Downloads/images/fedora.gpg" "$HOME/Downloads/images/${FILE_CHECKSUM}"

# Verify
(cd "$HOME/Downloads/images"; sha256sum -c "${FILE_CHECKSUM}" --ignore-missing)

# download_iso "Server" "aarch64"

lsblk
echo sudo arm-image-installer --image=/home/avisiedo/Downloads/images/${FILE_IMAGE} --target=rpi4 --showboot --relabel --resizefs --args '"lockdown=integrity ipv6.disable=1 rd.driver.blacklist=cfg80211,btusb,bluetooth driver.blacklist=cfg80211,btusb,bluetooth blacklist=cfg80211,btusb,bluetooth"' --media=/dev/mmcblkX

