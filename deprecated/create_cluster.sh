#!/bin/bash

#export AWS_PROFILE='bjs'
#export AWS_DEFAULT_REGION='cn-north-1'
#export AWS_REGION=${AWS_DEFAULT_REGION}
#export KOPS_STATE_STORE=s3://pahud-kops-state-store

# Because "aws configure" doesn't export these vars for kops to use, we export them now
#export AWS_ACCESS_KEY_ID=$(aws --profile=$AWS_PROFILE configure get aws_access_key_id)
#export AWS_SECRET_ACCESS_KEY=$(aws --profile=$AWS_PROFILE configure get aws_secret_access_key)

source env.config

cluster_name='cluster.bjs.k8s.local'

# official CoreOS AMI
ami='ami-555a8438'
vpcid='vpc-c1e040a5'

KUBERNETES_VERSION='v1.9.6'
kubernetesVersion="https://s3.cn-north-1.amazonaws.com.cn/kubernetes-release/release/$KUBERNETES_VERSION"
export CNI_VERSION_URL="https://s3.cn-north-1.amazonaws.com.cn/kubernetes-release/network-plugins/cni-plugins-amd64-v0.6.0.tgz"

kops create cluster \
     --name=${cluster_name} \
     --image=${ami} \
     --zones=cn-north-1a,cn-north-1b \
     --master-count=3 \
     --master-size="m3.medium" \
     --node-count=2 \
     --node-size="m3.medium"  \
     --vpc=${vpcid} \
     --kubernetes-version="$kubernetesVersion" \
     --ssh-public-key="~/.ssh/id_rsa.pub"
