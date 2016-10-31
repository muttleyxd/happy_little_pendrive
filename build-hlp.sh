#!/bin/bash
if [ `id -u` -eq 0 ]; then
    echo "This script can't be run as root"
    exit
fi

sudo echo "Build process has started!"

startDir=`pwd`
rm -rf build/
mkdir build
cd build

#Download required items
echo "Downloading Core-current.iso"
wget --quiet http://tinycorelinux.net/7.x/x86/release/Core-current.iso
echo "Downloading bash.tcz"
wget --quiet http://tinycorelinux.net/7.x/x86/tcz/bash.tcz
echo "Downloading chntpw.tcz"
wget --quiet http://tinycorelinux.net/7.x/x86/tcz/chntpw.tcz
echo "Downloading ncurses.tcz"
wget --quiet http://tinycorelinux.net/7.x/x86/tcz/ncurses.tcz
echo "Downloading ntfs-3g.tcz"
wget --quiet http://tinycorelinux.net/7.x/x86/tcz/ntfs-3g.tcz
echo "Downloading openssl.tcz"
wget --quiet http://tinycorelinux.net/7.x/x86/tcz/openssl.tcz
echo "Downloading readline.tcz"
wget --quiet http://tinycorelinux.net/7.x/x86/tcz/readline.tcz

#clean if any previous build files were left
sudo rm -rf /tmp/happylittlependrive
sudo rm -rf /tmp/happylittlependrive_extract

#unmount if anything previous was left
sudo umount /mnt/happylittlependrive
sudo rm -rf /mnt/happylittependrive

#mount iso
sudo mkdir /mnt/happylittlependrive
sudo mount Core-current.iso /mnt/happylittlependrive -o loop,ro

#unpack to /tmp/happylittlependrive
mkdir /tmp/happylittlependrive
cp -a /mnt/happylittlependrive/boot /tmp/happylittlependrive
sudo mv /tmp/happylittlependrive/boot/core.gz /tmp/happylittlependrive

#unmount
sudo umount /mnt/happylittlependrive
sudo rm -rf /mnt/happylittlependrive

#extract core.gz
mkdir /tmp/happylittlependrive_extract
cd /tmp/happylittlependrive_extract
zcat /tmp/happylittlependrive/core.gz | sudo cpio -i -H newc -d

#copy required files to unpacked core.gz
cd $startDir
sudo rm /tmp/happylittlependrive/boot/isolinux/boot.msg
sudo cp boot.msg /tmp/happylittlependrive/boot/isolinux/boot.msg
sudo cp hack.sh /tmp/happylittlependrive_extract/root/hack.sh
sudo cp pcl.bat /tmp/happylittlependrive_extract/root/pcl.bat
sudo cp bootlocal.sh /tmp/happylittlependrive_extract/opt/bootlocal.sh
cd build
sudo cp *.tcz /tmp/happylittlependrive_extract/root/

#build new core.gz
cd /tmp/happylittlependrive_extract
sudo rm /tmp/happylittlependrive/core.gz
sudo find | sudo cpio -o -H newc | sudo gzip -2 > /tmp/happylittlependrive/core.gz
cd /tmp/happylittlependrive
sudo mv core.gz boot

#build iso file
mkdir newiso
sudo mv boot newiso
sudo mkisofs -l -J -R -V TC-custom -no-emul-boot -boot-load-size 4 -boot-info-table -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o hlp.iso newiso

#cleanup
sudo rm -rf newiso

#move iso to build dir
cd $startDir
sudo cp /tmp/happylittlependrive/hlp.iso ./build/hlp.iso

#set proper file owner
userName=`id -u -n`
sudo chown $userName:$userName ./build/hlp.iso

#finishing cleanup
rm ./build/*.tcz
rm ./build/Core-current.iso
sudo rm -rf /tmp/happylittlependrive
sudo rm -rf /tmp/happylittlependrive_extract

#goodbye :)
echo ".build/hlp.iso is ready to use"

