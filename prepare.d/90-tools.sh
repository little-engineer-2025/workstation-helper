
# Install packages
function install_packages {
  pkgs=()
  pkgs+=(git keepassxc kpcli vim did silver tmux rg bat)
  sudo dnf install -y "${pkgs[@]}"
}

# Install dotfiles
# See: https://github.com/avisiedo/dotfiles/blob/main/DOTFILES.md
function install_dotfiles {
  if [ ! -e $HOME/.dotfiles ]; then
    git clone --bare https://github.com/avisiedo/dotfiles $HOME/.dotfiles
  fi
  alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
  dotfiles config status.showUntrackedFiles no
  dotfiles checkout --force
  dotfiles config --local status.showUntrackedFiles no
}


# Add fix-unknown-source-rpm service
function install_service {
  SERVICE="$1"
  [ ! -e files/usr/local/bin/${SERVICE}.sh ] || sudo cp -vf files/usr/local/bin/${SERVICE}.sh /usr/local/bin/
  sudo cp -vf files/etc/systemd/system/${SERVICE}.service /etc/systemd/system/
  [ ! -e files/etc/systemd/system/${SERVICE}.timer ] || sudo cp -vf files/etc/systemd/system/${SERVICE}.timer /etc/systemd/system/
  systemctl --quiet is-enabled ${SERVICE} || sudo systemctl enable ${SERVICE}
  #systemctl --quiet is-active ${SERVICE}.service || sudo systemctl start ${SERVICE}.service
  [ ! -e files/etc/systemd/system/${SERVICE}.timer ] || systemctl --quiet is-enabled ${SERVICE}.timer || sudo systemctl enable ${SERVICE}.timer
  [ ! -e files/etc/systemd/system/${SERVICE}.timer ] || systemctl --quiet is-active ${SERVICE}.timer || sudo systemctl start ${SERVICE}.timer
  [ ! -e files/usr/local/bin/${SERVICE}.sh ] || sudo /usr/local/bin/${SERVICE}.sh
}

install_packages
install_dotfiles
install_service "fix-unknown-source-rpm"
