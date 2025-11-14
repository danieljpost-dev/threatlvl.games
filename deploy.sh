#!/bin/bash
set -e

# ThreatLvl Games Deployment Script
# Usage: ./deploy.sh [dev|testing|staging|production]

ENVIRONMENT=${1:-dev}

echo "🚀 Deploying to $ENVIRONMENT environment..."

# Build the site
echo "📦 Building site with Zola..."
zola build

# Deploy based on environment
case $ENVIRONMENT in
  dev)
    echo "🔧 Deploying to GitHub Pages (Dev Branch)..."
    
    # Store current branch
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    
    # Create or checkout gh-pages-dev branch
    git checkout -B gh-pages-dev
    
    # Copy built files to root
    cp -r public/* .
    
    # Add and commit
    git add -f *.html *.css *.js docs/ blog/ search_index.* elasticlunr.min.js 2>/dev/null || true
    git commit -m "Deploy dev build - $(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
    
    # Push to GitHub
    git push -f origin gh-pages-dev
    
    # Return to original branch
    git checkout $CURRENT_BRANCH
    
    echo "✅ Dev deployed: https://[username].github.io/threatlvl.games/dev"
    echo "   Configure in repo Settings > Pages > gh-pages-dev branch"
    ;;
    
  testing)
    echo "🧪 Deploying to GitHub Pages (Testing Branch)..."
    
    # Store current branch
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    
    # Create or checkout gh-pages-testing branch
    git checkout -B gh-pages-testing
    
    # Copy built files to root
    cp -r public/* .
    
    # Add and commit
    git add -f *.html *.css *.js docs/ blog/ search_index.* elasticlunr.min.js 2>/dev/null || true
    git commit -m "Deploy testing build - $(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
    
    # Push to GitHub
    git push -f origin gh-pages-testing
    
    # Return to original branch
    git checkout $CURRENT_BRANCH
    
    echo "✅ Testing deployed: https://[username].github.io/threatlvl.games/testing"
    echo "   Configure in repo Settings > Pages > gh-pages-testing branch"
    ;;
  
  staging)
    echo "🔧 Deploying to AWS S3 (Staging)..."
    aws s3 sync public/ s3://threatlvl-staging \
      --delete \
      --cache-control "max-age=300" \
      --acl public-read
    
    # Invalidate CloudFront cache (if using CDN)
    if [ ! -z "$AWS_CLOUDFRONT_STAGING_ID" ]; then
      aws cloudfront create-invalidation \
        --distribution-id $AWS_CLOUDFRONT_STAGING_ID \
        --paths "/*"
    fi
    
    echo "✅ Staging deployed: https://staging.threatlvl.games"
    ;;
    
  production)
    echo "🚀 Deploying to GCP Cloud Storage (Production)..."
    gsutil -m rsync -r -d -c public/ gs://threatlvl.games
    
    # Set cache control headers
    gsutil -m setmeta -h "Cache-Control:public, max-age=3600" \
      gs://threatlvl.games/**/*.html
    gsutil -m setmeta -h "Cache-Control:public, max-age=31536000" \
      gs://threatlvl.games/**/*.{css,js,png,jpg,svg}
    
    # Invalidate CDN cache (if using Cloud CDN)
    if [ ! -z "$GCP_CDN_URL_MAP" ]; then
      gcloud compute url-maps invalidate-cdn-cache $GCP_CDN_URL_MAP \
        --path "/*"
    fi
    
    echo "✅ Production deployed: https://threatlvl.games"
    ;;
    
  *)
    echo "❌ Invalid environment. Use: 'dev', 'testing', 'staging', or 'production'"
    echo ""
    echo "Environments:"
    echo "  dev        - GitHub Pages (gh-pages-dev branch) - Quick iteration"
    echo "  testing    - GitHub Pages (gh-pages-testing branch) - QA/Testing"
    echo "  staging    - AWS S3 + CloudFront - Pre-production"
    echo "  production - GCP Cloud Storage + CDN - Live site"
    exit 1
    ;;
esac

echo "🎉 Deployment complete!"

