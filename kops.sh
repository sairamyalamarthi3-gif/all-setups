## Download kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

## Install Kops
wget https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops

## S3 Bucket Setup
aws s3api create-bucket --bucket sair.project.flm.k8s.local --region us-east-1
aws s3api put-bucket-versioning --bucket sair.project.flm.k8s.local --region us-east-1 --versioning-configuration Status=Enabled

## Export State Store
export KOPS_STATE_STORE=s3://sair.project.flm.k8s.local

## Create Cluster
kops create cluster \
  --name sairam.k8s.local \
  --zones us-east-1a,us-east-1b \
  --control-plane-count 1 \
  --control-plane-size c7i-flex.large \
  --control-plane-volume-size 30 \
  --node-count 3 \
  --node-size t2.medium \
  --node-volume-size 20

## Update Cluster
kops update cluster --name sairam.k8s.local --yes --admin
