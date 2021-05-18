#!/bin/bash

echo 'mounting virtualshares to $home/shares/'
/usr/bin/vmhgfs-fuse .host:/ /home/kali/shares -o subtype=vmhgfs-fuse,allow_other
echo 'shares mounted'

echo 'adding shared bins to $PATH'
PATH=$PATH:/home/kali/shares/virtualshares/sharedbins/
echo 'Done !'
