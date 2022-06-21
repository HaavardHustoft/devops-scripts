#!bin/bash
ip=$(hostname -I | head -n1 | cut -d " " -f1)
cert=$(sudo cat /etc/kubernetes/admin.conf | grep "certificate-authority")
server=$(sudo cat /etc/kubernetes/admin.conf | grep "server")

sudo mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create namespace jupyter

sudo sh ./devops-scripts/kubernetes/add-user.sh -u tim
sudo sh ./devops-scripts/kubernetes/add-user.sh -u alice
sudo sh ./devops-scripts/kubernetes/add-user.sh -u janet

sudo sed -i "4s/.*/$cert/" /home/tim/.kube/config
sudo sed -i "5s/.*/    server: https:\/\/$ip:6443/" /home/tim/.kube/config

sudo sed -i "4s/.*/$cert/" /home/janet/.kube/config
sudo sed -i "5s/.*/    server: https:\/\/$ip:6443/" /home/janet/.kube/config

sudo sed -i "4s/.*/$cert/" /home/alice/.kube/config
sudo sed -i "5s/.*/    server: https:\/\/$ip:6443/" /home/alice/.kube/config

sudo kubectl apply -f devops-scripts/kubernetes/rolebindings
