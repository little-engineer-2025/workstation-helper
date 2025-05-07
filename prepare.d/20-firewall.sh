#!/bin/bash

check_mac_address() {
  local mac="$1"

  [ ${#mac} -eq 17 ] || return 1

  # Check separators
  for idx in 2 5 8 11 14; do
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
  local MAC_ADDRESS
  while true; do
    printf "%s" "Write a MAC address: " >&2
    read -r MAC_ADDRESS
    ! check_mac_address "${MAC_ADDRESS}" || break
    echo "error: '${MAC_ADDRESS}' is not a valid mac address" >&2
  done
  printf "%s" "${MAC_ADDRESS}"
  return 0
}

initial_arp_filter() {
  arp -n
  if [ "${GATEWAY_MAC}" == "" ]; then
    GATEWAY_MAC="$(read_mac_address)"
  fi
  arp-add "$GATEWAY_MAC"
}

setup_firewall() {
  sudo mkdir -p /etc/nftables/custom || true
  sudo chmod 0600 /etc/nftables/custom/{arp,drop-all,main,nat,router}.nft
  sudo cp -vf files/etc/nftables/custom/{arp,drop-all,main,nat,router}.nft /etc/nftables/custom/
  sudo chmod 0400 /etc/nftables/custom/{arp,drop-all,main,nat,router}.nft
  sudo cp -vf files/usr/lib/systemd/system/nft-custom.service /usr/lib/systemd/system/nft-custom.service
  ! systemctl is-active firewalld &>/dev/null || sudo systemctl stop firewalld
  ! systemctl is-enabled firewalld &>/dev/null || sudo sh -c "systemctl disable firewalld; systemctl mask firewalld"
  systemctl is-enabled nft-custom &>/dev/null || sudo sh -c "systemctl enable nft-custom; systemctl unmask nft-custom"
  systemctl is-active nft-custom &>/dev/null || sudo systemctl start nft-custom
  sudo systemctl daemon-reload &>/dev/null
  sudo systemctl reload nft-custom &>/dev/null
  sudo cp -vf ./files/usr/local/bin/arp-add /usr/local/bin/
  sudo cp -vf ./files/usr/local/bin/arp-delete /usr/local/bin/
  initial_arp_filter
}

setup_firewall
