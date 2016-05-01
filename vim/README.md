# Vim

Note that I've started using the `gvim` package, instead of `vim`, as it provides system clipboard integration.

As I spent a lot of my time in the terminal, and as I like having a minimally-bloated system, I recently moved from Emacs to Vim as my main text editor. As I am still quite new to Vim, my configs have a long way to go.

## Plugins

My Vim configs require the following plugins:

- [Vim Plug](https://github.com/junegunn/vim-plug)
- [CommandT](https://github.com/wincent/command-t)
- [YouCompleteMe](https://github.com/valloric/youcompleteme)
- [Eclim](https://aur.archlinux.org/packages/eclim/)

## Installing

To install, open up the Vim setup, and run `:PlugInstall`. This will then download and build CommandT and YouCompleteMe - note YCM will max out CPU resources when building. You will then need to install the `eclipse` package, and `aur:eclim`.
