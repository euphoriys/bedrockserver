#!/bin/bash

echo "Setting up Bedrock server environment..."

# Step 1: Update packages and install necessary tools
yes | pkg up > /dev/null 2>&1
pkg ins proot-distro -y > /dev/null 2>&1

# Step 2: Install Ubuntu distro in proot and set up the environment
pd i ubuntu > /dev/null 2>&1
pd sh ubuntu -- << 'OUTER_EOF' 2>/dev/null
  # Step 1: Update and upgrade Ubuntu
  apt update > /dev/null 2>&1 && apt upgrade -y > /dev/null 2>&1 && apt install curl nano -y > /dev/null 2>&1

  # Step 2: Install Box64 for ARM compatibility
  curl -L -o box64-android_arm64.deb https://github.com/Pi-Apps-Coders/box64-debs/raw/master/debian/box64-android_0.3.3%2B20241219T063104.600ae18-1_arm64.deb > /dev/null 2>&1
  dpkg -i box64-android_arm64.deb > /dev/null 2>&1
  rm box64-android_arm64.deb > /dev/null 2>&1

  # Step 3: Prepare the version downloader
  touch select_minecraft_version.sh && chmod +x select_minecraft_version.sh > /dev/null 2>&1
  cat << 'INNER_EOF' > select_minecraft_version.sh
  # Function to fetch the latest release or preview version
  fetch_version() {
    local pattern=$1
    curl -s https://minecraft.wiki/w/Bedrock_Dedicated_Server | grep -oP "(?<=$pattern)[^\"]+" || { echo "Error: Unable to fetch version."; exit 1; }
  }

  # Ask the user for the desired Minecraft Bedrock server version or to use the latest release/preview
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

  # Create a directory for the server
  mkdir bedrockserver > /dev/null 2>&1
  cd bedrockserver

  # Echo the download version
  echo "Downloading version: $version"

  # Download the corresponding version of the Bedrock server
  curl -A "Mozilla/5.0 (Linux)" -o bedrock-server.zip $url > /dev/null 2>&1 || { echo "Error: Unable to download the specified version."; exit 1; }

  # Check if the downloaded file is a valid zip file
  if ! unzip -tq bedrock-server.zip > /dev/null 2>&1; then
    echo "Error: The specified version does not exist or the downloaded file is not a valid zip file."
    rm bedrock-server.zip
    exit 1
  fi

  echo "Download and validation successful."

  # Unzip the downloaded file and remove the zip file
  echo "Unzipping the downloaded file..."
  unzip bedrock-server.zip > /dev/null 2>&1 && rm bedrock-server.zip

  echo "Unzipping completed."
  
INNER_EOF
OUTER_EOF

echo "Environment setup completed. Run 'pd sh ubuntu' to enter the Ubuntu environment."
echo "You can install the Bedrock server by running './select_minecraft_version.sh'."
