Prime Minister (pm) provides a uniform package management interface in pure bash.

# Quick Start

### installation

```
curl <url> /usr/bin/pm && chmod +x /usr/bin/pm
```

### basic usage

```
pm sync # update the database

pm query firefox # see which managers provide firefox

pm add firefox # install firefox

pm list firefox # list the installed packages containing firefox

pm rm firefox # uninstall firefox
```

# Currently Supported Package Managers

* apk
* apt
* pacman
* pip
* yaourt

# Design / Purpose

PM doesn't keep track of packages itself, but instead manages all state through existing managers on the system. The intent is not to handle every use case, but to simplify the normal flow. This is not intended to be scripted but used by a person.

It does this by abstracting six functions that most managers provide, and making a few assumptions about usage.

Most managers can:
* add a package
* update installed packages
* remove a package
* query available packages
* list installed packages
* syncronize with some remote state

# FAQ

### want support for additional managers?

submit an issue OR make a pull request! 

New additions must
* implement all six actions (if the underlying manager supports them).
* provide a single function named `_$manager` where $manager is the name of your addition. that accepts the arguments`_$manager <action> [<opt>]`

The six actions are
* add
    - add a given package
* rm
    - remove a given package
* list
    - return a list of installed packages
    - must return non-zero if not found
* query
    - return a list of available packages
    - must return non-zero if not found
* update
    - update only the packages listed if arguments are given
    - update all packages if no arguments are given
* sync
    - syncronize any database the manager keeps

### do you love this project?

leave a star!

### are you having a problem?

submit an issue
