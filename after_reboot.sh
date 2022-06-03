sudo pacman -S --noconfirm 

sudo echo vm.swappiness=1 >> /etc/sysctl.d/99-swappiness.conf

#install xfce
#sudo systemctl enable lightdm.service
sudo systemctl enable fstrim.timer

git clone https://aur.archlinux.org/yay-bin.git; makepkg -si
yay -S google-chrome megasync-bin visual-studio-code-bin ttf-ancient-fonts ookla-speedtest-bin


mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

timedatectl set-timezone Etc/GMT

python -m pip install --user pipenv
python -m pip install --user pipx
python -m pip install --user virtualenv
