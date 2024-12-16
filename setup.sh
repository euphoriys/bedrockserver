yes | pkg up && yes | pkg install proot-distro wget
pd install ubuntu
echo "pd login ubuntu" >> ../usr/bin/ubuntu && chmod +x ../usr/bin/ubuntu
pd login ubuntu -- bash -c '
yes | apt update && yes | apt upgrade && yes | apt install nano curl wget gpg
mkdir bedrockserver
cd ~/bedrockserver && wget https://download1591.mediafire.com/hqz4ic0i1dqgM538qzuLEfc5IKmuz-9h8gNAHFNnvJ7AJieBt69sm-AudIgWrFS6GgTWkQoX6q2k_ChLMptC6wDKcOQuLBbeE9wRgovpeQ_Eu77yQTb_Y4jY1G5TQKIa36Yic-8Zn-L3A-63CS0J4am6j8WYSPLaUhpEIEKkoDGm_w/q8ihgn4v9rpww8t/bedrock-server-1.21.51.02.zip && unzip bedrock-server*.zip && rm -rf bedrock-server*.zip && cd 
wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg && yes | apt update && yes | apt install box64-android && cd
'
wget https://raw.githubusercontent.com/euphoriys/bedrockserver/main/startb && mv startb ../usr/bin/startb && chmod +x ../usr/bin/startb
wget https://raw.githubusercontent.com/euphoriys/bedrockserver/main/autostartb && mv autostartb ../usr/bin/autostartb && chmod +x ../usr/bin/autostartb
wget https://raw.githubusercontent.com/euphoriys/bedrockserver/main/storageb && mv storageb ../usr/bin/storageb && chmod +x ../usr/bin/storageb
echo "The files were downloaded successfully."
