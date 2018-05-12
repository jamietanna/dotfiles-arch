# Dotfiles

As part of my move to Arch Linux, I'm rebuilding my dotfiles from the ground up so that I can easily rebuild my setup. This repo will host the config until I completely move.

## Requirements

In each package directory (see [Directory Structure](#directory-structure) for clarification), there will be instructions on where the package will be available, and any additional requirements needed.

## How to Use

To simply use my dotfiles for yourself, you need to run `$GITROOT/unpack.sh $package` where `$package` is i.e. `bspwm`, `vim`, etc. Note that this may unpack to both your home directory, and global locations on disk.

To completely set up the same environment that I have, you will need to bootstrap. To do this, simply run `$GITROOT/bootstrap.sh`. This will set up my dotfiles and any packages required to use them. Note that for this method you will need the AUR helper `yay`, or will need to edit the `bootstrap.sh` script to use your own helper.

## Directory Structure

I've decided to organise my dotfiles in the following method:

```
$HOME
|--dotfiles
|  |--$pkgname
|  |  |--home
|  |  |  |--.config
|  |  |  |  |-- ...
|  |  |--global
|  |  |  |--...
|  |  |  |--usr
|  |  |  |  |--local
|  |  |  |  |  |--bin
|  |  |  |  |  |  |--$pkgname
|  |  |  |--...
```

As you can see, there is a `home` and a `global` directory - `home` deploys config into `$HOME`, and `global` deploys into `/`. This allows easily pushing config into both user- and system-level adoption.

`$pkgname` denotes config for an application - for instance, `zsh` or `vim`.

To see which dependencies are required by each set of configs, please see the `dependencies` file which details packages from the official repos, as well as the AUR.

Additionally, there may be further steps, for instance `$GITROOT/$package/bootstrap.sh`, which is run when bootstrapping; this will provide a one-time setup that configures the environment.
