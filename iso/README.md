for creating custom installation media

https://wiki.archlinux.org/title/Archiso

cp -r /usr/share/archiso/configs/releng/ archlive
mkarchiso -v -w /tmp/archiso-tmp /path/to/profile/

# usage
to make installation media (expects usb drive)
```
make iso
make usb
```
to install:
1. boot the computer using the install media
2. connect to the network using `iwctl`
    * `station list` -> station name
	* `station <station> get-networks` -> network name
	* `station <station> connect <network>`
    * `quit`
3. run `install.sh`. set the following options:
    * host name
    * disk layout
    * at least one user
    * by default this will use the `Desktop` profile. This can be reset to avoid installing any GUI. Probably also want to reset the audio framework in that case.

# TODO
* should use builtin brightness ctrl
* include default background image

