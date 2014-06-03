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
FLEET_REPO=https://github.com/coreos/fleet/releases/download/

export DOCKER_HOST=tcp://172.17.8.100:4243
export FLEETCTL_TUNNEL=172.17.8.100

check_tornade() {
    mkdir -p $TORNADE_DIR
}


download_deis() {
    echo "Download Deis"
    git clone $DEIS_REPO $TORNADE_DIR/deis
    git checkout -b tornade_$DEIS_VERSION $DEIS_VERSION
}


download_fleet() {
   echo "Install Fleet $FLEET_VERSION"
   curl -fsSkL $FLEET_REPO/v$FLEET_VERSION/$FLEET_FILE -o /tmp/fleet-$FLEET_VERSION.tar.gz
    tar zxf /tmp/fleet-$FLEET_VERSION.tar.gz -C $TORNADE_DIR
    rm /tmp/fleet-$FLEET_VERSION.tar.gz
}


build_vagrant() {
    echo "Build VM"
    vagrant up
    ssh-add $HOME/.vagrant.d/insecure_private_key
}

make_deis() {
    echo "Build Deis"
    make pull
    make build
    make run
}

install_deis_client() {
    echo "Install Deis client"
    sudo pip install deis
}


register_tornade() {
    deis register http://tornade.deisapp.com:8000
    deis keys:add
    deis clusters:create dev tornade.deisapp.com \
         --hosts=tornade.deisapp.com \
         --auth=~/.vagrant.d/insecure_private_key
    echo "Tornade is ready."
    echo "Create an application using : "
    echo "   $ deis create ...."
    echo "Then push it to Deis: "
    echo "   $ git push deis master"

}
