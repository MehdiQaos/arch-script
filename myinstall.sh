#install git before
userName="mehdi"
hostName="archmehdi"
userPassword="miq"
rootPassword="miq"
timeZone

ln -sf /usr/share/zoneinfo/Africa/Casablanca /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

#getting host name
#echo what you want to name your host?
#read host_name

echo $host_name >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $host_name.localdomain $host_name" >> /etc/hosts

echo root:password | chpasswd

useradd -mG wheel mehdi
passwd mehdi
echo "uncomment %wheel ALL=(ALL) ALL"
read piq
EDITOR=vim visudo

sudo pacman -S --noconfirm linux linux-headers base-devel intel-ucode grub networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober dosfstools xdg-utils xdg-user-dirs ntfs-3g xf86-video-intel xorg htop bash-completion firefox mpv gvfs noto-fonts-emoji adobe-source-han-sans-otc-fonts xclip qpdfview vulkan-intel libva-intel-driver android-tools qbittorrent jdk-openjdk python-pip ttf-fira-code ttf-fira-mono ttf-fira-sans ttf-ubuntu-font-family gvfs-mtp nodejs npm stow zsh curl alacritty nvim

sudo echo vm.swappiness=1 >> /etc/sysctl.d/99-swappiness.conf

#install xfce
sudo pacman -S xfce4 xfce4-goodies pulseaudio papirus-icon-theme arc-gtk-theme lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings materia-gtk-theme thunar-archive-plugin
sudo pacman -S file-roller
sudo systemctl enable lightdm.service

systemctl enable NetworkManager
sudo systemctl enable fstrim.timer

grub-install --target=i386-pc /dev/sda
echo GRUB_DISABLE_OS_PROBER=false >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

git clone https://aur.archlinux.org/yay-bin.git; makepkg -si
yay -S google-chrome
yay -S megasync-bin
yay -S visual-studio-code-bin
yay -S ttf-ancient-fonts

echo [multilib] >> /etc/pacman.conf
echo Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf

python -m pip install --user pipenv

mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
