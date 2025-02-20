# Install and configure squid http cache

which squid &>/dev/null || sudo dnf install -y squid
sudo cp -vf files/etc/squid/* /etc/squid/
systemctl --quiet is-enabled squid || sudo systemctl enable squid
systemctl --quiet is-active squid || sudo systemctl start squid
sudo systemctl reload squid
