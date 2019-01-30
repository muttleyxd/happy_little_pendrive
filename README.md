# Happy Little Pendrive
Small and fast admin access recovery tool

## What is it?
HLP is a set of automated scripts, that allow you to recover your admin access on Windows systems.
It works by replacing Sticky Keys (sethc.exe) with cmd.exe. Also it enables Sticky Keys in registry.

The goal of this tool is to provide a fast and reliable way to gain admin access on Windows systems.

## How to use it?
The main script is hack.sh - it searches for NTFS partitons, selects these Windows and applies changes.
You can either copy this script to distro of your choice and run it there, or you can build Tiny Core Linux with it.
Script requires Bash and Ntfs-3G to run.

If you run Tiny Core Linux build it'll ask you to press enter to start recovery.
After a while it should change to a screen like this.

It displays information how many NTFS partitions were detected, how many of them contained Windows and how many were changed.

![HLP script finished](http://i.imgur.com/F6fr3Js.png)

After reboot to Windows, on login screen you should press SHIFT key five times. Cmd.exe should pop up, from there you can start pcl.bat script which will add user with login: boss and password: boss.

Alternatively you can add new user manually

    net user add login password /add
    net localgroup Administrators login /add

## Building with Tiny Core Linux

### Requirements

 - Cpio
 - Wget
 - Gzip

### Build process

    git clone https://github.com/muttleyxd/happy_little_pendrive.git
    cd happy_little_pendrive
    chmod +x build_hlp.sh
    ./build_hlp.sh

The script produces an ISO file in happy_little_pendrive/build directory. You can burn it on CD or Pendrive with IsoUsb or SUSE Studio ImageWriter.

## Limitations

 - BitLocker encrypted partitions won't work with HLP
 - Possible issues with non-English versions of Windows

## Planned features

 - Linux and MacOS support

HLP was tested on Windows 7 x64 Ultimate and Windows 10 x64 Pro.
