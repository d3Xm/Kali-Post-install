# Kali-Post-install
Post installation to fix the misstakes of Kali maintainers

# Purpose
The meaning of this is simply to lessen the burden of when a Kali vm gets fucked by broken dependencies or a update breaks stuff.. and shorten the time to get back at it

# What it does
dynamic flags:<br /> 
HOSTNAME=d3Xm<br />
TIMEZONE='Europe/Stockholm'<br />
HOME=/home/kali/<br />
GITHUBTOKEN=  # Add your Github API token here<br />

Changes:<br />
default shell to bash<br />
PS1 to something that dosnt make you want to rip your eyes out<br />
tmux config<br />
terminal transparency = 0%<br />
terminal colorScheme = Linux<br />
Increased terminal histort 100k lines instead of 1k lines<br />
Turns off LLMNR<br />
Timezone<br />
Mutes the volume<br />
Disables Auto-Lock / Sleep<br />

Creates:<br />
/home/kali/shares  and sets a bashrc script to enable it for vmware shares<br />
/home/kali/shares/virtualshares/sharedbins in $PATH <br />

Installs:<br />
Go Lang<br />
Bloodhound<br />
CrackMapExec<br />
Dictator<br />
EAP Hammer<br />
EavesARP<br />
Evil-WinRM<br />
Gitrob<br />
Gobuster<br />
King-Phisher<br />
PCredz<br />
Reconbot<br />
RsaCTFool<br />
Ruler<br />
WPscan<br />
gnome-screenshot <br />
libreoffice <br />
remmina <br />
gvfs-backends<br />
sshpass<br />
Docker<br />
Docker-compose<br />




##
To Do:
----
fix bash session logging module
