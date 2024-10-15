# Provisioning A New Arch Desktop

## Creating Custom Installation Media
```
make iso
make usb
```
uses [archiso](https://wiki.archlinux.org/title/Archiso)

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
* libinput.conf for touchpad natural scrolling and tap to click
