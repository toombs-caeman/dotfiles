# imbue

an all-in-one declarative system configuration tool

# installation
require `mustach nushell`


# subcommands
## imbue
run configuration

## imbue with
set default config file

## imbue watch
watch templates for changes and run on change

## imbue iso
create an installation image that adds imbue to it
## imbue usb
write image to usb

# configuration sections
```yaml
condition-kind:
    condition-value:
        - commands:
```

# declarative bootstrap
Declaratively configure the system by providing idempotent helper functions that can be run either in bootstrap env or to reconfigure the existing system. [decman](https://github.com/kiviktnm/decman)
It should be possible to "dry run", and print the plan. Shouldn't ask for sudo unless it is required.
Callback functions that only run when something changed.

# conditions
* always
* never
* which - command is on path (value is command name)
* once - only when bootstrapping (value is ignored)

# commands
* `git` - clone git repo
* `pkg` - `pacman -S --needed` or `pacstrap -K /mnt` depending on env
* `aur` - same as `pkg` but with `yay`
* `sys` - enable and start services (either normally or in `arch-chroot`) (systemctl is idempotent)
* `root` - run command as root (either `sudo`, or `arch-chroot`), depend on command being itself idempotent
* `user` - run command as root (`su $user`, or `arch-chroot -u $user`), depend on command being itself idempotent
* `file` - assert that file contents are equal
* `link` - `ln -sf ...`
* `chmod` - assert file permissions
* `mkdir` - nushell mkdir is idempotent
* `infile` - assert that lines are in file. `-id <x>` to use only part of a line to identify if the line is in the file.
* `build <cmd> <repo>` - manually build a repo iff the command it provides is not available
* `strap` - runs only in bootstrap env

For example: `infile /etc/locale.conf ["en_US.UTF-8 UTF-8"] {|| root locale-gen}`
* if in bootstrap env
    * asserts that the line "en_US.UTF-8 UTF-8" is in `/mnt/etc/locale.conf` (`/etc/locale.conf` in the install env)
    * if the line **wasn't** there, append it then run `arch-chroot /mnt locale-gen`
* if in normal env
    * asserts that the line "en_US.UTF-8 UTF-8" is in `/etc/locale.conf`
    * if the line **wasn't** there, append it then run `sudo locale-gen`

