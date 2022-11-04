#!/bin/bash

user=""
host=""
#user password
uspw=""
#root password
rtpw=""
#timezone
tmzn="Africa/Casablanca"
#root location /dev/nvme0n1p6
rtlc="/dev/nvme0n1p6"
#/dev/nvme0n1p1
efip="/dev/nvme0n1p1"
bootpath="/boot"
#pckgs names file
pckgs_file="pacstrap_pkgs"

if [[ -z $user ]]; then
  echo "give username: "
  read $user
fi

if [[ -z $host ]]; then
  echo "give host name: "
  read $host
fi

if [[ -z $uspw ]]; then
  echo "give host user password: "
  read $uspw
fi

if [[ -z $rtpw ]]; then
  echo "give host root password: "
  read $rtpw
fi

if [[ -z $efip ]]; then
  echo "give efi partition (/dev/sda#): "
  read $efip
fi

echo -e "$user $uspw $rtpw $host $tmzn $bootpath"> ./confidentials
#------------------------------------------------------------------------------------------------------------------------------------
# enable options "color", "ParallelDownloads", "multilib (32-bit) repository"
echo -e "\nModifying Pacman Configuration...\n"
sed -i 's #Color Color ; s #ParallelDownloads ParallelDownloads ; s #\[multilib\] \[multilib\] ; /\[multilib\]/{n;s #Include Include }' /etc/pacman.conf
echo -e "\nDone.\n\n"

echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nPerforming Initialization of Pacman Keyring...\n"
pacman-key --init
pacman-key --populate archlinux
echo -e "\nDone.\n\n"
#------------------------------------------------------------------------------------------------------------------------------------
pacman -Sy

echo "mounting $rtlc to /mnt"
mount $rtlc /mnt
echo "mounting home from $rtlc to /mnt/home"
mkdir /mnt/home
mount $home_partition /mnt/home
mkdir "/mnt$bootpath"
mount $efip "/mnt$bootpath"
#------------------------------------------------------------------------------------------------------------------------------------
# save preferred configuration for the reflector systemd service
echo -e "--save /etc/pacman.d/mirrorlist\n--country France,Spain,Germany\n--protocol https\n--score 10\n"
eflector --save /etc/pacman.d/mirrorlist --country France,Spain,Germany --protocol https --score 10 --verbose
echo -e "\nDone.\n\n"
#------------------------------------------------------------------------------------------------------------------------------------
# edit and adjust the "pkgs" file for desired packages (don't worry about any extra white spaces or new lines or comments as they will be omitted using sed and tr)
echo -e "\nPerforming Pacstrap Operation...\n"
pacstrap /mnt $(cat $pckgs_file | sed 's #.*$  g' | tr '\n' ' ')
echo -e "\nDone.\n\n"
#------------------------------------------------------------------------------------------------------------------------------------
#fstab
echo -e "\nGenerating FSTab...\n"
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "\nDone.\n\nBase installation is now complete.\n\n"
#------------------------------------------------------------------------------------------------------------------------------------
echo -e "\nStarting configuration step...\n"
# copy the confidentials file to destination system's root partition so that config script can access the file from inside of chroot
cp ./confidentials /mnt/root/
# copy the config script to destination system's root partition
cp ./config /mnt/root/
# change file permission of config script to make it executable
chmod a+x /mnt/root/config
# run config script from inside of chroot
arch-chroot /mnt /root/config
# remove files that are unnecessary now
rm /mnt/root/{confidentials,config}
#umount -a
echo -e "\nInstallation Complete.\nyou can reboot now\n"
