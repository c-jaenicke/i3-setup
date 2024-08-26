# home/.local/share/applications

The `.desktop` files in this directory add a new entry to your launcher. This entry will run the
programm using firejail.

To fully replace/overwrite the original `.desktop` files, remove the `-jailed` suffix from each `.desktop`
file in this folder.

## Important Note

The programms will only run using firejail when started using a launcher! Running them from the
terminal will not use firejail!
