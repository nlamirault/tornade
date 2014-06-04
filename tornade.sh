#!/bin/bash

# Copyright (C) 2014  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

TORNADE_DIR=/tmp/tornade

DEIS_VERSION=0.9.0
DEIS_NUM_INSTANCES=3
DEIS_NUM_ROUTERS=1
DEIS_REPO=https://github.com/deis/deis.git

FLEET_VERSION=0.3.3
FLEET_FILE=fleet-v$FLEET_VERSION-linux-amd64.tar.gz
FLEET_REPO=https://github.com/coreos/fleet/releases/download

export DOCKER_HOST=tcp://172.17.8.100:4243
export FLEETCTL_TUNNEL=172.17.8.100

OK="\033[1;32m"
KO="\033[1;31m"
END="\e[0m"

DIR=`pwd`

print_ok() {
    echo -e "$OK$1$END"
}

print_ko() {
    echo -e "$KO$1$END"
}

usage() {
    echo "$0 <command>"
    echo "   build    : build the Deis"
    echo "   init     : initialize Tornade PAAS"
}

check_program () {
    cmd=$1
    name=$2
    hash $cmd 2>/dev/null || { print_ko "$name is required.  Aborting."; exit 1; }
}

check_tornade() {
    print_ok "[-] Checking requirements"
    check_program git "git"
    check_program curl "curl"
    check_program vagrant "vagrant"
    rm -fr $TORNADE_DIR
    mkdir -p $TORNADE_DIR
}


download_deis() {
    print_ok "[-] Download Deis"
    git clone $DEIS_REPO $TORNADE_DIR/deis
    cd $TORNADE_DIR/deis
    git checkout -b tornade_$DEIS_VERSION $DEIS_VERSION
    cd $DIR
}


download_fleet() {
    print_ok "[-] Install Fleet $FLEET_VERSION"
    curl -fsSkL $FLEET_REPO/v$FLEET_VERSION/$FLEET_FILE -o /tmp/fleet-$FLEET_VERSION.tar.gz
    mkdir $TORNADE_DIR/fleet-$FLEET_VERSION
    tar zxf /tmp/fleet-$FLEET_VERSION.tar.gz --strip-components=1 -C $TORNADE_DIR/fleet-$FLEET_VERSION
    rm /tmp/fleet-$FLEET_VERSION.tar.gz
}


build_vagrant() {
    print_ok "[-] Build VM"
    vagrant up
    ssh-add $HOME/.vagrant.d/insecure_private_key
}

make_deis() {
    print_ok "[-] Build Deis"
    make pull
    make build
    make run
}

install_deis_client() {
    print_ok "[-] Install Deis client"
    sudo pip install deis
}


register_tornade() {
    deis register http://tornade.deisapp.com:8000
    deis keys:add
    deis clusters:create dev tornade.deisapp.com \
         --hosts=tornade.deisapp.com \
         --auth=~/.vagrant.d/insecure_private_key
    print_ok "Tornade is ready."
    print_ok "Create an application using : "
    print_ok "   $ deis create ...."
    print_ok "Then push it to Deis: "
    print_ok "   $ git push deis master"
}


case $1 in
    "build")
        check_tornade
        download_deis
        download_fleet
        install_deis_client
        build_vagrant
        make_deis
        ;;
    *)
        usage
        ;;
esac
