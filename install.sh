#!/bin/bash 
GREEN='\033[0;32m'
NC='\033[0m'
#current dir
currentDir=$(pwd)
#install function
which dnf
dnfCode=$?
which pacman
pacmanCode=$?
which apt
aptCode=$?
if [[ $dnfCode == 0 ]]; then
  function checker(){
    sudo dnf -y install "$1"
  }
elif [[ $pacmanCode == 0 ]]; then
  function checker(){
    sudo pacman -S --noconfirm --needed "$1"
  }
elif [[ $aptCode == 0 ]]; then
  sudo apt -y install "$1"
else
  echo "This package manager is not supported yet"
fi
#add aliases here followed by \n
alias=("alias nv='nvim'" "\nalias sp='sudo pacman'" "\nalias chx='chmod +x'" "\nalias gitc='git add .; git commit -m 'New Additions'; git push'")
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
checker git
checker neovim
checker fastfetch
checker zsh
checker bat
checker smbclient
checker tldr
checker fzf
if [[ $pacmanCode == 0 ]]; then
  which yay
  exitCode=$?
  if [[ $exitCode == 0 ]]; then
    echo ""
  else
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
  makepkg -si --noconfirm
    cd ..
    rm -rf yay
    cd "$currentDir" || exit
  fi
else
  echo ""
fi
wget "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS NF Regular.ttf"
mkdir ~/.local/share/fonts
mv 'MesloLGS NF Regular.ttf' ~/.local/share/fonts
echo ""
echo "All packages installed"
echo ""
echo -e "What shell do you want to use? \n(1) zsh \n(2) bash \n(3) skip shell config"
read -r shell
if [[ $shell != 1 ]] && [[ $shell != 2 ]]; then
    exit
fi
if [[ $choice == 1 ]]; then
    if [[ $shell == 1 ]]; then
        #check if zsh is installed and make default shell
        checker zsh
        Shell=$(which zsh)
        if [[ $SHELL != "$Shell" ]]; then
          chsh -s "${Shell}"
        else
          echo ""
        fi
        #ohmyzsh installation
        wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | sed s/RUNZSH:-yes/RUNZSH:-no/g | sh
        #plugins installation
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions 
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
        git clone https://github.com/agkozak/zsh-z ~/.oh-my-zsh/custom/plugins/zsh-z
        git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ~/.oh-my-zsh/custom/plugins/fzf-zsh-plugin
        #plugins integration
        sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z fzf)/g' ~/.zshrc
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
        echo "changes made and applied! you can now restart your terminal for p10k configuration. make sure to change your font to MesloLGS in your console settings."
    else
        #make sure bash is installed
        checker bash
        Shell=$(which bash)
        if [[ $SHELL != "$Shell" ]]; then
          chsh -s "${Shell}"
        else
          echo ""
        fi
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
        #check if zsh is installed and make default shell
        checker zsh
        Shell=$(which zsh)
        if [[ $SHELL != "$Shell" ]]; then
          chsh -s "${Shell}"
        else
          echo ""
        fi
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
        #make sure bash is installed 
        checker bash
        Shell=$(which bash)
        if [[ $SHELL != "$Shell" ]]; then
          chsh -s "${Shell}"
        else
          echo ""
        fi
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
