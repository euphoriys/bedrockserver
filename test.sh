#!/bin/bash

# Step 1: Update packages and install necessary tools
yes | pkg up
pkg ins proot-distro -y

# Step 2: Install Ubuntu distro in proot and set up the environment
proot-distro install ubuntu
proot-distro login ubuntu -- bash -c "
  apt update && apt upgrade -y && apt install curl nano unzip -y
  mkdir -p ~/bedrockserver && cd ~/bedrockserver

  fetch_version() {
    local pattern=\$1
    curl -s https://minecraft.wiki/w/Bedrock_Dedicated_Server | grep -oP \"(?<=\$pattern)[^\"]+\" || { echo \"Error: Unable to fetch version.\"; exit 1; }
  }

  read -p \"Do you want to use the latest release, preview, or enter a version manually? (default: release) \" choice

  case \"\$choice\" in
    preview)
      version=\$(fetch_version \"Preview:</b> <a href=\\\"/w/Bedrock_Edition_Preview_\\\")
      url=\"https://www.minecraft.net/bedrockdedicatedserver/bin-linux-preview/bedrock-server-\$version.zip\"
      ;;
    manual)
      read -p \"Enter the Minecraft Bedrock server version: \" version
      url=\"https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-\$version.zip\"
      ;;
    *)
      if [[ \"\$choice\" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        version=\$choice
        url=\"https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-\$version.zip\"
      else
        version=\$(fetch_version \"Release:</b> <a href=\\\"/w/Bedrock_Edition_\\\")
        url=\"https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-\$version.zip\"
      fi
      ;;
  esac

  echo \"Downloading version: \$version\"
  curl -A \"Mozilla/5.0 (Linux)\" -o bedrock-server.zip \$url || { echo \"Error: Unable to download the specified version.\"; exit 1; }

  if ! unzip -tq bedrock-server.zip > /dev/null 2>&1; then
    echo \"Error: The specified version does not exist or the downloaded file is not a valid zip file.\"
    rm bedrock-server.zip
    exit 1
  fi

  echo \"Download and validation successful.\"
  unzip bedrock-server.zip && rm bedrock-server.zip

  if [ -f /etc/apt/sources.list.d/box64.list ]; then
    sudo rm -f /etc/apt/sources.list.d/box64.list || exit 1
  fi
  if [ -f /etc/apt/sources.list.d/box64.sources ]; then
    sudo rm -f /etc/apt/sources.list.d/box64.sources || exit 1
  fi
  if [ -f /usr/share/keyrings/box64-archive-keyring.gpg ]; then
    sudo rm -f /usr/share/keyrings/box64-archive-keyring.gpg
  fi
  sudo mkdir -p /usr/share/keyrings
  wget -qO- \"https://pi-apps-coders.github.io/box64-debs/KEY.gpg\" | sudo gpg --dearmor -o /usr/share/keyrings/box64-archive-keyring.gpg
  echo \"Types: deb
  URIs: https://Pi-Apps-Coders.github.io/box64-debs/debian
  Suites: ./
  Signed-By: /usr/share/keyrings/box64-archive-keyring.gpg\" | sudo tee /etc/apt/sources.list.d/box64.sources >/dev/null
  yes | sudo apt update
  yes | sudo apt install box64-generic-arm -y
"
