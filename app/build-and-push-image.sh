#!/bin/bash

set -euo pipefail

ECR_REPO_NAME="$1"
AWS_ACCOUNT_ID="$2"
AWS_REGION="$3"

IMAGE_TAG="latest"
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE_NAME="${ECR_URI}/${ECR_REPO_NAME}:${IMAGE_TAG}"

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <ecr-repo-name> <aws-account-id> <aws-region>"
  exit 1
fi

echo "▶ Logging into Amazon ECR..."
aws ecr get-login-password --region "${AWS_REGION}" \
  | docker login --username AWS --password-stdin "${ECR_URI}"

echo "▶ Building Docker image..."
docker build -t "${ECR_REPO_NAME}:${IMAGE_TAG}" .

echo "▶ Tagging image..."
docker tag "${ECR_REPO_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}"

echo "▶ Pushing image to ECR..."
docker push "${IMAGE_NAME}"

echo "✅ Image pushed successfully!"
echo "➡ ${IMAGE_NAME}"
