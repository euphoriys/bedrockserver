#!/bin/bash

# Step 1: Update packages and install necessary tools
yes | pkg up
pkg ins proot-distro

# Step 2: Install Ubuntu distro in proot and set up the environment
pd i ubuntu
pd sh ubuntu -c << 'EOF'
  # Step 1: Update and upgrade Ubuntu
  apt update && apt upgrade -y && apt install curl nano unzip

  # Step 2: Create a directory for the server
  mkdir bedrockserver
  cd bedrockserver

  # Function to fetch the latest release or preview version
  fetch_version() {
    local pattern=$1
    curl -s https://minecraft.wiki/w/Bedrock_Dedicated_Server | grep -oP "(?<=$pattern)[^\"]+" || { echo "Error: Unable to fetch version."; exit 1; }
  }

  # Step 3: Ask the user for the desired Minecraft Bedrock server version or to use the latest release/preview
  read -p "Do you want to use the latest release, preview, or enter a version manually? (default: release) " choice

  # Determine the version based on the user's choice
  case "$choice" in
    preview)
      version=$(fetch_version "Preview:</b> <a href=\"/w/Bedrock_Edition_Preview_")
      url="https://www.minecraft.net/bedrockdedicatedserver/bin-linux-preview/bedrock-server-$version.zip"
      ;;
    manual)
      read -p "Enter the Minecraft Bedrock server version: " version
      url="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$version.zip"
      ;;
    *)
      if [[ "$choice" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        version=$choice
        url="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$version.zip"
      else
        version=$(fetch_version "Release:</b> <a href=\"/w/Bedrock_Edition_")
        url="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$version.zip"
      fi
      ;;
  esac

  # Step 4: Echo the download URL and version
  echo "Downloading version: $version"

  # Step 5: Download the corresponding version of the Bedrock server
  curl -A "Mozilla/5.0 (Linux)" -o bedrock-server.zip $url || { echo "Error: Unable to download the specified version."; exit 1; }

  # Check if the downloaded file is a valid zip file
  if ! unzip -tq bedrock-server.zip > /dev/null 2>&1; then
    echo "Error: The specified version does not exist or the downloaded file is not a valid zip file."
    rm bedrock-server.zip
    exit 1
  fi

  echo "Download and validation successful."

  # Step 6: Unzip the downloaded file and remove the zip file
  unzip bedrock-server.zip && rm bedrock-server.zip

  # Step 7: Install Box64 for ARM compatibility
  # check if .list file already exists
  if [ -f /etc/apt/sources.list.d/box64.list ]; then
    sudo rm -f /etc/apt/sources.list.d/box64.list || exit 1
  fi
  # check if .sources file already exists
  if [ -f /etc/apt/sources.list.d/box64.sources ]; then
    sudo rm -f /etc/apt/sources.list.d/box64.sources || exit 1
  fi
  # download gpg key from specified url
  if [ -f /usr/share/keyrings/box64-archive-keyring.gpg ]; then
    sudo rm -f /usr/share/keyrings/box64-archive-keyring.gpg
  fi
  sudo mkdir -p /usr/share/keyrings
  wget -qO- "https://pi-apps-coders.github.io/box64-debs/KEY.gpg" | sudo gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg
  # create .sources file
  echo "Types: deb
  URIs: https://Pi-Apps-Coders.github.io/box64-debs/debian
  Suites: ./
  Signed-By: /usr/share/keyrings/box64-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/box64.sources >/dev/null
  # Automatically accept prompts
  yes | sudo apt update
  yes | sudo apt install box64-generic-arm -y
EOF
