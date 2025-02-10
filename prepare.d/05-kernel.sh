sudo rfkill block
modprobe --remove cfg80211 || true
modprobe --remove bluetooth || true
modprobe --remove btusb || true

# Make it permanent
files=(disable-bluetooth disable-wifi)
for file in "${files[@]}"; do
  sudo sh -c "[ -e \"/etc/modprobe.d/${file}.conf\" ] || cp -vf \"files/etc/modprobe.d/${file}.conf\" /etc/modprobe.d/"
done
