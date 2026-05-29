#!/usr/bin/env bash

# needs rsvg and webp

set -e

declare -A light=(
  [blue]="#0461be"
  [teal]="#007184"
  [green]="#15772e"
  [yellow]="#905300"
  [orange]="#b62200"
  [red]="#c00023"
  [pink]="#a2326c"
  [purple]="#8939a4"
  [slate]="#526678"
  [brown]="#7c5c36"
)

# Dark theme colors
declare -A dark=(
  [blue]="#3584e4"
  [teal]="#2190a4"
  [green]="#3a944a"
  [yellow]="#c88800"
  [orange]="#ed5b00"
  [red]="#e62d42"
  [pink]="#d56199"
  [purple]="#9141ac"
  [slate]="#6f8396"
  [brown]="#b39169"
)

themes=("light" "dark")
rm -rf "$(dirname "${BASH_SOURCE[0]}")"/dither-*.webp
for theme in "${themes[@]}"; do
  declare -n colors="$theme"
  for color_name in "${!colors[@]}"; do
    COLOR="${colors[$color_name]}"
    OUTPUT="${theme:0:1}-${color_name[0]}.webp"
    sed "s/fill:#000\\b/fill:${COLOR}/g" "$(dirname "${BASH_SOURCE[0]}")/_dither.svg" | rsvg-convert | cwebp -quiet -z 9 -mt -o "$(dirname "${BASH_SOURCE[0]}")/$OUTPUT" -- - &
  done
done
