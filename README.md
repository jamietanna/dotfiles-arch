# Dotfiles

As part of my move to Arch Linux, I'm rebuilding my dotfiles from the ground up so that I can easily rebuild my setup. This repo will host the config until I completely move.

## Requirements

In each package directory (see [Directory Structure](#directory-structure) for clarification), there will be instructions on where the package will be available, and any additional requirements needed.

In order to run `unpack.sh`, you will need to have installed GNU `stow`.

## How to Use

To use this repo, you simply need to run `/path/to/repo/unpack.sh $packages`, where `$packages` is a space separated list i.e. `unpack.sh bspwm sxhkd`. Note that this will unpack configs to the home and root directories.

## Directory Structure ##

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
