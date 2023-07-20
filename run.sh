#! /bin/sh

# Update Mac
softwareupdate --all --install --force

# Install oh-my-zsh

which -s zsh
if [[ $? = 0 ]] ; then
	echo "zsh is installed"
  if [ -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh is installed"
   else
    echo "Installing oh-my-zsh."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
 else
 	echo "zsh and oh-my-zsh is not installed"
 	echo "Installing"
 	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
 	echo "Finished installing ohmyzsh"
fi


#Install HomeBrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/hikar/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update
fi

# Install MesloLGS NF fonts for powerlevel10k
echo "Installing MesloLGS NF fonts for powerlevel10k..."

# Create a temporary directory
temp_fonts_dir="$(mktemp -d)"

# Download each font file
for type in Regular Bold Italic Bold%20Italic; do
    font_url="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${type}.ttf"
    local_path="${temp_fonts_dir}/MesloLGS NF ${type}.ttf"
    curl -Lo "${local_path}" "${font_url}"
    # Use `open` to install the font
    open "${local_path}"

    # Wait for the user to confirm that the font has been installed
    read -p "Please ensure the font MesloLGS NF ${type} is installed in Font Book, then press enter to continue."
done

# Remove the temporary directory
rm -rf "${temp_fonts_dir}"



#Install programs

brew list romkatv/powerlevel10k/powerlevel10k || brew install romkatv/powerlevel10k/powerlevel10k
if grep -Fxq "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" ~/.zshrc
then
    echo "powerlevel10k already added to .zshrc"
else
    echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
fi

brew list rust || brew install rust
brew list intellij-idea || brew install intellij-idea
brew list android-platform-tools || brew install android-platform-tools
brew list android-studio || brew install android-studio
brew list nvm || brew install nvm

#Dodaj sprawdzenie czy poniższe linie są dodane do ~/.zshrc
echo 'export NVM_DIR=~/.nvm' >> ~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.zshrc
echo "NVM installed"