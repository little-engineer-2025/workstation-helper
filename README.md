# Workstation helper

Scripts to quickly setup the workstations with some
common customizations.

```raw
git clone https://github.com/little-engineer-2025/workstation-helper.git
./prepare.sh
```

## TODO

- [] NFT table rules for:
     egress 443/tcp
     egress 123/udp
     egress 853/tcp
     egress 80/tcp for OCSP
     Allow ping
- [] Add ARP filter (nft or squid?)

## References

- https://github.com/maravento/blackweb/tree/master
- About pipewire: https://fedoramagazine.org/introduction-to-pipewire/
- About Deny Internet Access by cgroup: https://serverfault.com/questions/550276/how-to-block-internet-access-to-certain-programs-on-linux

