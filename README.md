# i3 (Sway) Setup

The repository name is a lie, i have since switched to sway.

Sway setup on Arch Linux or EndeavourOS. (The setup uses a base installation of KDE, sway building on top of it).

## Install Packages

Install all packages for the sway setup using

```
sudo bash ./setup-scripts/install-desktop-packages.sh <OS, arch or debian or suse>
```

## Multimedia Codecs (openSUSE)

openSUSE's official repos ship media libraries/players without patent-encumbered codecs
(H.264, AAC, MP3, etc.). Install the Packman codec packages using `opi`:

```
sudo zypper in opi && sudo opi codecs
```

## Changing Default Editor, Browser and Compiler

Make sure to change the values `EDITOR=`, `SUDO_EDITOR=`, `BROWSER=` in `.zprofile` in your home directory.

Additionally, change the values of `CC=` and `CXX=` to change the default compilers for C and C++ respectively.

## Change Shell

Change the shell to `zsh` using:

```
chsh -s $(which zsh)
```

## Neovim

Plugins are installed automatically when starting neovim for the first time.

Install parers using `:TSManager` in neovim, using `i` to install parsers.

## Install zsh Plugins

Install zsh plusings using

```shell
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```

## Set Up Git

1. Set global Git username `git config --global user.name ""` or repo username `git config user.name ""`.
2. Set global Git email `git config --global user.email ""` or repo remail git `git config user.email ""`.
3. Create SSH key for auth and signing `mkdir $HOME/.ssh/git`, `cd $HOME/.ssh/git`, `ssh-keygen -t ed25519 -C "email"`, save in file called git, add public key to github profile.
4. Set global key to ssh for sining `git config --global gpg.format ssh` or
5. Set ssh key used for sining `git config --global user.signingkey $HOME/.ssh/git/git`
6. Enable auto signing of commits `git config --global commit.gpgsign true`

## Login Screen

Create the file `/etc/sddm.conf.d/99-settings.conf` with the following content:

```
[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Theme]
Current=breeze

[Autologin]
Relogin=false
Session=
User=

[Users]
MaximumUid=60513
MinimumUid=60513
RememberLastUser=false
```

### Login Using Fingerprint

1. Install the required packages `fprintd imagemagick`
2. Edit `/etc/pam.d/sddm` and add the following to the top:
   ```
   auth        [success=1 new_authtok_reqd=1 default=ignore]       pam_unix.so try_first_pass likeauth nullok
   auth        sufficient  	pam_fprintd.so
   ```
3. Enroll the right index finger (or any other finger) using `fprintd-enroll -f right-index-finger`

You can add the lines to other pam files too, e.g. `/etc/pam.d/swaylock`.

## Qt6ct

To set a theme for GTK/QT applications, use `qt6ct`.

1. Install the `qt6ct` and `breeze` packages
2. Open `qt6ct` and set the breeze and font
3. Save and close
4. Edit the `.zprofile` file and add the line `QT_QPA_PLATFORMTHEME=qt6ct`
5. Reboot your system

## Fonts

The following fonts are being used

- `ttf-ibm-plex`
- `ttf-hack-nerd`
- `monospace`

## QEMU

1. Install the required packages `qemu-full libvirt dnsmasq virt-manager`
2. Add the current user to the libvirt group `usermod -aG libvirt $USER`

## Docker

1. Install the required packages `docker docker-compose`
2. Stop the running docker service using `sudo systemctl disable --now docker.service docker.socket`
   and delete the existing socket `sudo rm /var/run/docker.sock`
3. Run `bash /usr/bin/dockerd-rootless.sh install` to setup rootless docker.
4. Start the user service using `systemctl --user start docker`

**Rootless docker requires the `uidmap` package, providing the `newuidmap` and `newgidmap` functions.**

## Theming Libre Office

```sudo zypper install libreoffice-gtk3 libreoffice-qt5 libreoffice-icon-theme-breeze```

## Printing and Scanning Files

This setup is for my shit printer and this will most likely differ for your shit printer.

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

Add the scanner using
`sudo brsaneconfig4 -a name=<NAME OF PRINTER> model=<MODEL> nodename=<HOSTNAME OF PRINTER>`.
You can try adding the printer automatically using the CUPS web interface. Alternatively you can add it manually using
the web interface using the address `ipp://<HOSTNAME>/ipp/port1`.

This might not work for you because printers are great.

### Discover Printers on Network

To discover printers on your network, for automatic setup:

1. Install the `avahi` package.
2. Start the `avahi-daemon.service`.
3. Open port `5353 UDP` on your local firewall.
4. Restart the `cups.service`.
5. Scan for printers using the CUPS web interface.

## Background Services (waybar, dunst, swayidle, kanshi, opensnitch-ui)

These run as systemd `--user` services (`computer/home/.config/systemd/user/`) with
`Restart=always` instead of being launched directly via `exec` in the sway config, so they
respawn automatically if they crash.

Since this is a KDE base with sway on top, the services are scoped to a custom
`sway-session.target` (`BindsTo=graphical-session.target`) rather than the generic
`graphical-session.target` directly. Plasma binds its own services (panel, kscreen, polkit
agent, etc.) to `graphical-session.target` too, so enabling these against that target would
also start them under a Plasma session, colliding with Plasma's own panel/screen
lock/display management/notifications. `sway/config` starts the target once on startup with
`exec systemctl --user start sway-session.target`.

Any new per-session daemon should follow the same pattern: `WantedBy=sway-session.target`,
not `graphical-session.target`.

Run `systemd-analyze verify --user <unit file>` after editing any of these unit files.

## Increase Number of Cores Used for Compiling

Edit the `/etc/makepkg.conf` file. Add or edit the `MAKEFLAGS=` variable to `MAKEFLAGS="-j$(nproc)"`.

## Change Hostname

Change your hostname using `sudo hostnamectl hostname <NEW HOSTNAME HERE>`.

## Battery

Use `tlp tlpui` to optimize settings, use `powertop` to see usage and disable services.

Config: `computer/etc/tlp.conf`. Charge thresholds capped at 75-80%, bluetooth disabled on
battery.

## Swap / zram

Uses `zram-generator` (package required) instead of openSUSE's built-in `zramswap.service`,
which hardcodes zram to 100% of RAM. Config: `computer/etc/systemd/zram-generator.conf` (50%
RAM, zstd) and `computer/etc/sysctl.d/98-zram.conf` (swappiness/page-cluster tuning).

On a system still running the old service:

```shell
sudo systemctl disable --now zramswap.service
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
```

## Btrfs Compression

Enable transparent zstd compression on all Btrfs subvolumes by adding `compress=zstd:1` to
each mount's options in `/etc/fstab`:

```
/dev/mapper/cr_root  /            btrfs  defaults,compress=zstd:1              0  0
/dev/mapper/cr_root  /var         btrfs  subvol=/@/var,compress=zstd:1         0  0
/dev/mapper/cr_root  /usr/local   btrfs  subvol=/@/usr/local,compress=zstd:1   0  0
/dev/mapper/cr_root  /srv         btrfs  subvol=/@/srv,compress=zstd:1         0  0
/dev/mapper/cr_root  /root        btrfs  subvol=/@/root,compress=zstd:1        0  0
/dev/mapper/cr_root  /opt         btrfs  subvol=/@/opt,compress=zstd:1         0  0
/dev/mapper/cr_root  /home        btrfs  subvol=/@/home,compress=zstd:1        0  0
/dev/mapper/cr_root  /.snapshots  btrfs  subvol=/@/.snapshots,compress=zstd:1  0  0
```

Apply without rebooting using `sudo mount -o remount <mountpoint>` for each entry, or just
reboot. Verify with `findmnt -t btrfs`.

To recompress files that already existed before compression was enabled:

```shell
sudo btrfs filesystem defragment -r -v -czstd /
```

This is I/O-heavy and temporarily breaks extent-sharing with existing Snapper snapshots
(can spike disk usage until old snapshots are pruned) — run it when you have time and free
space to spare. Check actual compression ratio achieved with `compsize` (package required):

```shell
sudo zypper in compsize
sudo compsize /
```

## MGLRU (Multi-Gen LRU)

Enables a more efficient memory reclaim algorithm, pairs well with the zram setup above.
Persisted via `/etc/tmpfiles.d/mglru.conf`:

```
# Type Path                          Mode UID GID Age Argument
w     /sys/kernel/mm/lru_gen/enabled -    -   -   -   y
```

Apply without rebooting using `sudo systemd-tmpfiles --create /etc/tmpfiles.d/mglru.conf`.
Verify with `cat /sys/kernel/mm/lru_gen/enabled` (should read `0x0007`).

## Packages for Neovim Linting and Formatting

The following packages are required for linting and or formatting some filetypes.

`tree-sitter tree-sitter-cli prettier stylelua python-black shfmt python-flake8 eslint shellcheck`

## Firefox Settings

### Firefox – Keep Bookmark Menu Open After Opening New Tab

1. Open Advanced configuration, using `about:config`.
2. Set `browser.bookmarks.openInTabClosesMenu` to `FALSE`
3. Set `browser.tabs.loadBookmarksInBackground` to `TRUE`

### Firefox – Scroll Through Open Tabs Using Mouse Wheel

1. Open Advanced configuration, using `about:config`.
2. Set `toolkit.tabbox.switchByScrolling` to `TRUE`

## Zen Browser Settings and Sync

1. Open zen browser and go to `about:profiles`, copy profile path.
2. Copy `prefs.js` and `zen-sessions.jsonlz4` to the new system.
3. Open zen browser and go to `about:profiles` on the new system, copy profile path
4. CLOSE ZEN BROWSER and copy `prefs.js` and `zen-sessions.jsonlz4` into the profile on the new
   system. c

## Screenshare

Following packages are required:

```
xdg-desktop-portal xdg-desktop-portal-wlr slurp
```

## Do Hardening

Harden the system.

## Stop and Disable Unneeded Services

1. List all enabled services using `sudo systemctl list-unit-files --type=service --state=enabled`
2. Disable services using `sudo systemctl disable --now SERVICE`

## Issues and Fixes

### Konsole Spacing Between Words

On some setups Konsole renders huge whitespaces between words. This is a font issue. To fix this you have to create a
new profile in the Konsole settings and set the font to a monospace font! Save the profile and set is as the default.

### Scaling on High Resolutions

Add or edit the line `Xft.dpi: 192` to the `home/.Xresources` file. Exit the session and log in again.

### Applications not using kdewallet

Sometimes fixed by installing `kwalletmanager` and `kwallet-pam`. Sometimes just installing `kwalletmanager`, opening
it, unlocking the keyring, and then log into the application.

### Fix Recommendations in Rofi

When adding new AppArmor jails, or opening the wrong application too many times by accident, your
rofi recommendations can be confusing. Edit the file `/home/<user>/.cache/rofi3.druncache`.

Add the name of the relevant `.desktop` file as a new line and prefix it with a high number, e. g.
`100` to make it appear on top.

### No Clipboard in VIM and Neovim

Make sure one of following clipboard providers is
installed [Neovim Docs Provider (neovim.io)](https://neovim.io/doc/user/provider.html#_clipboard-integration):

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

### Set Default Applications for Filetype

1. Use `cat ~/.config/mimeapps.list` to check which applications are currently set.
2. Use `xdg-mime query default <mimetype>` to check specific filetypes.
3. Use `cat /usr/share/mime/types` to check which filetypes exist.
4. Use `xdg-mime default <application.desktop> <mimetype>` to set a new default application for a
   filetype, e. g. `xdg-mime default firefox.desktop application/pdf`. To get the available
   `.desktop` options, use `ls /usr/share/applications | grep -i <application name>`.

### Set Default Application for Group of Filetypes

1. Use `xdg-settings --list` to get list of available groups.
2. Use `xdg-settings get default-web-browser` to get what application is currently set for that
   role.
3. Use `xdg-settings set default-web-browser firefox.desktop` to set an application for a role.

---

## Generate Tree View

Used to generate tree view for `files.txt`.

```shell
git ls-tree -r --name-only HEAD home| tree --fromfile -a | awk '!/directories|^$/ {print $0}'
git ls-tree -r --name-only HEAD home| tree --fromfile -a | awk '!/directories|^$/ {print $0}' > home/files.txt
```

## Hotkeys

Cheat sheet for the hotkeys in my i3 setup.

### i3 and sway

`mod = Super Key / Windows`

| keys / command                                | function                                                 |
| --------------------------------------------- | -------------------------------------------------------- |
| `mod + Enter`                                 | start terminal                                           |
| `mod + d`                                     | execute rofi script                                      |
| `mod + i`                                     | start browser                                            |
|                                               |                                                          |
| `mod + shift + q`                             | kill current selection                                   |
| `mod + j` `mod + left arrow`                  | move focus to left                                       |
| `mod + k` `mod + down arrow`                  | move focus to down                                       |
| `mod + l` `mod + up arrow`                    | move focus to up                                         |
| `mod + ö` `mod + right arrow`                 | move focus to right (disabled)                           |
| `mod + shift + j` `mod + shift + left arrow`  | move focus to left                                       |
| `mod + shift + k` `mod + shift + down arrow`  | move focus to down                                       |
| `mod + shift + l` `mod + shift + up arrow`    | move focus to up                                         |
| `mod + shift + ö` `mod + shift + right arrow` | move focus to right (disabled)                           |
|                                               |                                                          |
| `mod + h`                                     | split horizontal                                         |
| `mod + v`                                     | split vertical                                           |
| `mod + f`                                     | toggle fullscreen                                        |
| `mod + s`                                     | stacking mode                                            |
| `mod + w`                                     | tabbed mode                                              |
| `mod + e`                                     | toggle split orientation                                 |
| `mod + shift + space`                         | toggle floating mode                                     |
| `mod + space`                                 | toggle between floating and window underneath            |
| `mod + a`                                     | focus parent window                                      |
|                                               |                                                          |
| `mod + number`                                | switch to workspace number                               |
| `mod + shift + number`                        | move window to workspace number                          |
| `mod + c`                                     | switch back and forth between current and last workspace |
|                                               |                                                          |
| `mod + shift + c`                             | reload configuration file                                |
| `mod + shift + r`                             | reload i3                                                |
| `mod + shift + e`                             | exit i3                                                  |
|                                               |                                                          |
| `mod + r`                                     | switch to resize mode                                    |
| `j` `left arrow`                              | shrink width                                             |
| `k` `down arrow`                              | grow height                                              |
| `l` `up arrow`                                | shrink height                                            |
| `;` `ö` `right arrow`                         | grow width                                               |
| `escape` `enter` `mod + r`                    | exit resize mode                                         |
|                                               |                                                          |
| `mod + shift + o`                             | move window to left monitor                              |
| `mod + shift + p`                             | move window to right monitor                             |
|                                               |                                                          |
| `mod + shift + control + l`                   | lock screen                                              |
| `mod + shift + control + delete`              | lock screen and suspend                                  |

### dunst - notification daemon

| keys / command         | function                    |
| ---------------------- | --------------------------- |
| `left click`           | close current notification  |
| `right click`          | do an action                |
| `middle click`         | close all notifications     |
| `ctrl + space`         | close current notifications |
| `ctrl + shift + space` | close all notifications     |
| `ctrl + grave`         | show history                |
| `ctrl + shift + .`     | show context menu           |

### Alacritty - terminal emulator

| keys / command          | function        |
| ----------------------- | --------------- |
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

## Archive

Old settings or instructions. Maybe useful to someone.

### Theming

#### Kvantum

1. Install the following packages: `kvantum qt6ct`
2. Start the `kvantum manager` and set a theme.
3. Start `qt6ct`. Set the style to `kvantum` or `kvantum-dark`. Do NOT set a user defined style.
4. Add or change the variable `export QT_QPA_PLATFORMTHEME="qt6ct"` into your `/etc/environment` or your
   `/home/<user>/.<...>profile` file.
5. Log out and back in.
6. Pray it works.
7. Adjust app specific settings. E.g. set the theme in kate, for some reason it doesnt just use the correct theme.

If this didn't work, try the steps listed below this.

#### Lxappearance

1. Install the `lxappearance` and the `breeze-gtk` packages
2. run `lxappearance` and change the theme
3. Save and close
4. Reboot your system
