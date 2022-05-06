#!/usr/bin/env bash
cwd="$(dirname "${BASH_SOURCE[0]}")"

for dir in home/go/src/jvt.me/dotfiles/*; do
  (
    cd "$cwd/$dir" || exit 1
    go install
  )
done
