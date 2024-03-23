# i3 Setup

i3 setup on arch linux.

## Fixing Application Themes

### Using qt6ct

1. install `qt6ct` from official repos
1. install `breeze` from official repos
1. set theme AND FONTS in qt6ct
1. set / add `QT_QPA_PLATFORMTHEME=qt6ct` to `/etc/environment`
1. restart

### Using lxappearance

1. install `lxappearance` from official repos
1. install `breeze-gtk` from official repos
1. start lxappearance and change the theme
1. restart

## Fonts

- `ttf-ibm-plex`
- `ttf-hack-nerd`

## Polybar

### checkupdates module

need to have `pacman-contrib` installed to get list of packages that need to be updated.

### network module

need to declare interface in config

interface can be found by running `ip link`

### webcam module

Viewing live feed in VLC requires the `zvbi` package to be installed.

## Quick Links to Things Used

- <https://github.com/davatorium/rofi>
- <https://github.com/yshui/picom>
- <https://github.com/dunst-project/dunst>
- <https://github.com/polybar/polybar>
- <https://github.com/i3/i3>
- <https://github.com/tmux/tmux>
- <https://github.com/alacritty/alacritty>

