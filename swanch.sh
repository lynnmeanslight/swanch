#!/usr/bin/env bash

github_repo=https://github.com/nyilynnhtwe/swanch

GREEN_COLOR="\033[38;5;76m"
RED_COLOR="\033[38;5;196m"
BLUE_COLOR="\033[38;5;32m"
END_COLOR="\033[0m"


function print_help() {
  cat <<EOF
Automate your NODEJS dev setup with this all-in-one Bash script on your server!

Usage: $0 [options]

Options:
  -n, --node        Install Node.js (LTS) and npm
  -m, --mysql       Install MySQL
  -p, --postgres    Install PostgreSQL
  -g, --nginx       Install Nginx
  -u, --update      Update the Ubuntu system
  -e, --nestjs      Install NestJS CLI
  -r, --prisma      Install Prisma CLI
  -h, --help        Display this help message

Examples:
  $0 -nmp  # Install Node.js, MySQL, and PostgreSQL
  $0 -g -u # Install Nginx and update the system
EOF
}

function print_error() {
  echo -e "${RED_COLOR}Error${END_COLOR}: $1"
  exit 1
}

function update_system() {
  echo "Updating Ubuntu system.."
  sudo apt update && sudo apt upgrade -y
}

function install_nginx() {
  echo "Installing NGINX.."
  sudo apt install -y nginx
}

function install_node() {
  echo "Installing the latest version of Node.js (LTS) and npm.."
  echo "If you want to use a specific version, you can use nvm (that is already installed with this script)."
  curl -k -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  source ~/.bashrc
  nvm install --lts
}

function install_prisma() {
  echo "Installing Prisma CLI.."
  npm install -g prisma
}

function install_nestjs() {
  echo "Installing NestJS CLI.."
  npm install -g @nestjs/cli
}

function install_mysql() {
  echo "Installing MySQL.."
  sudo apt install -y mysql-server
}

function install_postgresql() {
  echo "Installing PostgreSQL.."
  sudo apt install -y postgresql
}

function main() {
  # Convert long options to short options
  for arg in "$@"; do
    shift
    case "$arg" in
      "--node") set -- "$@" "-n" ;;
      "--mysql") set -- "$@" "-m" ;;
      "--postgres") set -- "$@" "-p" ;;
      "--nginx") set -- "$@" "-g" ;;
      "--update") set -- "$@" "-u" ;;
      "--nestjs") set -- "$@" "-e" ;;
      "--prisma") set -- "$@" "-r" ;;
      "--help") set -- "$@" "-h" ;;
      *) set -- "$@" "$arg" ;;
    esac
  done

  while getopts ":nmppguerh" opt; do
    case $opt in
      n) install_node ;;
      m) install_mysql ;;
      p) install_postgresql ;;
      g) install_nginx ;;
      u) update_system ;;  # Optional: Allows explicit system update via -u flag.
      e) install_nestjs ;;
      r) install_prisma ;;
      h) print_help; exit 0 ;;
      \?) print_error "Invalid option: -$OPTARG" ;;
    esac
  done

  if [[ $OPTIND -eq 1 ]]; then
    print_error "No options provided. Use -n, -m, -p, -g, -u, --nest, or --prisma for Node.js, MySQL, PostgreSQL, NGINX installation, system update, NestJS, or Prisma installation respectively."
  fi
}

main "$@"
