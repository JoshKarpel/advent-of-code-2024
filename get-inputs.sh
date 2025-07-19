#!/usr/bin/env bash

set -euo pipefail

mkdir -p "src/inputs"

for day in {1..25}; do
  padded_day=$(printf "%02d" "$day")
  path="src/inputs/day_${padded_day}.txt"
  if [ ! -f "${path}" ]; then
    echo "Fetching input for day ${day}..."
    curl --silent --show-error --cookie "session=${AOC_SESSION}" "https://adventofcode.com/2024/day/${day}/input" -o "${path}"
  else
    echo "Input for day ${day} already exists."
  fi
done

ls -l src/inputs
