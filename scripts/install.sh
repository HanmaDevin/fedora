#! /bin/bash
#    ____           __        ____   _____           _       __
#    /  _/___  _____/ /_____ _/ / /  / ___/__________(_)___  / /_
#    / // __ \/ ___/ __/ __ `/ / /   \__ \/ ___/ ___/ / __ \/ __/
#  _/ // / / (__  ) /_/ /_/ / / /   ___/ / /__/ /  / / /_/ / /_
# /___/_/ /_/____/\__/\__,_/_/_/   /____/\___/_/  /_/ .___/\__/
#                                                  /_/
clear

location="$HOME/fedora"

installPackages() {
    sudo dnf install -y $(cat "$location/packages.txt")
}

installVencord() {
  echo "Want to install Venord?"
  vencord=$(gum choose "Yes" "No")

  if [[ "$vencord" == "Yes" ]]; then
    bash "$location/Vencord/VencordInstaller.sh"
    cp -r "$location/Vencord/themes" "$HOME/.var/app/com.discordapp.Discord/config/Vencord/"
  fi
}

copy_config() {
  gum spin --spinner dot --title "Creating bakups..." -- sleep 2

  if [[ -f "$HOME/.zshrc" ]]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
  fi
  cp "$location/.zshrc" "$HOME/"

  if [[ -d "$HOME/.config" ]]; then
    mv "$HOME/.config" "$HOME/.config.bak"
  fi
  cp -r "$location/.config/" "$HOME/"

  cp -r "$location/Vencord/themes" "$HOME/.config/Vencord/"

  if [[ ! -d "$HOME/Pictures/Screenshots" ]]; then
    mkdir "$HOME/Pictures/Screenshots"
  fi

  if [[ ! -d "$HOME/Pictures/" ]]; then
    mkdir "$HOME/Pictures/"
  fi
  cp -r "$location/Wallpaper" "$HOME/Pictures/"

  sudo cp "$location/scripts/pullall.sh" "/usr/sbin"
  sudo cp "$location/scripts/spf" "/usr/sbin"
  sudo cp -r "$location/fonts" "/usr/share/"
  sudo cp -r "$location/icons/" "/usr/share/"
  sudo cp -r "$location/themes/" "/usr/share/"
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

echo "Post Fedora installation Setup"
echo -e "${NONE}"

sudo dnf update
installPackages

gum spin --spinner dot --title "Starting setup now..." -- sleep 2
copy_config
configure_git
installVencord

curl -o- https://fnm.vercel.app/install | bash
curl -fsSL https://ollama.com/install.sh | sh
curl -fsSL https://starship.rs/install.sh | sudo sh

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

flatpak install discord
flatpak install flathub com.mattjakeman.ExtensionManager

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

