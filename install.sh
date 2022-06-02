#!/bin/bash

user="mehdi"
host="archmehdi"
#user password
uspw="piq"
#root password
rtpw="miq"
#timezone
tmzn="Africa/Casablanca"
#root location
rtlc=""
#pckgs names file
pckgs_file="pacstrap_pkgs"

echo -e "$userName $userPassword $rootPassword $hostName $timeZone $rtlc"> ./confidentials
#------------------------------------------------------------------------------------------------------------------------------------
# enable options "color", "ParallelDownloads", "multilib (32-bit) repository"
echo -e "\nModifying Pacman Configuration...\n"
sed -i 's #Color Color ; s #ParallelDownloads ParallelDownloads ; s #\[multilib\] \[multilib\] ; /\[multilib\]/{n;s #Include Include }' /etc/pacman.conf
echo -e "\nDone.\n\n"
#------------------------------------------------------------------------------------------------------------------------------------
pacman -Sy

echo "mounting $rtlc to /mnt"
mount $rtlc /mnt
#------------------------------------------------------------------------------------------------------------------------------------
# save preferred configuration for the reflector systemd service
echo -e "--save /etc/pacman.d/mirrorlist\n--country Sweden,Denmark\n--protocol https\n--score 10\n"
reflector --save /etc/pacman.d/mirrorlist --country France,Spain,Germany --protocol https --score 10 --verbose
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
umount -a
echo -e "\nInstallation Complete.\n\nSystem will reboot in 10 seconds..."
sleep 10
reboot
