#!/bin/bash

## https://github.com/sensepost/hostapd-mana/wiki/KARMA---MANA-Attack-Theory
mkdir ~/wiki-github/ &>/dev/null
cd ~/wiki-github/

echo
echo Please write the url to convert without wiki!!
echo Example https://github.com/repouser/reponame/wiki
echo
read url 
echo

WIKI_FOLDER="$(basename $(echo ${url}|awk -F 'wiki' '{print $1}'))-wiki.html"
mkdir $(basename $(echo ${url}|awk -F 'wiki' '{print $1}'))
cd $(basename $(echo ${url}|awk -F 'wiki' '{print $1}'))
wget wget -p -r -l4 -E -k -nH ${url}

echo
echo "PDF file generated at: $HOME/wiki-github/${WIKI_FOLDER}"
