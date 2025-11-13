#!/bin/bash

# Deploy script for Nuxt static site
# Requires .deploy.config file with: DEPLOY_USER, DEPLOY_HOST, DEPLOY_PATH

set -e  # Exit on any error

# Load deployment configuration
source .deploy.config

if [ -z "$DEPLOY_USER" ] || [ -z "$DEPLOY_HOST" ] || [ -z "$DEPLOY_PATH" ]; then
  echo "❌ Error: Required environment variables not set"
  echo "Please set: DEPLOY_USER, DEPLOY_HOST, DEPLOY_PATH"
  exit 1
fi

echo "🚀 Starting deployment process..."

# Build the static site
echo "📦 Building static site..."
npm run generate

# Check if build was successful
if [ ! -d ".output/public" ]; then
  echo "❌ Error: Build output directory .output/public not found"
  exit 1
fi

# Deploy using rsync
echo "📤 Deploying to server..."
rsync -avz --delete \
  --exclude='.htaccess' \
  --exclude='.htpasswd' \
  .output/public/ \
  ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/

echo "✅ Deployment complete!"
echo "🌐 Site should be live at your domain"
