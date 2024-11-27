#!/bin/sh

# --------------------------------------------------------------------------------
# Date: 27 Nov 2024
# Name: wdpUninstall.sh
# Made by: Samuel Nogueira
# Description: This will remove everything the other script did from your VM. 
# --------------------------------------------------------------------------------


echo 
echo "This script will undo everything wdpInstall.sh did."
echo
echo "You have 5 seconds to cancel (ctrl + c)"
sleep 5

echo
docker stop nginx wordpress db
docker remove nginx wordpress db
docker volume remove wdp-docker-directory_db-data wdp-docker-directory_wordpress
echo 
cd ~
rm -rf wdp-docker-directory/
cd ..

# Made by Samuel Nogueira on 27 Nov 2024