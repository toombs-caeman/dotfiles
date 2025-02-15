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
* quiet splash - IIRC you should add your kernel parameters to the APPEND in archiso_sys.cfg (and archiso_pxe.cfg if you use PXE).
* bootsplash with [plymouth](https://wiki.archlinux.org/title/Plymouth)
    * `quiet splash` https://wiki.archlinux.org/title/Kernel_parameters#systemd-boot
    * `sudo plymouth-set-default-theme -R solar`
* currently using ly as greeter, but something more thematic maybe? seamless transition between splash and greeter
* [plymouth themes](https://github.com/adi1090x/plymouth-themes)
    * black hud theme
* detect manually installed packages and update archinstall.json?

# reference
* [archiso](https://wiki.archlinux.org/title/Archiso)
* [archinstall](https://wiki.archlinux.org/title/Archinstall)
    * [profiles](https://gitlab.archlinux.org/archlinux/archinstall/-/tree/master/archinstall/default_profiles/desktops)
