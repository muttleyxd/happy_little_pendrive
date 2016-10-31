#!/bin/sh
# put other system startup commands here
cd /root
chmod +r /root/*
chmod +x /root/hack.sh
su -c "tce-load -i readline.tcz" -s /bin/sh tc
su -c "tce-load -i ncurses.tcz" -s /bin/sh tc
su -c "tce-load -i openssl.tcz" -s /bin/sh tc
su -c "tce-load -i bash.tcz" -s /bin/sh tc
su -c "tce-load -i ntfs-3g.tcz" -s /bin/sh tc
su -c "tce-load -i chntpw.tcz" -s /bin/sh tc
./hack.sh