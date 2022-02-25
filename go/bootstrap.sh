#!/usr/bin/env bash
cwd="$(dirname "${BASH_SOURCE[0]}")"

(
cd "$cwd/home/go/src/jvt.me/dotfiles/url" || exit 1
go install
)
