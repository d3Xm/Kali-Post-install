#!/bin/bash
HOSTNAME=d3Xm
TIMEZONE='Europe/Stockholm'
HOME=/home/kali/
GITHUBTOKEN=  # Add your Github API token here

cd $HOME

printf '\n============================================================\n'
printf '[+] Setting up host specific details\n'
printf '============================================================\n\n'
echo 'setting up hostname'
sed -i "s/kali/$HOSTNAME/g" /etc/hostname
sed -i 's/kali/d3Xm/g' /etc/hosts
echo 'changing default shell'
chsh --shell /bin/bash kali
chsh --shell /bin/bash root
echo 'creating share directory'
mkdir /home/kali/shares
chmod 774 shares
chown kali:kali shares
echo 'downloading share script'
wget https://raw.githubusercontent.com/d3Xm/Kali-Post-install/main/mount.sh | sh
chown kali:kali mount.sh
chmod 774 mount.sh
sed -i 's/#user_allow_other/user_allow_other/g'  /etc/fuse.conf
echo 'if [ -z "${TMUX}" ]; then' >> $HOME/.bashrc
echo '        /usr/bin/vmhgfs-fuse .host:/ /home/kali/shares -o subtype=vmhgfs-fuse,allow_other' >> $HOME/.bashrc
echo 'fi' >> $HOME/.bashrc 
echo 'PATH=$PATH:/home/kali/shares/virtualshares/sharedbins/' >> $HOME/.bashrc
echo 'setting a PS1 for bash that dosnt make me want to claw my eyes out'
echo 'PS1="\[\e[31;1m\]\u\[\e[32;1m\]\[\e[37;2m\](\[\e[32;1m\]\w\[\e[37;1m\])\[\e[31;1m\]> \[\e[0m\]"' >> /root/.bashrc
echo 'PS1="\[\e[31;1m\]\u\[\e[32;1m\]\[\e[37;2m\](\[\e[32;1m\]\w\[\e[37;1m\])\[\e[31;1m\]> \[\e[0m\]"' >> /home/kali/.bashrc
echo 'downloading tmux conf'
wget https://raw.githubusercontent.com/d3Xm/Kali-Post-install/main/.tmux.conf
echo 'gettin rid of transparency..'
sed -i 's/ApplicationTransparency=5/ApplicationTransparency=0/g' /home/kali/.config/qterminal.org/qterminal.ini
echo 'increasing history'
sed -i 's/HistoryLimitedTo=1000/HistoryLimitedTo=100000/g' /home/kali/.config/qterminal.org/qterminal.ini
echo 'back to the beutiful darkness of a real terminal...'
sed -i 's/colorScheme=Kali-Dark/colorScheme=Linux/g' /home/kali/.config/qterminal.org/qterminal.ini
echo 'hush kali devs'
touch ~/.hushlogin

printf '\n============================================================\n'
printf '[+] Updating System\n'
printf '============================================================\n\n'
apt-get update -y
apt-get upgrade -y



printf '\n============================================================\n'
printf '[+] Remove password requirement for sudo commands\n'
printf '============================================================\n\n'
sed -i 's/ ALL/ NOPASSWD: ALL/g' /etc/sudoers

printf '\n============================================================\n'
printf '[+] Enabling bash session logging\n'
printf '============================================================\n\n'

apt-get install -y tmux-plugin-manager
mkdir -p "$HOME/.tmux/plugins" 2>/dev/null
export XDG_CONFIG_HOME="$HOME"
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"
/usr/share/tmux-plugin-manager/scripts/install_plugins.sh
mkdir -p "$HOME/Logs" 2>/dev/null

grep -q 'TMUX_LOGGING' "/etc/profile" || echo '
export HISTSIZE= 
export HISTFILESIZE=
export PROMPT_COMMAND="history -a"
export HISTTIMEFORMAT="%F %T "
setopt INC_APPEND_HISTORY 2>/dev/null

logdir="$HOME/Logs"
mkdir -p $logdir 2>/dev/null
#gzip -q $logdir/*.log &>/dev/null
export XDG_CONFIG_HOME="$HOME"
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"
if [[ ! -z "$TMUX" && -z "$TMUX_LOGGING" ]]; then
    logfile="$logdir/tmux_$(date -u +%F_%H_%M_%S)_UTC.$$.log"
    "$TMUX_PLUGIN_MANAGER_PATH/tmux-logging/scripts/start_logging.sh" "$logfile"
    export TMUX_LOGGING="$logfile"
fi' >> "/etc/profile"

normal_log_script='
export HISTSIZE= 
export HISTFILESIZE=
export PROMPT_COMMAND="history -a"
export HISTTIMEFORMAT="%F %T "
setopt INC_APPEND_HISTORY 2>/dev/null

#logdir="$HOME/Logs"
#mkdir -p $logdir 2>/dev/null
#if [[ -z "$NORMAL_LOGGING" && ! -z "$PS1" && -z "$TMUX" ]]; then
#    logfile="$logdir/$(date -u +%F_%H_%M_%S)_UTC.$$.log"
#    export NORMAL_LOGGING="$logfile"
#    script -f -q "$logfile"
#    exit
#fi'

grep -q 'NORMAL_LOGGING' "$HOME/.bashrc" || echo "$normal_log_script" >> "$HOME/.bashrc"
grep -q 'NORMAL_LOGGING' "$HOME/.zshrc" || echo "$normal_log_script" >> "$HOME/.zshrc"

printf '\n============================================================\n'
printf '[+] Adjusting timezone and locale\n'
printf '============================================================\n\n'
#ls -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
#dpkg-reconfigure -f noninteractive tzdata
timedatectl set-timezone $TIMEZONE
localectl set-locale en_GB.UTF-8

printf '\n============================================================\n'
printf '[+] Lowering volume\n'
printf '============================================================\n\n'
systemctl --user enable pulseaudio
systemctl --user start pulseaudio
pactl set-sink-mute 0 0
pactl set-sink-volume 0 25%

printf '\n============================================================\n'
printf '[+] Disabling Auto-lock, Sleep on AC\n'
printf '============================================================\n\n'
xset s off
xset s noblank
xset -dpms
xset dpms 0 0 0

printf '\n============================================================\n'
printf '[+] Disabling LL-MNR\n'
printf '============================================================\n\n'
echo '[Match]
name=*
[Network]
LLMNR=no' > /etc/systemd/network/90-disable-llmnr.network

printf '\n============================================================\n'
printf '[+] Installing tools\n'
printf '============================================================\n\n'

printf '\n============================================================\n'
printf '[+] Installing Go lang\n'
printf '============================================================\n\n'
## Go lang install and add /home/go/bin to path
apt-get install -y golang
echo 'export GOROOT=/usr/lib/go' >> /home/kali/.bashrc
echo 'export GOPATH=$HOME/go' >> /home/kali/.bashrc
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /home/kali/.bashrc


printf '\n============================================================\n'
printf '[+] Installing Bloodhound.py\n'
printf '============================================================\n\n'
apt-get install -y neo4j bloodhound
    ##Neo4j - change password
    ##neo4j console

printf '\n============================================================\n'
printf '[+] Installing Bettercap\n'
printf '============================================================\n\n'
apt-get -y install libnetfilter-queue-dev libpcap-dev libusb-1.0-0-dev
go get -v github.com/bettercap/bettercap
go build $HOME/go/src/github.com/bettercap/bettercap
ln -s $HOME/go/bin/bettercap /usr/local/bin/bettercap

printf '\n============================================================\n'
printf '[+] Installing CrackMapExec\n'
printf '============================================================\n\n'
cme_dir="$(ls -d /home/kali/.local/share/virtualenvs/* | grep CrackMapExec | head -n 1)"
if [[ ! -z "$cme_dir" ]]; then rm -r "${cme_dir}.bak"; mv "${cme_dir}" "${cme_dir}.bak"; fi
apt-get install -y libssl-dev libffi-dev python-dev build-essential
cd /opt
git clone --recursive https://github.com/byt3bl33d3r/CrackMapExec
cd CrackMapExec && python3 -m pipenv install
python3 -m pipenv run python setup.py install
ln -s ~/.local/share/virtualenvs/$(ls /home/kali/.local/share/virtualenvs | grep CrackMapExec | head -n 1)/bin/cme ~/usr/local/bin/cme
apt-get install -y crackmapexec


printf '\n============================================================\n'
printf '[+] Installing Dictator\n'
printf '============================================================\n\n'
go get -v github.com/0bs3ssi0n/Dictator
ln -s /home/kali/go/bin/Dictator /usr/local/bin/Dictator

printf '\n============================================================\n'
printf '[+] Installing Evil-WinRM\n'
printf '============================================================\n\n'
gem install evil-winrm

printf '\n============================================================\n'
printf '[+] Installing EAP Hammer\n'
printf '============================================================\n\n'
cd /opt
git clone https://github.com/s0lst1c3/eaphammer.git
cd eaphammer
./kali-setup
ln -s /opt/eaphammer/eaphammer /usr/local/bin/eaphammer

printf '\n============================================================\n'
printf '[+] Installing EavesARP\n'
printf '============================================================\n\n'
cd /opt
git clone https://github.com/mmatoscom/eavesarp
cd eavesarp && python3 -m pip install -r requirements.txt
cd && ln -s /opt/eavesarp/eavesarp.py /usr/local/bin/eavesarp

printf '\n============================================================\n'
printf '[+] Installing fuff\n'
printf '============================================================\n\n'
go get -v -u github.com/ffuf/ffuf


printf '\n============================================================\n'
printf '[+] Installing Gitrob\n'
printf '============================================================\n\n'
go get -v github.com/michenriksen/gitrob
echo -e 'export GITROB_ACCESS_TOKEN='$GITHUBTOKEN'' >> $HOME/.bashrc
go build $HOME/go/src/github.com/michenriksen/gitrob

printf '\n============================================================\n'
printf '[+] Installing Gobuster\n'
printf '============================================================\n\n'
apt-get install gobuster

printf '\n============================================================\n'
printf '[+] Installing King-Phisher\n'
printf '============================================================\n\n'
cd /tmp
wget -q https://github.com/securestate/king-phisher/raw/master/tools/install.sh && \
bash ./install.sh
sudo ln -s /opt/king-phisher/KingPhisher /usr/local/bin/ 


printf '\n============================================================\n'
printf '[+] Initializing Metasploit Database\n'
printf '============================================================\n\n'
systemctl start postgresql
systemctl enable postgresql
msfdb init

printf '\n============================================================\n'
printf '[+] Installing PCredz\n'
printf '============================================================\n\n'
apt-get remove -y python-pypcap
pip3 install libpcap python-libpcap 
cd /opt
git clone https://github.com/lgandx/PCredz.git
ln -s /opt/PCredz/Pcredz /usr/local/bin/pcredz

printf '\n============================================================\n'
printf '[+] Installing Phishing Templates\n'
printf '============================================================\n\n'
cd /opt
git clone https://github.com/bLackCat-79/PhishingTemplates.git
chown -R kali:kali PhishingTemplates/



printf '\n============================================================\n'
printf '[+] Installing Reconbot\n'
printf '============================================================\n\n'
cd /opt
git clone https://github.com/0bs3ssi0n/Reconbot.git
cd Reconbot
chmod +x reconbot
ln -s /opt/Reconbot/reconbot /usr/bin/reconbot

printf '\n============================================================\n'
printf '[+] Installing RsaCTFool\n'
printf '============================================================\n\n'
cd /opt
git clone https://github.com/Ganapati/RsaCtfTool.git
sudo apt-get install -y libgmp3-dev libmpc-dev
cd RsaCtfTool
pip3 install -r "requirements.txt"
python3 RsaCtfTool.py
ln -s /opt/RsaCtfTool/RsaCtfTool.py /usr/local/bin/

printf '\n============================================================\n'
printf '[+] Installing Ruler\n'
printf '============================================================\n\n'
cd /opt
mkdir ruler
chown kali:kali ruler
cd ruler
wget https://github.com/sensepost/ruler/releases/download/2.4.1/ruler-linux64
mv ruler-linux64 ruler
chown kali:kali ruler
chmod +x ruler
ln -s /opt/ruler/ruler /usr/local/bin/


printf '\n============================================================\n'
printf '[+] Installing WPscan\n'
printf '============================================================\n\n'
apt-get install -y wpscan

printf '\n============================================================\n'
printf '[+] Installing:\n'
printf '     - gnome-screenshot\n'
printf '     - LibreOffice\n'
printf '     - Remmina\n'
printf '     - file explorer SMB capability\n'
printf '============================================================\n\n'
apt-get install -y gnome-screenshot libreoffice remmina gvfs-backends sshpass xclip


printf '\n============================================================\n'
printf '[+] Increase open file limit\n'
printf '============================================================\n\n'
apt-get install -y neo4j gconf-service gconf2-common libgconf-2-4
mkdir -p /usr/share/neo4j/logs /usr/share/neo4j/run
grep '^root   soft    nofile' /etc/security/limits.conf || echo 'root   soft    nofile  500000
root   hard    nofile  600000' >> /etc/security/limits.conf
grep 'NEO4J_ULIMIT_NOFILE=60000' /etc/default/neo4j 2>/dev/null || echo 'NEO4J_ULIMIT_NOFILE=60000' >> /etc/default/neo4j
grep 'fs.file-max' /etc/sysctl.conf 2>/dev/null || echo 'fs.file-max=500000' >> /etc/sysctl.conf
sysctl -p
neo4j start

printf '\n============================================================\n'
printf '[+] Installing Docker\n'
printf '============================================================\n\n'
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo 'deb [arch=amd64] https://download.docker.com/linux/debian buster stable' | tee /etc/apt/sources.list.d/docker.list
apt-get update
apt remove docker docker-engine docker.io
apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl enable containerd
curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

printf '\n============================================================\n'
printf '[+] Now reboot the machine so that all changes are applied\n'
printf '============================================================\n\n'









