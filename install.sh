#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'
#install function
function checker () {
which "$1"
exitCode=$?
if [[ $exitCode == 0 ]]; then
    echo "$1 is installed"
else
    sudo pacman -S --noconfirm "$1"
fi
}
#add aliases here followed by \n
alias=("alias nv='nvim'" "\nalias sp='sudo pacman'" "\nalias chx='chmod +x'")
echo "Welcome to..."
echo -e " ${GREEN}
         __         ____          __            
   _____/ /_  ___  / / /_______  / /___  ______  
  / ___/ __ \/ _ \/ / / ___/ _ \/ __/ / / / __ \ 
 (__  ) / / /  __/ / (__  )  __/ /_/ /_/ / /_/ / 
/____/_/ /_/\___/_/_/____/\___/\__/\__,_/ .___/  
                                       /_/      ${NC}"
echo ""
echo -e "Do you want:\n(1) Full setup \n(2) Light setup"
read -r choice
if [[ $choice != 1 ]] && [[ $choice != 2 ]]; then
    exit
fi
#install packages
checker cmatrix
checker neofetch
checker btop
which nvim
exitCode=$?
if [[ $exitCode == 0 ]]; then
    echo "neovim is installed"
else
    sudo pacman -S --noconfirm neovim
fi
checker git
checker fastfetch
checker zsh
checker bat
checker smbclient
checker tldr
echo ""
echo "All packages installed"
echo ""
echo -e "What shell do you use? \n(1) zsh \n(2) bash \n(3) skip shell config"
read -r shell
if [[ $shell != 1 ]] && [[ $shell != 2 ]]; then
    exit
fi
if [[ $choice == 1 ]]; then
    if [[ $shell == 1 ]]; then
        #ohmyzsh installation
        wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | sed s/RUNZSH:-yes/RUNZSH:-no/g | sh
        #plugins installation
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions 
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting 
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
        git clone https://github.com/agkozak/zsh-z "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-z
        #plugins integration
        sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z)/g' ~/.zshrc
        sed -i 's@robbyrussell@powerlevel10k/powerlevel10k@g' ~/.zshrc
        #aliases add
        grep -q 'alias sp=' ~/.zshrc
        exitCode=$?
        if [ $exitCode == 0 ]; then
            echo ""
        else
            echo -e "${alias[@]}" >> ~/.zshrc
        fi
        /bin/zsh -c 'source ~/.zshrc'
        echo "changes made and applied! you can now restart your terminal for p10k configuration."
    else
        #ohmybash installation
        bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)" --unattended
        #aliases add
        grep -q 'alias sp=' ~/.bashrc
        exitCode=$?
        if [ $exitCode == 0 ]; then
            echo ""
        else
            echo -e "${alias[@]}" >> ~/.bashrc
        fi
        source ~/.bashrc
        echo "changes made and applied! you can now restart your terminal"
    fi
elif [[ $choice == 2 ]]; then
    if [[ $shell == 1 ]]; then
        #aliases add
        grep -q 'alias sp=' ~/.zshrc
        exitCode=$?
        if [ $exitCode == 0 ]; then
            echo ""
        else
            echo -e "${alias[@]}" >> ~/.zshrc
        fi
        /bin/zsh -c 'source ~/.zshrc'
        echo "changes made and applied! you can now restart your terminal"
    else
        #aliases add
        grep -q 'alias sp=' ~/.bashrc
        exitCode=$?
        if [ $exitCode == 0 ]; then
            echo ""
        else
            echo -e "${alias[@]}" >> ~/.bashrc
        fi
        source ~/.bashrc
        echo "changes made and applied! you can now restart your terminal"
    fi
fi
