#!/bin/bash
TEST_FOLDER=/mnt/testdrive
echo "Which .qcow file you want to mount? :"
read qcow_file
sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 $qcow_file
while [ $? -ne 0 ]
do
	echo "error while reading file"
	read qcow_file
	sudo qemu-nbd --connect=/dev/nbd0 $qcow_file
done
echo "which of the following partitions you want to mount? "
sudo fdisk /dev/nbd0 -l | grep ^/dev/
list_of_drives=$(sudo fdisk /dev/nbd0 -l | grep ^/dev/ | cut -d' ' -f1)
read drive_chosen
k=0
for i in $list_of_drives
do
	if [ "$drive_chosen" == "$i" ]
	then
		echo "Drive chosen: " $i
		(( k=1 ))
		break
	fi
done
if [ $k -eq 1 ]
then
	if [ -d $TEST_FOLDER ] 
	then
		echo "Test directory exists"
	else
		sudo mkdir $TEST_FOLDER
	fi
	sudo mount $drive_chosen $TEST_FOLDER
else
	echo "Drive not found. Exiting."
	sudo bash ./unmount_qemu_qcow.sh
fi
