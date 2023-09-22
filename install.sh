#!/usr/bin/env bash


echo "Installing Swanch....."

sudo curl -sSL https://raw.githubusercontent.com/nyilynnhtwe/swanch/master/swanch.sh > swanch

sudo chmod +x ./swanch

sudo cp ./swanch /usr/local/bin/
sudo cp ./swanch /usr/bin/

rm -f swanch

echo "Installed Swanch successfully!"