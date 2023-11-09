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

printf "Installing xcode cli utils\n"
xcode-select --install

printf "brew: Installing cli packages\n"
arch -arm4 brew install awscli
arch -arm4 brew install azure-cli
arch -arm4 brew install ca-certificates
arch -arm4 brew install git
arch -arm4 brew install node           # NodeJS dev
arch -arm4 brew install n
arch -arm4 brew install openssl        # Generate certificates
arch -arm4 brew install starship
arch -arm4 brew install vim            # Guilty pleasure
arch -arm4 brew install watch
arch -arm4 brew install wget

# Install ZSH and Oh My ZSH
arch --arm64 brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting

chsh -s /usr/local/bin/zsh
/usr/local/bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

printf "brew: Installing apps\n"
arch -arm64 brew install --cask espanso
arch -arm64 brew install --cask firefox
arch -arm64 brew install --cask folx
arch -arm64 brew install --cask google-chrome
arch -arm64 brew install --cask grammarly
arch -arm64 brew install --cask handbrake
arch -arm64 brew install --cask iterm2
arch -arm64 brew install --cask java
arch -arm64 brew install --cask jetbrains-toolbox
arch -arm64 brew install --cask microsoft-edge
arch -arm64 brew install --cask microsoft-teams
arch -arm64 brew install --cask mjml
arch -arm64 brew install --cask ngrok
arch -arm64 brew install --cask nomad
arch -arm64 brew install --cask obs
arch -arm64 brew install --cask postman
arch -arm64 brew install --cask powershell
arch -arm64 brew install --cask r
arch -arm64 brew install --cask raycast
arch -arm64 brew install --cask rstudio
arch -arm64 brew install --cask skype
arch -arm64 brew install --cask sourcetree
arch -arm64 brew install --cask subler
arch -arm64 brew install --cask sublime-text          # Look at purchasing for devs
arch -arm64 brew install --cask unclutter
arch -arm64 brew install --cask visual-studio-code
arch -arm64 brew install --cask vlc
arch -arm64 brew install --cask yed
arch -arm64 brew install --cask zoom
arch -arm64 brew install --cask zoomus
arch -arm64 brew install --cask zoomus-outlook-plugin


# Installs App Store software.

if ! command -v mas > /dev/null; then
  printf "ERROR: Mac App Store CLI (mas) can't be found.\n"
  printf "       Please ensure Homebrew and mas (i.e. brew install mas) have been installed first."
  exit 1
fi


printf "AppStore: Installing Bitwarden\n"
mas install 1352778147

printf "AppStore: Installing iMovie\n"
mas install 408981434

printf "AppStore: Installing Keynote\n"
mas install 409183694

printf "AppStore: Installing Magnet\n"
mas install 441258766

printf "AppStore: Installing Microsoft Word\n"
mas install 462054704

printf "AppStore: Installing Microsoft Excel\n"
mas install 462058435

printf "AppStore: Installing Microsoft PowerPoint\n"
mas install 462062816

printf "AppStore: Installing Microsoft OneNote\n"
mas install 784801555

printf "AppStore: Installing Numbers\n"
mas install 409203825

printf "AppStore: Installing OneDrive\n"
mas install 823766827

printf "AppStore: Installing Microsoft Outlook\n"
mas install 985367838

printf "AppStore: Installing Pages\n"
mas install 409201541

printf "AppStore: Installing The Unarchiver\n"
mas install 425424353

printf "AppStore: Installing VPN Surfshark - Private Web\n"
mas install 1437809329


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