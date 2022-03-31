sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoclean -y
sudo apt-get autoremove -y

sudo apt-get install --no-install-recommends -y xfce4 firefox evince eog libappindicator fonts-liberation gedit xfce4-screenshooter unzip
sudo apt-get remove -y xscreensaver

sudo add-apt-repository -y ppa:x2go/stable
sudo apt-get -y update
sudo apt-get install --no-install-recommends -y x2goserver x2goserver-xsession

pushd ~
curlUA='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.60 Safari/537.36'
curlparam=--referer=www.google.com -L --ipv4 -#
curl -A "curlUA" "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" $curlparam -o google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

export sudolla=atkinson
echo creating user $sudolla
sudo adduser --disabled-password --gecos "" --shell /bin/bash $sudolla
usermod -aG sudo $sudolla
mkdir -p /home/atkinson/.config/autostart
mv /home/atkinson/.config /home/atkinson/.config-old

echo "$sudolla ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/dont-prompt-$sudolla-for-sudo-password
echo $sudolla will be your sudoer user

echo -e 'Put customized config (Xfce panel setup, Chrome profile with smooth scrolling disabled)'
## cp -r homedir/{{ item }} /home/atkinson && chown -R atkinson:atkinson /home/atkinson/{{ item }}"

## cp -r homedir/.config /home/atkinson && chown -R atkinson:atkinson /home/atkinson/.config
## cp -r homedir/.local /home/atkinson && chown -R atkinson:atkinson /home/atkinson/.local

echo setting BElgian keyb

cat > /home/ubuntu/.config/autostart/keyboard.desktop <<EOL
[Desktop Entry]
Type=Application
Name=keyboard
Exec=setxkbmap be
StartupNotify=false
Terminal=false
EOF

echo enabling SSHd password auth
sed -i s'/^#?PasswordAuthentication/PasswordAuthentication yes/'g /etc/ssh/sshd_config
systemctl restart ssh

pushd ~
curl -A "curlUA" "https://download.nomachine.com/download/7.9/Linux/nomachine_7.9.2_1_amd64.deb" $curlparam -o nomachine_7.9.2_1_amd64.deb
sudo apt install -y ./nomachine_7.9.2_1_amd64.deb
cp /usr/NX/etc/node.cfg /usr/NX/etc/node.cfg-spare-autostart-Xsession
sed -i s'@^DefaultDesktopCommand "/etc/X11/Xsession default"@DefaultDesktopCommand "/usr/bin/X11/startxfce4"@'g /usr/NX/etc/node.cfg

sudo systemctl stop display-manager
sudo /etc/NX/nxserver --restart
sudo systemctl restart display-manager
