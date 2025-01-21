#!/bin/bash

# Configuration
REPO_URL="https://github.com/kernelb00t/nixos-atelier"
LOCAL_REPO="/etc/nixos"
BRANCH="main"

# Ensure the local repo directory exists
if [ ! -d "$LOCAL_REPO/.git" ]; then
  echo "No config repo found in $LOCAL_REPO. Cloning configuration repository..."
  
  rm -rf "$LOCAL_REPO/*"
  git clone "$REPO_URL" "$LOCAL_REPO" --branch "$BRANCH" --depth 1 .

  if [ $? -ne 0 ]; then
    echo "Error: Failed to clone repository from $REPO_URL"
    exit 1
  fi

else
  echo "Fetching latest changes from remote repository..."
  cd "$LOCAL_REPO" || exit
  git fetch origin "$BRANCH"
  
  LOCAL_HASH=$(git rev-parse HEAD)
  REMOTE_HASH=$(git rev-parse origin/"$BRANCH")

  if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
    echo "Configuration has changed. Updating..."
    git reset --hard origin/"$BRANCH"
  else
    echo "Configuration is up-to-date. No action needed."
    exit 0
  fi
fi

# Rebuild the NixOS system
echo "Rebuilding the system..."
nixos-rebuild switch

if [ $? -ne 0 ]; then
  echo "Error: Failed to rebuild NixOS system."
  exit 1
fi

# Check if a reboot is required
if [ -f /var/run/reboot-required ]; then
  echo "A reboot is required. Rebooting now..."
  reboot
fi

echo "System updated and rebuilt successfully."
exit 0
