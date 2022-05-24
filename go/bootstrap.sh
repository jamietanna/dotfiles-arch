#!/usr/bin/env bash
cwd="$(dirname "${BASH_SOURCE[0]}")"

for dir in "$cwd"/home/go/src/jvt.me/dotfiles/*; do
  (
    cd "$dir" || exit 1
    go install
  )
done
