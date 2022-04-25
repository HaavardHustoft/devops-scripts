#!bin/bash

ip=$(ifconfig ens3 | grep "inet " | grep -E -o  "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | head -1 )
name=$(hostname)
echo "10.0.67.226 master2 puppet" >> /etc/hosts
echo "$ip $name" >> /etc/hosts

apt update
apt install wget -y

wget https://apt.puppetlabs.com/puppet7-release-focal.deb 


dpkg -i puppet7-release-focal.deb
apt update
apt install puppet-agent -y

text="[main]"'\n'"certname = $name"'\n'"server = master2"
echo $text >> /etc/puppetlabs/puppet/puppet.conf
systemctl start puppet
systemctl enable puppet
