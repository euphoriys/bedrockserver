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
    local instance_name=$1
    echo "Downloading version: $version"
    curl -s -A "Mozilla/5.0 (Linux)" -o "$instance_name.zip" $url || { echo "Error: Unable to download the specified version."; exit 1; }

    if ! unzip -tq "$instance_name.zip" > /dev/null 2>&1; then
        echo "Error: The specified version does not exist or the downloaded file is not a valid zip file."
        rm "$instance_name.zip"
        exit 1
    fi

    echo "Download and validation successful."
}

# Function to create start script
create_start_script() {
    if command -v box64 > /dev/null 2>&1; then
        echo "#!/bin/bash
export BOX64_LOG=0
box64 bedrock_server | grep -v 'Box64 with Dynarec'" > start.sh
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
        box64 bedrock_server | grep -v 'Box64 with Dynarec'
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
    local instance_name=$1
    echo "Unzipping the downloaded file..."
    mkdir -p "$instance_name"
    cd "$instance_name"
    unzip -q "../$instance_name.zip" && rm "../$instance_name.zip"
    create_start_script
    create_autostart_script
    echo "Unzipping completed."
    echo "Setup completed. To start the server, navigate to the '$instance_name' directory and run './start.sh'."
}

# Function to list existing instances
list_instances() {
    echo "Existing instances:"
    ls -d bedrockserver_* 2>/dev/null || echo "No instances found."
}

# Function to replace the bedrock_server executable in an existing instance
replace_version() {
    list_instances
    read -p "Enter the instance number to replace the bedrock_server executable: " instance_number
    instance_dir="bedrockserver_$instance_number"
    if [ -d "$instance_dir" ]; then
        unzip -o -j "../$instance_name.zip" "bedrock_server" -d "$instance_dir"
        rm "../$instance_name.zip"
        echo "Instance $instance_number updated successfully."
    else
        echo "Instance $instance_number does not exist."
    fi
}

# Main script execution
echo "Choose an option:"
echo "1. Create a new instance"
echo "2. Replace the bedrock_server executable in an existing instance"
echo "3. Overwrite the current instance"
read -p "Enter your choice [1-3]: " option

read -p "Do you want to use the latest release, preview, or enter a version manually? [release] " choice
determine_url "$choice"

read -p "Enter a name for the new instance (leave empty for default naming): " instance_name
if [ -z "$instance_name" ]; then
    instance_count=$(ls -d bedrockserver_* 2>/dev/null | wc -l)
    if [ "$instance_count" -eq 0 ]; then
        instance_name="bedrockserver"
    else
        instance_number=$((instance_count + 1))
        instance_name="bedrockserver_$instance_number"
    fi
fi

download_and_validate "$instance_name"

case "$option" in
    1)
        setup_server "$instance_name"
        ;;
    2)
        replace_version "$instance_name"
        ;;
    3)
        setup_server "bedrockserver"
        ;;
    *)
        echo "Invalid option."
        ;;
esac
