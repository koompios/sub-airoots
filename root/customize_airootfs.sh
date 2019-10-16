#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/bash root
cp -aT /etc/skel/ /root/
chmod 700 /root
passwd root

if less /etc/passwd | grep live; then
    userdel -r -f live
else
    echo "Create live user"
fi


useradd -mg users -G wheel,power,storage -s /bin/bash live
chown -R live:wheel /home/live
passwd live


sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+ALL\)/\1/' /etc/sudoers

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

pacman-key --init
pacman-key --populate archlinux
mv /mirrorlist /etc/pacman.d/



cd /packages
pacman -U --noconfirm *.tar.xz

pacman -S --noconfirm archiso

#  cd /pi
#  cd doc
#  mv yay.8 pi.8
#  cd ..
#  make install
#  cd /
#  rm -rf /pi

chmod 755 /etc/xdg/autostart/remove-outpu.desktop
chmod 755 /usr/share/applications/remove-outpu.desktop
chmod 755 /usr/bin/remove.sh
chmod 755 /usr/bin/pi

#pacman -Rdd vlc
#mv /plymouth/themes/koompi /usr/share/plymouth/themes
#echo "moved koompi plymouth theme"
#mv /plymouth/arch-logo.png /usr/share/plymouth/
#echo "moved plymouth logo"
#mv /mkinitcpio.conf /etc/
#echo "moved mkinitcpio.conf"
#rm -rf /packages /plymouth
#echo "removed unused dirs"

#mkinitcpio -p linux
#plymouth-set-default-theme -R koompi
#grub-mkconfig -o /boot/grub/grub.cfg
#grub-mkconfig -o /boot/grub/grub.cfg

#rm -rf /usr/share/plasma/
rm -rf /usr/share/plasma/desktoptheme/air
rm -rf /usr/share/plasma/desktoptheme/oxygen
rm -rf /usr/share/plasma/desktoptheme/breeze-light
rm -rf /usr/share/plasma/desktoptheme/breeze-dark

# rm -rf /usr/share/plasma/look-and-feel/org.kde.breeze.desktop
# rm -rf /usr/share/plasma/look-and-feel/org.kde.breezedark.desktop
# rm -rf /usr/share/plasma/look-and-feel/org.kde.oxygen



rm -rf /usr/share/icons/Adwaita
rm -rf /usr/share/icons/Breeze_Snow
rm -rf /usr/share/icons/breeze-dark
rm -rf /usr/share/icons/gnome
rm -rf /usr/share/icons/hicolor
rm -rf /usr/share/icons/KDE_Classic
rm -rf /usr/share/icons/locolor
rm -rf /usr/share/icons/oxygen
rm -rf /usr/share/icons/Oxygen_Black
rm -rf /usr/share/icons/Oxygen_Blue
rm -rf /usr/share/icons/Oxygen_White
rm -rf /usr/share/icons/Oxygen_Yellow
rm -rf /usr/share/icons/Zoin
rm -rf /usr/share/icons/Papirus-Dark
rm -rf /usr/share/icons/Papirus-light
rm -rf /usr/share/icons/ePapirus


rm -rf /usr/share/fonts

mv /fonts /usr/share

#rm -rf /packages

#pacman -R dhcpcd

rsync -avz /calamares/* /
cp /usr/share/applications/calamares.desktop /home/live/Desktop
rm -rf /packages
rm -rf /calamares

balooctl disable
chmod 755 /etc/profile.d/expand_cowsize.sh
systemctl enable pacman-init.service choose-mirror.service bluetooth.service sddm.service NetworkManager.service org.cups.cupsd.service
systemctl set-default graphical.target
