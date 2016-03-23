#!/usr/bin/env bash
sudo pacman -S clang cmake --needed
./install.sh --clang-completer --system-libclang
