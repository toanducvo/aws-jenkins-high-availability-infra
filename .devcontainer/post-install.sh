#!/bin/bash

# Change Timezone to Asia/Ho_Chi_Minh
TZ="Asia/Ho_Chi_Minh"
export TZ
sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ | sudo tee /etc/timezone

# Install Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Configure the Starship Shell
echo 'eval "$(starship init bash)"' >> ~/.bashrc
source ~/.bashrc

echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc

# Install Starship Preset
starship preset gruvbox-rainbow -o ~/.config/starship.toml

# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions)/g' ~/.zshrc

# Install tfenv
git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
tfenv install latest
tfenv use latest

# Set alias for Terraform
echo "alias tf=\"terraform\"" >> ~/.zshrc && echo "alias tf=\"terraform\"" >> ~/.bashrc

# Install Github CLI
sudo apt-get update && sudo apt-get install -y gh