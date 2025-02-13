# See: https://github.com/StevenBlack/hosts?tab=readme-ov-file
# See: https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/blob/master/hosts.deny/hosts0.deny
SERVICE=update-hosts-deny

# Setup service
[ -e /etc/systemd/system/${SERVICE}.service ] || sudo cp -vf files/etc/systemd/system/${SERVICE}.service /etc/systemd/system/
[ -e /etc/systemd/system/${SERVICE}.timer ]   || sudo cp -vf files/etc/systemd/system/${SERVICE}.timer /etc/systemd/system/
[ -e /usr/local/bin/${SERVICE}.sh ] || sudo cp -vf files/usr/local/bin/${SERVICE}.sh /usr/local/bin/

sudo systemctl daemon-reload
systemctl --quiet is-enabled ${SERVICE} || sudo systemctl enable ${SERVICE}
systemctl --quiet is-active ${SERVICE} || sudo systemctl start ${SERVICE}

