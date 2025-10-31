#!/bin/bash

# Deploy script for Nuxt static site
# Deploys to: root@161.35.27.246:/var/www/devwomen2025

set -e  # Exit on any error

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
  root@161.35.27.246:/var/www/devwomen2025/

echo "✅ Deployment complete!"
echo "🌐 Site should be live at your domain"
