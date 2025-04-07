
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

function install_vscode {
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

  dnf check-update
  sudo dnf install -y code
}

function install_neovim {
  # https://medium.com/@yanglyu5201/neovim-setup-for-golang-programming-68ebf59336d9
  # https://dev.to/slydragonn/ultimate-neovim-setup-guide-lazynvim-plugin-manager-23b7
  sudo dnf install -y neovim --exclude=nodejs
  # sudo dnf install -y neovim --exclude=nodejs \
  #     vim-nerdtree \
  #     vim-trailing-whitespace \
  #     vim-command-t \
  #     vim-ctrlp \
  #     vim-devicons \
  #     vim-filesystem \
  #     vim-fugitive \
  #     vim-fugitive-gitlab \
  #     vim-rhubarb \
  #     vim-go \
  #     vim-golint \
  #     vim-gv \
  #     vim-pathogen
  [ -e ~/.config ] || mkdir ~/.config
  cp -Rvf files/home/.config/nvim ~/.config
  nvim -c PlugInstall -c q -c q --headless
}

function custom_tools {
  sudo cp -vf files/usr/local/genpass /usr/local/genpass
  sudo cp -vf files/usr/local/netdiag /usr/local/netdiag
}

install_packages
install_neovim
# install_dotfiles
install_service "fix-unknown-source-rpm"
