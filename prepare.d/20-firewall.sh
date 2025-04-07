#!/bin/bash
set -e

check_mac_address() {
  local mac="$1"

  [ ${#mac} -eq 17 ] || return 1

  # Check separators
  for idx in 2 5 8 11 14; do
    echo $idx
    [ "${mac:$idx:1}" == ":" ] || return 1
  done

  # Check characters
  local valid_chars="0123456789abcdefABCDEF"
  for idx in 0 1  3 4  6 7  9 10  12 13  15 16; do
    case "${mac:$idx:1}" in
      [${valid_chars}] )
        continue ;;
      *)
        return 1 ;;
    esac
  done

  # It represent a mac address
  return 0
}

read_mac_address() {
  while true; do
    echo -n "Write a MAC address: "
    read MAC_ADDRESS
    ! check_mac_address "${MAC_ADDRESS}" || break
    echo "error: '${MAC_ADDRESS}' is not a valid mac address"
  done
  print "%s" "${MAC_ADDRESS}"
  return 0
}

initial_arp_filter() {
  if [ "${GATEWAY_MAC}" == "" ]; then
    echo "> Type in the MAC address for your gateway device"
    GATEWAY_MAC="$(read_mac_address)"
  fi
  sudo nft add element arp allowed_macs { $GATEWAY_MAC }
}

setup_firewall() {
  sudo mkdir -p /etc/nftables/custom || true
  sudo cp -vf files/etc/nftables/custom/* /etc/nftables/custom/
  sudo cp -vf files/usr/lib/systemd/system/nft-custom.service /usr/lib/systemd/system/nft-custom.service
  ! systemctl is-active firewalld &>/dev/null || sudo systemctl stop firewalld
  ! systemctl is-enabled firewalld &>/dev/null || sudo sh -c "systemctl disable firewalld; systemctl mask firewalld"
  systemctl is-enabled nft-custom &>/dev/null || sudo sh -c "systemctl enable nft-custom; systemctl unmask nft-custom"
  systemctl is-active nft-custom &>/dev/null || sudo systemctl start nft-custom
  sudo systemctl reload nft-custom &>/dev/null
  initial_arp_filter
}

setup_firewall

