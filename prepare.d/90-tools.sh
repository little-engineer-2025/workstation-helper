pkgs=()
pkgs+=(git)
pkgs+=(keepassxc kpcli)
pkgs+=(vim)

sudo dnf install -y "${pkgs[@]}"

