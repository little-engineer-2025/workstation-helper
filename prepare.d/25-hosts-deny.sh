# See: https://github.com/StevenBlack/hosts?tab=readme-ov-file
# See: https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/blob/master/hosts.deny/hosts0.deny

[ -e /etc/hosts.orig ] || sudo cp -vf /etc/hosts /etc/hosts.orig
curl -o /tmp/hosts.denylist "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social-only/hosts"
sudo cp -vf /tmp/hosts.denylist /etc/hosts.denylist
cat /etc/hosts.orig /etc/hosts.denylist | sudo tee /etc/hosts > /dev/null

curl -o /tmp/hosts.deny "https://raw.githubusercontent.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/refs/heads/master/hosts.deny/hosts0.deny"
sudo cp -vf /tmp/hosts.deny /etc/hosts.deny

