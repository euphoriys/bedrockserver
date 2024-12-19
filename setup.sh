#!/bin/bash

# Step 1: Update packages and install necessary tools
yes | pkg up
pkg ins proot-distro -y

# Step 2: Install Ubuntu distro in proot and set up the environment
pd i ubuntu
pd sh ubuntu -- << 'EOF'
  # Step 1: Update and upgrade Ubuntu
  apt update && apt upgrade -y && apt install curl nano unzip gpg -y

  # Step 2: Create a directory for the server
  mkdir bedrockserver
  cd bedrockserver

  # Function to fetch the latest release or preview version
  fetch_version() {
    local pattern=$1
    curl -s https://minecraft.wiki/w/Bedrock_Dedicated_Server | grep -oP "(?<=$pattern)[^\"]+" || { echo "Error: Unable to fetch version."; exit 1; }
  }

  # Step 3: Ask the user for the desired Minecraft Bedrock server version or to use the latest release/preview
  read -p "Do you want to use the latest release, preview, or enter a version manually? [release] " choice

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
  curl -L -o box64-android_arm64.deb https://github.com/Pi-Apps-Coders/box64-debs/raw/master/debian/box64-android_0.3.3%2B20241219T063104.600ae18-1_arm64.deb
  dpkg -i box64-android_arm64.deb
EOF
