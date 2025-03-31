
sudo mkdir -p /etc/nftables/custom || true
sudo cp -vf files/etc/nftables/custom/* /etc/nftables/custom/
sudo cp -vf files/usr/lib/systemd/system/nft-custom.service /usr/lib/systemd/system/nft-custom.service
! systemctl is-active firewalld &>/dev/null || sudo systemctl stop firewalld
! systemctl is-enabled firewalld &>/dev/null || sudo sh -c "systemctl disable firewalld; systemctl mask firewalld"
systemctl is-enabled nft-custom &>/dev/null || sudo sh -c "systemctl enable nft-custom; systemctl unmask nft-custom"
systemctl is-active nft-custom &>/dev/null || sudo systemctl start nft-custom

