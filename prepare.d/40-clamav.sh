# See: https://idroot.us/install-clamav-fedora-41/

# Install packages
sudo dnf install -y clamav clamav-freshclam squidclamav clamd

# Copy configuration
sudo cp -vf files/etc/clamd.d/scan.conf /etc/clamd.d/scan.conf && sudo chown root:root /etc/clamd.d/scan.conf && sudo chmod 0644 /etc/clamd.d/scan.conf
sudo cp -vf files/etc/freshclam.conf /etc/freshclam.conf && sudo chown root:root /etc/freshclam.conf && sudo chmod 0600 /etc/freshclam.conf
sudo restorecon /etc/clamd.d/scan.conf
sudo restorecon /etc/freshclam.conf

# Enable and start services
SERVICE="clamav-freshclam"
sudo systemctl start "${SERVICE}"
systemctl is-enabled --quiet "${SERVICE}" || sudo systemctl enable "${SERVICE}"
systemctl is-active --quiet "${SERVICE}" || sudo systemctl start "${SERVICE}"
sudo systemctl restart "${SERVICE}"

SERVICE="clamav-clamonacc"
sudo systemctl start "${SERVICE}"
systemctl is-enabled --quiet "${SERVICE}" || sudo systemctl enable "${SERVICE}"
systemctl is-active --quiet "${SERVICE}" || sudo systemctl start "${SERVICE}"
sudo systemctl restart "${SERVICE}"

SERVICE="clamd@scan"
sudo systemctl start "${SERVICE}"
systemctl is-enabled --quiet "${SERVICE}" || sudo systemctl enable "${SERVICE}"
systemctl is-active --quiet "${SERVICE}" || sudo systemctl start "${SERVICE}"
sudo systemctl restart "${SERVICE}"

