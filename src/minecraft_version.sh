#!/bin/bash

# Function to fetch the latest release or preview version
fetch_version() {
    local pattern=$1
    curl -s https://minecraft.wiki/w/Bedrock_Dedicated_Server | grep -oP "(?<=$pattern)[^\"]+" || { echo "Error: Unable to fetch version."; exit 1; }
}

# Function to determine the download URL based on the user's choice
determine_url() {
    local choice=$1
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
}

# Function to download and validate the Bedrock server
download_and_validate() {
    echo "Downloading version: $version"
    curl -s -A "Mozilla/5.0 (Linux)" -o bedrock-server.zip $url || { echo "Error: Unable to download the specified version."; exit 1; }

    if ! unzip -tq bedrock-server.zip > /dev/null 2>&1; then
        echo "Error: The specified version does not exist or the downloaded file is not a valid zip file."
        rm bedrock-server.zip
        exit 1
    fi

    echo "Download and validation successful."
}

# Function to create start script
create_start_script() {
    if command -v box64 > /dev/null 2>&1; then
        echo "#!/bin/bash
export BOX64_LOG=0
box64 bedrock_server" > start.sh
    else
        echo "#!/bin/bash
./bedrock_server" > start.sh
    fi
    chmod +x start.sh
}

# Function to create autostart script
create_autostart_script() {
    if command -v box64 > /dev/null 2>&1; then
        echo '#!/bin/bash
while true; do
    if ! pgrep -x "bedrock_server" > /dev/null; then
        echo "Starting Minecraft Bedrock Server..."
        cd ~/bedrockserver || exit
        export BOX64_LOG=0
        box64 bedrock_server
        echo "Minecraft Bedrock Server stopped! Restarting in 5 seconds."
        sleep 5
    else
        echo "Server is running."
        sleep 5
    fi
done' > autostart.sh
    else
        echo '#!/bin/bash
while true; do
    if ! pgrep -x "bedrock_server" > /dev/null; then
        echo "Starting Minecraft Bedrock Server..."
        cd ~/bedrockserver || exit
        ./bedrock_server
        echo "Minecraft Bedrock Server stopped! Restarting in 5 seconds."
        sleep 5
    else
        echo "Server is running."
        sleep 5
    fi
done' > autostart.sh
    fi
    chmod +x autostart.sh
}

# Function to set up the server
setup_server() {
    echo "Unzipping the downloaded file..."
    mkdir -p bedrockserver
    cd bedrockserver
    unzip -q ../bedrock-server.zip && rm ../bedrock-server.zip
    cd ~/bedrockserver
    create_start_script
    create_autostart_script
    echo "Unzipping completed."
    echo "Setup completed. To start the server, navigate to the 'bedrockserver' directory and run './start.sh'."
}

# Main script execution
read -p "Do you want to use the latest release, preview, or enter a version manually? [release] " choice
determine_url "$choice"

download_and_validate
setup_server
