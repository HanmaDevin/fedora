#! /bin/bash
#    ____           __        ____   _____           _       __
#    /  _/___  _____/ /_____ _/ / /  / ___/__________(_)___  / /_
#    / // __ \/ ___/ __/ __ `/ / /   \__ \/ ___/ ___/ / __ \/ __/
#  _/ // / / (__  ) /_/ /_/ / / /   ___/ / /__/ /  / / /_/ / /_
# /___/_/ /_/____/\__/\__,_/_/_/   /____/\___/_/  /_/ .___/\__/
#                                                  /_/
clear

repo="$HOME/fedora"

packages=("fedora-workstation-repositories" "wget" "python3-pip" "gum" "discord" "curl" "zip" "zoxide" "fzf" "bat" "ripgrep" "xsel" "ssh" "kvantum" "p7zip" "gdb" "google-chrome-stable" "lsd" "jq" "calc" "golang" "rustup" "texlive-scheme-full" "neovim" "sed" "openvpn" "fd-find" "java-25-openjdk" "java-25-openjdk-devel" "zsh" "btop" "mpv" "fastfetch")

installPackages() {
    for package in "${packages[@]}"
    do
    	sudo dnf install -y "$package"
    done
}

install_catppuccin_theme() {
  git clone --depth=1 https://github.com/catppuccin/kde "$HOME/catppuccin-kde" && cd "$HOME/catppuccin-kde"
  bash ./install.sh
}

installVencord() {
  echo "Want to install Venord?"
  vencord=$(gum choose "Yes" "No")

  if [[ "$vencord" == "Yes" ]]; then
    bash "$repo/Vencord/VencordInstaller.sh"
    cp -r "$repo/Vencord/themes" "$HOME/.var/app/com.discordapp.Discord/config/Vencord/"
  fi
}

detect_nvidia() {
  gpu=$(lspci | grep -i '.* vga .* nvidia .*')

  shopt -s nocasematch

  if [[ $gpu == *' nvidia '* ]]; then
    echo "Nvidia GPU is present"
    gum spin --spinner dot --title "Installaling nvidia drivers now..." -- sleep 2
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
  else
    echo "It seems you are not using a Nvidia GPU"
    echo "If you have a Nvidia GPU then download the drivers yourself please :)"
  fi
}

copy_config() {
  gum spin --spinner dot --title "Creating bakups..." -- sleep 2

  if [[ -f "$HOME/.zshrc" ]]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
  fi
  cp "$repo/.zshrc" "$HOME/"

  if [[ -d "$HOME/.config" ]]; then
    mv "$HOME/.config" "$HOME/.config.bak"
  fi
  cp -r "$repo/.config/" "$HOME/"

  cp -r "$repo/Vencord/themes" "$HOME/.config/Vencord/"

  if [[ ! -d "$HOME/Pictures/" ]]; then
    mkdir "$HOME/Pictures/"
  fi
  cp -r "$repo/Wallpaper" "$HOME/Pictures/"

  sudo cp "$repo/scripts/pullall.sh" "/usr/sbin"
  sudo cp "$repo/scripts/spf" "/usr/sbin"
  sudo cp -r "$repo/fonts" "/usr/share/"
  sudo cp -r "$repo/icons/" "/usr/share/"
}

configure_git() {
  echo "Want to configure git?"
  gitconfig=$(gum choose "Yes" "No")
  if [[ "$gitconfig" == "Yes" ]]; then

    username=$(gum input --prompt "> What is your github user name?")
    git config --global user.name "$username"
    useremail=$(gum input --prompt "> What is your github email?")
    git config --global user.email "$useremail"
    git config --global pull.rebase true
  fi

  echo "Want to create a ssh-key?"
  ssh=$(gum choose "Yes" "No")
  if [[ "$ssh" == "Yes" ]]; then
    ssh-keygen -t ed25519 -C "$useremail"
  fi

  echo "Want to create a physical key?"
  key=$(gum choose "Yes" "No")
  if [[ $key == "Yes" ]]; then
    read -r -p "Insert a device like a YubiKey and press enter..."
    ssh-keygen -t ecdsa-sk -b 521
  fi
}

MAGENTA='\033[0;35m'
NONE='\033[0m'

# Header
echo -e "${MAGENTA}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/

EOF

echo "Post Fedora KDE setup"
echo -e "${NONE}"

sudo dnf update -y
sudo dnf install \
      https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update --refresh
sudo dnf config-manager setopt google-chrome.enabled=1
installPackages
detect_nvidia

gum spin --spinner dot --title "Starting setup now..." -- sleep 2
copy_config
configure_git

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

curl -o- https://fnm.vercel.app/install | bash
curl -fsSL https://ollama.com/install.sh | sh
curl -fsSL https://starship.rs/install.sh | sudo sh

install_catppuccin_theme

konsave -i "$repo/kde.knsv"

echo -e "${MAGENTA}"
cat <<"EOF"
____             
| __ ) _   _  ___ 
|  _ \| | | |/ _ \
| |_) | |_| |  __/
|____/ \__, |\___|
       |___/      
EOF
echo -e "${NONE}"

