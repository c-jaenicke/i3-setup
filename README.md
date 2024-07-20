# i3 Setup

i3 setup on Arch Linux or EndeavourOS

## Setup

1. Clone this repo
2. `cd` into the `home/.setup` folder

There you can run a number of different scripts which will copy the needed files into their respective folders in your home.

### After Running

Tasks after installing the packages and copying configs:

1. Install [junegunn/vim-plug](https://github.com/junegunn/vim-plug), a vim plugin manager.
   1. Run `.config/nvim/autoload/install-plug-vim.sh`
   2. Open `nvim`
   3. Type `:PlugInstall` hit enter
2. Install `starship` for a better shell and prompt
3. Install zsh plugins
   1. Run `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting/`
   2. Run `git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions`
4. Change your shell using `chsh -s $(which zsh)` log out and back in, or reboot
5. Perform all or most of the steps described in the following chapters

## Theming applications under i3

Common issue is that KDE and GTK application dont have theme when using i3. You need to install and setup qt6ct and lxappearance as described below.

### qt6ct

1. Install the `qt6ct` and `breeze` packages 
2. Open `qt6ct` and set the breeze and the font you want
3. Save and close
4. Edit the `/etc/environment` file and add the line `QT_QPA_PLATFORMTHEME=qt6ct` at the end. If the key already exists with the `qt5ct` value, you can replace it with `qt6ct`
5. Reboot your system

### lxappearance

1. Install the 

1. Install the `lxappearance` and the `breeze-gtk` packages
2. run `lxappearance` and change the theme
3. Save and close
4. Reboot your system

## Fonts

The following fonts are being used in this setup:
- `ttf-ibm-plex`
- `ttf-hack-nerd`

## Polybar

I use [github.com/polybar/polybar](https://github.com/polybar/polybar) as a status bar in my i3 setup. The following modules require specific packages or setup.

### checkupdates Module

Will print the number of available updates for your system. Requires the `pacman-contrib` package to be installed.

### network Module

Will show your current local ip, upload and download usage. You need to change the interfaces it uses in the `.config/polybar/config` file. You can get the available interfaces using `ip link`.

### webcam Module

Will tell you that a webcam **is currently connected**! It will not tell you if its in use! By using right click you can see the current view of the camera, this requires the `zvbi` package.

### backlight Module

Use this to change your backlight brightness on your laptop. You need to install the `light` package for this. Make sure to add your user to the `video` group using `sudo usermod -a -G video <username>` and log in again after this. Now you can change the brightness without using sudo.

### weather Module

This requires my custom weather widget [c-jaenicke/weather-go](https://github.com/c-jaenicke/weather-go).

### ag-au-price Module

Shows the current gold and silver price. Requires my custom [c-jaenicke/go-silver-gold-tracker](https://github.com/c-jaenicke/go-silver-gold-tracker) widget.

## Printing and Scanning Files

Requires:
```shell
    brlaser \
    brother-dcp1610w \
    brscan4 \
    cups \
    cups-pdf \
    sane \
    sane-airscan \
    skanlite \
```

You can add the scanner using `sudo brsaneconfig4 -a name=<NAME OF PRINTER> model=<MODEL> nodename=<HOSTNAME OF PRINTER>`.
You can try adding the printer automatically using the CUPS web interface. Alternatively you can add it manually using the web interface using the address `ipp://<HOSTNAME>/ipp/port1`.

This might not work for you because printers are great.

## Issues and Fixes

### Konsole Spacing Between Words

On some setups Konsole renders huge whitespaces between words. This is a font issue. To fix this you have to create a new profile in the Konsole settings and set the font to a monospace font! Save the profile and set is as the default.

### Scaling on High Resolutions

Add or edit the line `Xft.dpi: 192` to the `home/.Xresources` file. Exit the session and log in again.

## Generate Tree View

```shell
git ls-tree -r --name-only HEAD home| tree --fromfile -a | awk '!/directories|^$/ {print $0}'
git ls-tree -r --name-only HEAD home| tree --fromfile -a | awk '!/directories|^$/ {print $0}' > home/files.txt
```
