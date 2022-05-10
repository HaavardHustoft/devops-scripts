#!bin/bash
ip=$(hostname -I | head -n1 | cut -d " " -f1)
cert=$(sudo cat /etc/kubernetes/admin.conf | grep "certificate-authority")
server=$(sudo cat /etc/kubernetes/admin.conf | grep "server")

sudo sed -i "4s/.*/$cert/" /home/tim/.kube/config
sudo sed -i "5s/.*/    server: https:\/\/$ip:6443/" /home/tim/.kube/config

sudo sed -i "4s/.*/$cert/" /home/janet/.kube/config
sudo sed -i "5s/.*/    server: https:\/\/$ip:6443/" /home/janet/.kube/config

sudo sed -i "4s/.*/$cert/" /home/alice/.kube/config
sudo sed -i "5s/.*/    server: https:\/\/$ip:6443/" /home/alice/.kube/config

sudo kubectl apply -f devops-scripts/kubernetes/rolebindings