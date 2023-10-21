#!/bin/bash
set -e -o pipefail

echo "Fetching IAM github-action-user ARN"
userarn=$(aws iam get-user --user-name github-action-user | jq -r .User.Arn)

# Download tool for manipulating aws-auth
echo "Downloading tool..."
curl -Lo aws-iam-authenticator.exe https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.11/aws-iam-authenticator_0.6.11_windows_amd64.exe
chmod +x aws-iam-authenticator.exe

echo "Updating permissions"
./aws-iam-authenticator.exe add user --userarn="${userarn}" --username=github-action-role --groups=system:masters --kubeconfig="$HOME"/.kube/config --prompt=false

echo "Cleaning up"
rm aws-iam-authenticator.exe
echo "Done!"