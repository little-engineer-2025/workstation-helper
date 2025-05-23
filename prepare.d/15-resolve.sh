SERVICE=systemd-resolved
sudo cp -vf files/etc/systemd/resolved.conf /etc/systemd/resolved.conf
sudo cp -vf files/etc/resolv.conf /etc/resolv.conf
systemctl --quiet is-enabled ${SERVICE} || sudo systemctl enable ${SERVICE}
systemctl --quiet is-active ${SERVICE} || sudo systemctl start ${SERVICE}
sudo systemctl reload systemd-resolved
sudo resolvectl flush-caches

