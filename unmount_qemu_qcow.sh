#!/bin/bash
TEST_FOLDER=/mnt/testdrive
sudo umount $TEST_FOLDER
sudo qemu-nbd --disconnect /dev/nbd0
sudo rmmod nbd
