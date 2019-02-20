#!/bin/bash
hostname=${1}

if [[ $hostname =~ linux ]]
then
        sudo apt-get update
        sudo apt-get -y install traceroute
        sudo apt-get -y install lldpd
        sudo ip route del default via 10.0.2.2
        sudo cp /vagrant/linux-config/${hostname}-netplan.yaml /etc/netplan/01-netcfg.yaml
        sudo netplan apply
else
	sudo cp /vagrant/switch-config/netd.conf /etc/netd.conf
	sudo systemctl restart netd.service
	sudo cp /vagrant/switch-config/daemon* /etc/frr/
	sudo cp /vagrant/switch-config/${hostname}-frr.conf /etc/frr/frr.conf
	sudo cp /vagrant/switch-config/${hostname}-interfaces /etc/network/interfaces
	sudo ifreload -a
	sudo systemctl restart frr.service
fi
