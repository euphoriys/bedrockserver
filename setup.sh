#!/bin/bash

echo "Setting up Bedrock server environment..."

# Step 1: Update packages and install necessary tools
yes | pkg up
pkg ins proot-distro -y

# Step 2: Install Ubuntu distro in proot and set up the environment
pd i ubuntu
pd sh ubuntu -- << 'OUTER_EOF'
    apt update && apt upgrade -y && apt install curl nano gpg -y
    
    case "$(uname -m)" in
        aarch64)
            echo "Installing Box64 for ARM64 architecture..."
            curl -s -O https://raw.githubusercontent.com/euphoriys/bedrux/main/src/box64.sh
            bash box64.sh
            ;;
        x86_64|amd64)
            echo "Skipping Box64 installation. CPU architecture is x86_64 or amd64."
            ;;
        *)
            echo "Unsupported CPU architecture: $(uname -m). Exiting."
            exit 1
            ;;
    esac

    # Step 3: Prepare the server version downloader
    curl -s -O https://raw.githubusercontent.com/euphoriys/bedrux/main/src/minecraft_version.sh
    chmod +x minecraft_version.sh
OUTER_EOF

echo "Environment setup completed. Run 'pd sh ubuntu' to enter the Ubuntu environment."
echo "You can install the Bedrock server by running './minecraft_version.sh'."
