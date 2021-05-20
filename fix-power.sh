#!/bin/bash
export DISPLAY=:0
localectl set-locale en_GB.UTF-8

sudo -H -u kali bash -c "xset s off"
sudo -H -u kali bash -c "xset s noblank"
sudo -H -u kali bash -c "xset -dpms"
sudo -H -u kali bash -c "xset dpms 0 0 0"
