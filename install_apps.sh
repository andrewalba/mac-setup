#! /usr/bin/env bash

# Installs Homebrew software.

if ! command -v brew > /dev/null; then
    ruby -e "$(curl --location --fail --show-error https://raw.githubusercontent.com/Homebrew/install/master/install)"
    export PATH="/usr/local/bin:$PATH"
    printf "export PATH=\"/usr/local/bin:$PATH\"\n" >> $HOME/.bash_profile
fi

printf "Updating brew\n"
brew upgrade && brew update

brew install mas            # Apple store cli

# printf "AppStore: Installing Xcode\n"
# mas install 497799835

printf "Installing xcode cli utils\n"
xcode-select --install

printf "brew: Installing cli packages\n"
brew install azure-cli
brew install ca-certificates
brew install git
brew install node           # NodeJS dev
brew install n              # Node manager
brew install unixodbc       # Required by IBMiAcc
brew install openssl        # Generate certificates
brew install vim            # Guilty pleasure
brew install watch
brew install wget

# Install ZSH and Oh My ZSH
brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

chsh -s /usr/local/bin/zsh
/usr/local/bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


printf "brew: Installing apps\n"
brew install --cask firefox
brew install --cask google-chrome
# brew install --cask grammarly
brew install --cask handbrake
brew install --cask iterm2
brew install --cask java
brew install --cask ngrok
brew install --cask postman
brew install --cask powershell
brew install --cask raycast
brew install --cask sourcetree            # Bitbucket git UI
brew install --cask sublime-text          # Look at purchasing for devs
brew install --cask visual-studio-code
brew install --cask vlc
brew install --cask zoomus
brew install --cask zoomus-outlook-plugin


# Installs App Store software.

if ! command -v mas > /dev/null; then
  printf "ERROR: Mac App Store CLI (mas) can't be found.\n"
  printf "       Please ensure Homebrew and mas (i.e. brew install mas) have been installed first."
  exit 1
fi

printf "AppStore: Installing The Unarchiver\n"
mas install 425424353

# printf "AppStore: Installing Magnet\n"
# mas install 441258766

printf "AppStore: Installing Microsoft Remote Desktop 10\n"
mas install 1295203466

printf "AppStore: Installing Microsoft OneDrive\n"
mas install 823766827

printf "AppStore: Installing Microsoft OneNote\n"
mas install 784801555

printf "AppStore: Installing Microsoft Excel\n"
mas install 462058435

printf "AppStore: Installing Microsoft Outlook\n"
mas install 985367838

printf "AppStore: Installing Microsoft Word\n"
mas install 462054704

printf "AppStore: Installing Microsoft PowerPoint\n"
mas install 462062816

printf "AppStore: Installing LastPass Password Manager\n"
mas install 926036361


printf "Installing offline apps..\n"
for f in offline-apps/*.pkg ;
  do sudo installer -pkg "$f" -target /
done

printf "Downloading and installing apps via .dmg links..\n"
URLs=(
  https://github.com/dieskim/MenuBarSSHCommands/releases/download/v1.0.0/MenuBarSSHCommands.dmg
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