#!/usr/bin/env just --justfile

alias d := debug
alias r := run

debug:
  watchfiles 'zig run src/main.zig -O Debug' 'src/'

run:
  watchfiles 'zig run src/main.zig -O ReleaseSafe' 'src/'
