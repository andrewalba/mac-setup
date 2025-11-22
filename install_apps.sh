#! /usr/bin/env bash

# Installs Homebrew software using Brewfile.

if ! command -v brew > /dev/null; then
    ruby -e "$(curl --location --fail --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
    export PATH="/usr/local/bin:$PATH"
    printf "export PATH=\"/usr/local/bin:$PATH\"\n" >> $HOME/.bash_profile
fi

printf "Updating brew\n"
brew upgrade && brew update

printf "Installing Xcode CLI tools\n"
xcode-select --install

printf "Installing all Brewfile packages\n"
# Ensure Brewfile is in same directory as this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
brew bundle --file="$SCRIPT_DIR/Brewfile"

# ZSH setup (unchanged)
chsh -s /usr/local/bin/zsh
/usr/local/bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

printf "Installing offline apps..\n"
for f in offline-apps/*.pkg ;
  do sudo installer -pkg "$f" -target /
done

printf "Downloading and installing apps via .dmg links..\n"
URLs=(
  https://github.com/albawebstudio/MenuBarSSHCommands/releases/download/v1.0.0/MenuBarSSHCommands.dmg
)

for i in "${URLs[@]}";
do
  wget --no-check-certificate -P ~/Downloads/ "$i"
  DMG=$(echo $i | rev | cut -d / -f 1 | rev)
  VOL=$(hdiutil attach ~/Downloads/$DMG | grep -i '/Volumes/' | awk -F " " '{print $3}')

  if [ -e "$VOL"/*.app ]; then
    sudo cp -rf "$VOL"/*.app /Applications/
  elif [ -e "$VOL"/*.pkg ]; then
    package=$(ls -1 "$VOL" | grep .pkg | head -1)
    sudo installer -pkg "$VOL"/"$package" -target /
  elif [ -e "$VOL"/*.mpkg ]; then
    package=$(ls -1 "$VOL" | grep .mpkg | head -1)
    sudo installer -pkg "$VOL"/"$package" -target /
  fi

  hdiutil unmount "$VOL"
done
