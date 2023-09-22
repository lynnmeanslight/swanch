#!/usr/bin/env bash

github_repo=https://github.com/nyilynnhtwe/swanch

GREEN_COLOR="\033[38;5;76m"
RED_COLOR="\033[38;5;196m"
BLUE_COLOR="\033[38;5;32m"
END_COLOR="\033[0m"

COMMAND=$1

if [[ -z $COMMAND ]]; then
    echo -e "${RED_COLOR}Error${END_COLOR} : no command provided. Check the docs at ${BLUE_COLOR}$github_repo${END_COLOR}"
    exit 1
fi

if [[ "$COMMAND" = "build" ]]; then
    echo ""
    echo -e "${GREEN_COLOR}Setting up${END_COLOR}"
    echo "____________________________________"

    #system update and upgrade
    sudo apt-get update >/dev/null
    sudo apt upgrade -fy >/dev/null

    # install nginx
    echo "Installing NGINX.."
    sudo apt-get install -qq nginx
    echo "NGINX is installed successfully!"

    sudo apt-get update >/dev/null

    #____________________________________________ Node setup ____________________________________________

    # install nvm
    echo "Installing NVM.."
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

    echo "NVM is installed successfully!"

    # This loads nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    # Ensure nvm is loaded in the current shell session
    source "$NVM_DIR/nvm.sh"
    echo "Node.js LTS versions:"
    nvm ls-remote --lts

    # Prompt for LTS version selection
    read -p "Enter the Node.js LTS version you want to install: " LTS_VERSION

    # Install the specified LTS version of Node.js
    nvm install $LTS_VERSION

    # Set the installed Node.js version as default
    nvm use $LTS_VERSION --default

    # Verify Node.js version
    echo "Node.js version $LTS_VERSION has been installed and set as the default."

    # install prisma cli
    npm install -g prisma

    # install nest cli
    npm install -g @nestjs/cli

    sudo apt-get update >/dev/null

    #____________________________________________ End ____________________________________________

    # Install mysql-server
    sudo apt-get -yf install mysql-server

    sudo apt-get update >/dev/null

    # Start the MySQL service
    sudo systemctl start mysql

    # Enable MySQL to start on boot
    sudo systemctl enable mysql

    # Display MySQL server status
    sudo systemctl status mysql

else
    echo -e "${RED_COLOR}Error${END_COLOR}: Invalid command. Check the docs at ${BLUE_COLOR}$github_repo${END_COLOR}"
    exit 1
fi
