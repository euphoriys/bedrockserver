yes | pkg up && yes | pkg install proot-distro
pd install ubuntu
echo "pd login ubuntu" >> ../usr/bin/ubuntu && chmod +x ../usr/bin/ubuntu
pd login ubuntu -- bash -c "yes | apt update && yes | apt upgrade && yes | apt install nano git curl wget gpg"
pd login ubuntu -- bash -c "mkdir bedrockserver"
pd login ubuntu -- bash -c "cd ~/bedrockserver && wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.21.3.01.zip && unzip bedrock-server*.zip && rm -rf bedrock-server*.zip"
pd login ubuntu -- bash -c "cd ~ && wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg && yes | sudo apt update && yes | sudo apt install box64-android"
pd login ubuntu -- bash -c "cd ~ && wget https://raw.githubusercontent.com/invinc1ble7/bedrockserver/main/server && mv server ../usr/bin/server && chmod +x ../usr/bin/server"
