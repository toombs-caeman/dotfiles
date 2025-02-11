# dotnu

Portable dotfiles based on nushell

arch + swaywm + wezterm + nushell + neovim

# Installation
## Just Dotfiles
0. install git and nushell
    * windows: `winget install Git.Git Nushell.Nushell`
    * ubuntu: `sudo apt install git nushell`
    * mac: `brew install git nushell`
    * arch: `sudo pacman -S git nushell`
1. clone repository and run stash hook
```shell
# clone repository
git clone git@github.com:toombs-caeman/dotfiles.git
cd dotfiles
bin/stash using stash.yml
```

## Operating System
In addition to containing my dotfiles, this repository also specifies a custom arch ISO that I use to bootstrap all my personal computers.
```
# cd iso/
make iso    # create an ISO
make usb    # attempt to write that ISO to a removable drive
```

# Project Philosophy
This isn't a well thought out manifesto or anything, but good tools do share certain qualities across vastly differnt domains.
I suppose I'll discuss what I think those are here as an aspirational rant.

* keep tools as simple as possible, but no simpler
    * if you have to look up how something works every time you use it, it's too complicated.
    * if you have to compose a complicated pipeline to do anything useful, the tools are too simple.
    * it should be blindingly obvious which part is the handle, and where the pointy bits are.
* eliminate redundancy
    * redundanct tools are a complication that by definition don't offer extra functionality.
    * I'm clearly not talking about things like redundant backups, where multiplicity is itself a feature.
    * desktop environments (WMs), terminals, browsers, tmux, and nvim all have their own way of handling panes and tabs. Eliminate or disable as many of these as possible.
    * nvim and my WM both have a status line.
    * From the [Zen of Python](https://en.wikipedia.org/wiki/Zen_of_Python#Principles), there should be one and ideally only one obvious way to do something.
* eliminate inconsistencies
    * tools that rely on the network will fail when the network is down.
    * tools that depend on specific versions of awk... or gawk... maybe it was mawk. Anyway you can never depend on having that exact version around. Bash is subtly different on linux and mac systems.
    * prefer dumb, consistent tools.
    * good tools are not novel, they behave exactly as expected every time.
* Tools should be composable and work together
    * This basically comes from [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), though I've soured on the idea of text streams being the best interface. It's a little too simple for a lot of things.
    * this is related to eliminating redundancy.
* Provide rich context
    * Indicate abnormal status but not the expected or default status
    * Rich means more concentrated, not just **more**. The ideal is that tools should deliver exactly what the user needs to know, right as they need to know it, and to otherwise stay quiet.
    * eliminate visual clutter. Clutter is by definition not important; it dilutes the signal.
    * cli context includes
        * what happened (history), what could happen (autocomplete) and what's happening (progress bars, etc)
        * who, what, where, when, why (user, command, directory+branch, timestamp, comments)
* The less I know the better
    * Fuzzy searching lets you stumble into the correct answer, even if you don't know exactly what you're looking for.
    * if I make a clear mistake, suggest a correction rather than just failing.
    * when it 'just works', you never have to think about how it works (or why it isn't working).
    * tools should protect you from doing something dumb (at least by accident).


# publicity
* nustach
    * [awesome-nu](https://github.com/nushell/awesome-nu)
    * [{{moustache}}](https://mustache.github.io/)
    * add [tests badge](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/monitoring-workflows/adding-a-workflow-status-badge)
    * run tests against the spec with [nutest](https://github.com/vyadh/nutest)

* dotfiles
    * [dotfiles](https://dotfiles.github.io/)
    * [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
    * [arch dotfiles](https://wiki.archlinux.org/title/Dotfiles)

* imbue
    * [awesome-nu](https://github.com/nushell/awesome-nu)
    * [nupm](https://github.com/nushell/nupm)
