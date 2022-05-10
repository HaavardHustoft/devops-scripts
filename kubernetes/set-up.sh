#!bin/bash

name=$(hostname)
ip=$(hostname -I | head -n1 | cut -d " " -f1)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update

sudo kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.22/deploy/local-path-storage.yaml
sudo kubectl patch storageclass local-path -n jupyter -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
sudo kubectl taint nodes $name node-role.kubernetes.io/control-plane-
sudo kubectl taint nodes $name node-role.kubernetes.io/master-
sudo helm upgrade --cleanup-on-fail   --install jupyterhub jupyterhub/jupyterhub   --namespace jupyter   --create-namespace   --version=1.2.0   --values config.yaml
