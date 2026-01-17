#!/bin/bash

# Exit on error
set -e

# Default values
VERSION=$(node -p "require('./package.json').version")
IMAGE_NAME="vkhangstack/logto"
TAG=${1:-$VERSION}
DOCKERFILE="Dockerfile"

echo "🚀 Building Logto Docker image..."
echo "📦 Version: $VERSION"
echo "🏷️  Tag: $TAG"
echo "📂 Context: $(pwd)"

# Determine build command and flags
if docker buildx version >/dev/null 2>&1; then
  BUILD_CMD="docker buildx build"
  # --load is needed for buildx to make the image available in local docker images
  LOAD_FLAG="--load"
else
  BUILD_CMD="docker build"
  LOAD_FLAG=""
fi

# Build the image
$BUILD_CMD \
  --build-arg dev_features_enabled="${DEV_FEATURES_ENABLED}" \
  --build-arg applicationinsights_connection_string="$APPLICATIONINSIGHTS_CONNECTION_STRING" \
  --build-arg additional_connector_args="$ADDITIONAL_CONNECTOR_ARGS" \
  -t "$IMAGE_NAME:$TAG" \
  -t "$IMAGE_NAME:latest" \
  -f "$DOCKERFILE" \
  $LOAD_FLAG \
  .

echo "✅ Build completed successfully!"
echo "🐳 Image: $IMAGE_NAME:$TAG"
echo "✨ To run with docker-compose, update the image tag in docker-compose.yml"
