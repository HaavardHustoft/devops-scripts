#!bin/bash
# Script source: https://computingforgeeks.com/deploy-kubernetes-cluster-on-ubuntu-with-kubeadm/
apt update
apt -y full-upgrade
[ -f /var/run/reboot-required ] && reboot -f

apt -y install curl apt-transport-https gnupg
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt update
apt -y install vim git curl wget kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Enable kernel modules
modprobe overlay
modprobe br_netfilter

# Add some settings to sysctl
tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sysctl --system


# Install Docker
apt update
apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y containerd.io docker-ce docker-ce-cli
mkdir -p /etc/systemd/system/docker.service.d

tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

systemctl daemon-reload 
systemctl restart docker
systemctl enable docker