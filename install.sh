#!/usr/bin/env bash
set -euo pipefail

if [[ ! -r /etc/arch-release ]]; then
  echo "Этот установщик рассчитан на Arch Linux." >&2
  exit 1
fi

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$HOME/.config"
backup_dir="$HOME/.config/arch-amber-crt-backups/$(date +%Y%m%d-%H%M%S)"

sudo pacman -S --needed hyprland waybar wofi swaybg cool-retro-term python ttf-dejavu

mkdir -p "$config_dir/hypr"

move_existing_to_backup() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_dir"
    mv -- "$target" "$backup_dir/"
    echo "Saved existing config: $target -> $backup_dir/"
  fi
}

link_config() {
  local source="$1" target="$2"
  if [[ "$source" == "$target" ]]; then
    return
  fi
  move_existing_to_backup "$target"
  ln -s "$source" "$target"
}

link_config "$repo_dir" "$config_dir/arch-amber-crt"
link_config "$repo_dir/waybar" "$config_dir/waybar"
link_config "$repo_dir/wofi" "$config_dir/wofi"
link_config "$repo_dir/hypr/appearance.conf" "$config_dir/hypr/arch-amber-crt.conf"

hypr_conf="$config_dir/hypr/hyprland.conf"
if [[ ! -e "$hypr_conf" ]]; then
  printf 'source = ~/.config/hypr/arch-amber-crt.conf\n' > "$hypr_conf"
elif ! grep -Fq 'source = ~/.config/hypr/arch-amber-crt.conf' "$hypr_conf"; then
  cp -a "$hypr_conf" "$hypr_conf.bak.$(date +%Y%m%d-%H%M%S)"
  printf '\n# Arch Amber CRT appearance\nsource = ~/.config/hypr/arch-amber-crt.conf\n' >> "$hypr_conf"
fi

bashrc="$HOME/.bashrc"
prompt_line='source "$HOME/.config/arch-amber-crt/bash/prompt.sh"'
if [[ -f "$bashrc" ]] && ! grep -Fq 'arch-amber-crt/bash/prompt.sh' "$bashrc"; then
  cp -a "$bashrc" "$bashrc.bak.$(date +%Y%m%d-%H%M%S)"
  printf '\n# Arch Amber CRT prompt\n%s\n' "$prompt_line" >> "$bashrc"
fi

echo
echo "Установка готова. Перезайди в Hyprland."
echo "При следующем входе откроется полноэкранная Bitcoin-заставка."
if [[ -d "$backup_dir" ]]; then
  echo "Резервные копии конфигов: $backup_dir"
fi