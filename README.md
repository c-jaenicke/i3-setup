# i3 Setup

i3 setup on Arch Linux or EndeavourOS

## Setup

1. Clone this repo
2. `cd` into the `home/.setup` folder

There you can run a number of different scripts which will copy the needed files into their respective folders in your home.

- copy-bin_folder.sh: copy all files in .bin folder to user .bin folder
- copy-minimal_shell_configs.sh: copy shell configs with minimal dependencies to user home 
- install-desktop_packages.sh: install packages typically used on desktop system
- copy-configs.sh: copy all folders in .config folder to user .config folder
- create_folders.sh: create folder structure in user home
- install-yay.sh: install yay
- copy-full_shell_configs.sh: copy regular shell configs to user home
- install-desktop_packages-additional.sh: install additional packages for desktop system
- setup-server_packages.sh: install packages typically used on servers

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

## Changing Default Editor, Browser and Compiler

Make sure to change the values `EDITOR=`, `SUDO_EDITOR=`, `BROWSER=` in `.zprofile` in your home directory.

Additionally, change the values of `CC=` and `CXX=` to change the default compilers for C and C++ respectively.

## Theming Applications When Using i3

Common issue is that KDE and GTK application dont have theme when using i3. You need to install and setup qt6ct and lxappearance as described below.

### Qt6ct

1. Install the `qt6ct` and `breeze` packages 
2. Open `qt6ct` and set the breeze and the font you want
3. Save and close
4. Edit the `/etc/environment` file and add the line `QT_QPA_PLATFORMTHEME=qt6ct` at the end. If the key already exists with the `qt5ct` value, you can replace it with `qt6ct`
5. Reboot your system

### Lxappearance

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

### Checkupdates Module

Will print the number of available updates for your system. Requires the `pacman-contrib` package to be installed.

### Network Module

Will show your current local ip, upload and download usage. You need to change the interfaces it uses in the `.config/polybar/config` file. You can get the available interfaces using `ip link`.

### Webcam Module

Will tell you that a webcam **is currently connected**! It will not tell you if its in use! By using right click you can see the current view of the camera, this requires the `zvbi` package.

### Backlight Module

Use this to change your backlight brightness on your laptop. You need to install the `light` package for this. Make sure to add your user to the `video` group using `sudo usermod -a -G video <username>` and log in again after this. Now you can change the brightness without using sudo.

### Weather Module

This requires my custom weather widget [c-jaenicke/weather-go](https://github.com/c-jaenicke/weather-go).

### Ag-au-price Module

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

### Discover Printers on Network

To discover printers on your network, for automatic setup: 

1. Install the `avahi` package.
2. Start the `avahi-daemon.service`.
3. Open port `5353 UDP` on your local firewall.
4. Restart the `cups.service`.
5. Scan for printers using the CUPS web interface.

## Increase Number of Cores Used for Compiling

Edit the `/etc/makepkg.conf` file. Add or edit the `MAKEFLAGS=` variable to `MAKEFLAGS="-j$(nproc)"`.

## Change Hostname

Change your hostname using `sudo hostnamectl hostname <NEW HOSTNAME HERE>`.

## Issues and Fixes

### Konsole Spacing Between Words

On some setups Konsole renders huge whitespaces between words. This is a font issue. To fix this you have to create a new profile in the Konsole settings and set the font to a monospace font! Save the profile and set is as the default.

### Scaling on High Resolutions

Add or edit the line `Xft.dpi: 192` to the `home/.Xresources` file. Exit the session and log in again.

### Applications not using kdewallet

Sometimes fixed by installing `kwalletmanager` and `kwallet-pam`. Sometimes just installing `kwalletmanager`, opening it, unlocking the keyring, and then log into the application.

### Fix Recommendations in Rofi

Edit your local file `.cache/rofi3.druncache`.

### No Clipboard in VIM and NVIM

Make sure one of following clipboard providers is installed [Neovim Docs Provider (neovim.io)](https://neovim.io/doc/user/provider.html#_clipboard-integration):

- g:clipboard (unless unset or false)
- pbcopy, pbpaste (macOS)
- wl-copy, wl-paste (if $WAYLAND_DISPLAY is set)
- waycopy, waypaste (if $WAYLAND_DISPLAY is set)
- xsel (if $DISPLAY is set)
- xclip (if $DISPLAY is set)
- lemonade (for SSH) https://github.com/pocke/lemonade
- doitclient (for SSH) https://www.chiark.greenend.org.uk/~sgtatham/doit/
- win32yank (Windows)
- putclip, getclip (Windows) https://cygwin.com/packages/summary/cygutils.html
- clip, powershell (Windows) https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/clip
- termux (via termux-clipboard-set, termux-clipboard-set)
- tmux (if $TMUX is set)

## Generate Tree View

```shell
git ls-tree -r --name-only HEAD home| tree --fromfile -a | awk '!/directories|^$/ {print $0}'
git ls-tree -r --name-only HEAD home| tree --fromfile -a | awk '!/directories|^$/ {print $0}' > home/files.txt
```

## Hotkeys

Cheat sheet for the most important apps in my i3 setup.

### i3

`mod = Super Key / Windows`

| keys / command                                | function                                      |
|-----------------------------------------------|-----------------------------------------------|
| `mod + Enter`                                 | start terminal                                |
| `mod + d`                                     | execute rofi script                           |
|                                               |                                               |
| `mod + shift + q`                             | kill current selection                        |
| `mod + j` `mod + left arrow`                  | move focus to left                            |
| `mod + k` `mod + down arrow`                  | move focus to down                            |
| `mod + l` `mod + up arrow`                    | move focus to up                              |
| `mod + ö` `mod + right arrow`                 | move focus to right (disabled)                |
| `mod + shift + j` `mod + shift + left arrow`  | move focus to left                            |
| `mod + shift + k` `mod + shift + down arrow`  | move focus to down                            |
| `mod + shift + l` `mod + shift + up arrow`    | move focus to up                              |
| `mod + shift + ö` `mod + shift + right arrow` | move focus to right (disabled)                |
|                                               |                                               |
| `mod + h`                                     | split horizontal                              |
| `mod + v`                                     | split vertical                                |
| `mod + f`                                     | toggle fullscreen                             |
| `mod + s`                                     | stacking mode                                 |
| `mod + w`                                     | tabbed mode                                   |
| `mod + e`                                     | toggle split orientation                      |
| `mod + shift + space`                         | toggle floating mode                          |
| `mod + space`                                 | toggle between floating and window underneath |
| `mod + a`                                     | focus parent window                           |
|                                               |                                               |
| `mod + number`                                | switch to workspace number                    |
| `mod + shift + number`                        | move window to workspace number               |
|                                               |                                               |
| `mod + shift + c`                             | reload configuration file                     |
| `mod + shift + r`                             | reload i3                                     |
| `mod + shift + e`                             | exit i3                                       |
|                                               |                                               |
| `mod + r`                                     | switch to resize mode                         |
| `j` `left arrow`                              | shrink width                                  |
| `k` `down arrow`                              | grow height                                   |
| `l` `up arrow`                                | shrink height                                 |
| `;` `ö` `right arrow`                         | grow width                                    |
| `escape` `enter` `mod + r`                    | exit resize mode                              |
|                                               |                                               |
| `mod + shift + o`                             | move window to left monitor                   |
| `mod + shift + p`                             | move window to right monitor                  |

### dunst - notification daemon

| keys / command         | function                    |
|------------------------|-----------------------------|
| `left click`           | close current notification  |
| `right click`          | do an action                |
| `middle click`         | close all notifications     |
| `ctrl + space`         | close current notifications |
| `ctrl + shift + space` | close all notifications     |
| `ctrl + grave`         | show history                |
| `ctrl + shift + .`     | show context menu           |

### Alacritty - terminal emulator

| keys / command          | function        |
|-------------------------|-----------------|
| `ctrl + l`              | clear logs      |
| `shift + page up`       | scroll up       |
| `shift + page down`     | scroll down     |
| `shift + home`          | go to top       |
| `shift + end`           | go to bottom    |
|                         |                 |
| `enter`                 | confirm search  |
| `esc` `ctrl + c`        |                 |
| `ctrl + u`              | clear search    |
| `ctrl + w`              | delete word     |
| `ctrl + p` `up arrow`   | previous search |
| `ctrl + n` `down arrow` | next search     |
| `enter`                 | focus next      |
| `shift + enter`         | focus previous  |
|                         |                 |
| `shift + ctrl + space`  | toggle vi mode  |
| `esc`                   | clear selection |
| `ctrl + c`              | cancel vim mode |
