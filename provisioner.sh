#!/bin/bash
hostname=${1}

if [[ $hostname =~ linux ]]
then
	echo "blah"
else
	sudo cp /vagrant/switch-config/netd.conf /etc/netd.conf
	sudo systemctl restart netd.service
	sudo cp /vagrant/switch-config/daemon* /etc/frr/
	sudo cp /vagrant/switch-config/${hostname}-frr.conf /etc/frr/frr.conf
	sudo cp /vagrant/switch-config/${hostname}-interfaces /etc/network/interfaces
	sudo ifreload -a
	sudo systemctl restart frr.service
fi
