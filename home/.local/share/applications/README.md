# home/.local/share/applications

The `.desktop` files in this directory add a new entry to your launcher. This entry will run the
programm using firejail.

To fully replace/overwrite the original `.desktop` files, remove the `-jailed` suffix from each `.desktop`
file in this folder.

## Important Notes

The programms will only run using firejail when started using a launcher! Running them from the
terminal will not use firejail!

### Using KeePassXC Jail

Using the KeePassXC jail will limit the storage of your `.kdbx` files to the following folders:
```
${HOME}/*.kdb
${HOME}/*.kdbx
${HOME}/.config/KeePass
${HOME}/.config/keepass
${HOME}/.keepass
${HOME}/.local/share/KeePass
${HOME}/.local/share/keepass
${DOCUMENTS}
```

To add or change the valid paths, you will have to update the firejail profile for keepass, see
`/etc/firejail/keepass.profile`.

