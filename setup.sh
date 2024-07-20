yes | pkg up && yes | pkg install proot-distro
pd install ubuntu && "echo pd login ubuntu" >> ../usr/bin/ubuntu && chmod +x ../usr/bin/ubuntu
pd login ubuntu -- yes | apt update && pd login ubuntu -- yes | apt upgrade && pd login ubuntu -- yes | apt install nano curl wget
pd login ubuntu -- mkdir bedrockserver && pd login ubuntu -- cd bedrockserver
pd login ubuntu -- wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.21.3.01.zip && pd login ubuntu -- unzip bedrock-server*.zip && pd login ubuntu -- rm -rf bedrock-server*.zip
pd login ubuntu -- cd ~ && pd login ubuntu -- wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && pd login ubuntu -- 
pd login ubuntu -- wget
