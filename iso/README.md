# ISO

This project helps install arch with my setup in a quick and repeatable way.


## Creating Custom Installation Media
```
# run in this directory
make iso
make usb
```

## Provisioning
1. boot the computer using the install media
2. connect to the network using `iwctl`
    * `station list` -> station name
	* `station <station> get-networks` -> network name
	* `station <station> connect <network>`
    * `quit`

3. run command `bootstrap`. set the following options:
    * host name
    * disk layout
    * at least one user

4. `reboot`

# TODO
* can we set firefox to dark mode and install ublock origin from the command line?

# reference
* [archiso](https://wiki.archlinux.org/title/Archiso)
* [archinstall](https://wiki.archlinux.org/title/Archinstall)
    * [profiles](https://gitlab.archlinux.org/archlinux/archinstall/-/tree/master/archinstall/default_profiles/desktops)
