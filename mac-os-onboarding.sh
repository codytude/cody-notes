#!/usr/bin/env bash
set -euo pipefail

# macOS developer bootstrap — see README.md. Interactive; safe to re-run.

# JumpCloud: enroll via User Portal -> Security -> Device Enrollment.
[[ -d /opt/jc ]] || open "https://console.jumpcloud.com/userconsole" || true

# Xcode Command Line Tools (fails harmlessly if already installed).
xcode-select --install 2>/dev/null || true

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH now and in new shells (Apple Silicon or Intel).
BREW=/opt/homebrew/bin/brew
[[ -x "${BREW}" ]] || BREW=/usr/local/bin/brew
SHELLENV="eval \"\$(${BREW} shellenv)\""
grep -qxF "${SHELLENV}" ~/.zprofile 2>/dev/null || echo "${SHELLENV}" >> ~/.zprofile
eval "$("${BREW}" shellenv)"

# CLI tools and apps, skipping any already installed.
FORMULAE=(
  git gh jq yq awscli
  k9s helm
  hashicorp/tap/terraform hashicorp/tap/vault
  ansible
  pyenv pipx
)
CASKS=(
  visual-studio-code firefox github docker iterm2
  slack 1password 1password-cli logi-options+
)

for formula in "${FORMULAE[@]}"; do
  brew list --formula "${formula}" >/dev/null 2>&1 || brew install "${formula}"
done

for cask in "${CASKS[@]}"; do
  brew list --cask "${cask}" >/dev/null 2>&1 || brew install --cask "${cask}"
done
