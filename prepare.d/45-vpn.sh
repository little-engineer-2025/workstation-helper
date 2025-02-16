# Install packages

# See: https://fedoramagazine.org/configure-wireguard-vpns-with-networkmanager/
sudo dnf install -y wireguard-tools

[ -e /etc/wireguard ] || sudo mkdir -p /etc/wireguard
if [ ! -e /etc/wireguard/privatekey ] || [ ! -e /etc/wireguard/publickey ]; then
  sudo bash -c 'cd /etc/wireguard; wg genkey | tee privatekey | wg pubkey > publickey'
fi
cat <<EOF | sudo tee /etc/wireguard/wg0.conf >/dev/null
[Interface]
Address = 172.16.1.254/24
SaveConfig = true
ListenPort = 60001
PrivateKey = $(sudo cat /etc/wireguard/privatekey)

[Peer]
PublicKey = $(sudo cat /etc/wireguard/publickey)
AllowedIPs = 172.16.1.2/32
EOF

