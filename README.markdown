# Installation

## Auto Install
**Please install [oh my zsh](https://github.com/ohmyzsh/ohmyzsh) and [LunarVim](https://github.com/LunarVim/LunarVim) first!**


Then, open termnial and run this command:
```sh
bash <(curl -s https://raw.githubusercontent.com/hungdinhvan/dotfiles/master/install.sh)
```
## Manual installation
```sh
# cd to home 
cd ~
# clone repo
git clone git@github.com:hungdinhvan/dotfiles.git  
# chmod executable install script
sudo chmod +x ./install.sh
# run install script
./install.sh

```

# Update
Simply running a `git pull` inside the cloned folder

```sh
cd ~/.dotfiles
git pull
./install.sh

```
### Notes

If you want an example lunarvim config file, you can use my [config file](https://github.com/hungdinhvan/lvim-config.lua)

