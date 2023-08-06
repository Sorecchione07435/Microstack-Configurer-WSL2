#!/bin/bash


CONFIG_PATH=$PWD/.config

#Before running the script, enter your computer username
WINDOWS_USERNAME=Stef
#This is important!

#echo  "/mnt/c/Users/$WINDOWS_USERNAME/wsl2"
if [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]
then
    echo "This script can only be run in Ubuntu WSL2 environments"
	exit
fi

if [[ "$UID" -ne "$ROOT_UID" ]]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi

echo ""
echo "Installing Essentials Libraries ..."

sudo apt update -y #2>/dev/null   #| echo "Command not returned non-zero exit status" && exit
sudo apt install -y build-essential flex bison libssl-dev libelf-dev libncurses-dev autoconf libudev-dev libtool #2>/dev/null #| echo "Command not returned non-zero exit status" && exit

echo ""
echo "Cloning Kernel Source Repo ..."

cd /usr/src

git clone https://github.com/microsoft/WSL2-Linux-Kernel.git --depth=1 wsl2 

cd wsl2

echo ""
echo "Configuring Kernel ..."

cp "$CONFIG_PATH" /usr/src/wsl2/.config


echo ""
echo "Installing BC and Pahole ..."

apt install -y bc dwarves


echo ""
echo "Building the Kernel (this may take a lot of time) ..."

make

make modules_install 

mkdir /mnt/c/Users/$WINDOWS_USERNAME/wsl2

cp vmlinux /mnt/c/Users/$WINDOWS_USERNAME/wsl2/vmlinux

cat >> /mnt/c/Users/$WINDOWS_USERNAME/.wslconfig << EOF
[wsl2]
kernel = C:\\Users\\$WINDOWS_USERNAME\\wsl2\\vmlinux
EOF

echo ""
echo "Installing DM Multipath Tools ..."

sudo apt install multipath-tools multipath-tools-boot -y 

rm -f /etc/modules-load.d/modules.conf

cat >> /etc/modules-load.d/modules.conf << EOF
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.

dm_multipath
EOF

rm -f /etc/systemd/system/multipath-tools.service

cat >> /etc/systemd/system/multipath-tools.service << EOF
[Unit]
Description=Device-Mapper Multipath Device Controller
Wants=systemd-udev-trigger.service systemd-udev-settle.service
Before=iscsi.service iscsid.service lvm2-activation-early.service
Before=local-fs-pre.target blk-availability.service
After=multipathd.socket systemd-udev-trigger.service systemd-udev-settle.service
DefaultDependencies=no
Conflicts=shutdown.target
ConditionKernelCommandLine=!nompath
ConditionKernelCommandLine=!multipath=off
ConditionVirtualization=yes

[Service]
Type=notify
NotifyAccess=main
LimitCORE=infinity
ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
ExecStart=/sbin/multipathd -d -s
ExecReload=/sbin/multipathd reconfigure
TasksMax=infinity

[Install]
WantedBy=sysinit.target
Also=multipathd.socket
Alias=multipath-tools.service
EOF

rm -f /usr/lib/systemd/system/multipathd.service

cat >> /usr/lib/systemd/system/multipathd.service << EOF
[Unit]
Description=Device-Mapper Multipath Device Controller
Wants=systemd-udev-trigger.service systemd-udev-settle.service
Before=iscsi.service iscsid.service lvm2-activation-early.service
Before=local-fs-pre.target blk-availability.service
After=multipathd.socket systemd-udev-trigger.service systemd-udev-settle.service
DefaultDependencies=no
Conflicts=shutdown.target
ConditionKernelCommandLine=!nompath
ConditionKernelCommandLine=!multipath=off
ConditionVirtualization=yes

[Service]
Type=notify
NotifyAccess=main
LimitCORE=infinity
ExecStartPre=-/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
ExecStart=/sbin/multipathd -d -s
ExecReload=/sbin/multipathd reconfigure
TasksMax=infinity

[Install]
WantedBy=sysinit.target
Also=multipathd.socket
Alias=multipath-tools.service
EOF

echo "Enabling Systemd ..."
cat >> /etc/wsl.conf << EOF
[boot]
systemd=true
EOF


echo ""
echo " **** WSL2 Distro Configured Successfully ******"
echo ""
echo "Your WSL2 Ubuntu distro is now ready to install Microstack"
echo "To install microstack run: 'sudo snap install microstack --edge --devmode' and 'sudo microstack --init --control'"
echo ""
echo "Script Completed!"
exit
