#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
AMBER=$'\033[38;5;214m'
DIM=$'\033[38;5;130m'
RESET=$'\033[0m'

clear
printf '%s' "$AMBER"
cat <<'BITCOIN'

       █████████
     ██         ██
    █     ₿      █
    █            █
     ██         ██
       █████████

   B I T C O I N   //   CRT ONLINE
BITCOIN
printf '%s\n' "$DIM"
python3 "$SCRIPT_DIR/btc-price.py" || true
printf '%s\n' "$RESET"
printf '\n%s' "$AMBER"
read -r -n 1 -s -p 'Нажми любую клавишу, чтобы открыть shell…'
printf '\n%s' "$RESET"
exec bash -l
