# Deployment Guide

This guide covers deploying ThreatLvl Games documentation across multiple environments.

## Architecture

- **Dev:** GitHub Pages (gh-pages-dev branch) - Quick iteration
- **Testing:** GitHub Pages (gh-pages-testing branch) - QA/Testing
- **Staging:** AWS S3 + CloudFront (Optional) - Pre-production
- **Production:** GCP Cloud Storage + Cloud CDN (Optional) - Live site

## Prerequisites

### AWS CLI Setup
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure credentials
aws configure
```

### GCP CLI Setup
```bash
# Install gcloud CLI
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Initialize and authenticate
gcloud init
gcloud auth application-default login
```

## Initial Setup

### GitHub Pages (Dev & Testing) Setup

1. **Enable GitHub Pages in repository settings:**
   - Go to repository Settings > Pages
   - Source: Deploy from a branch
   - Branch: `gh-pages-dev` (for dev) or `gh-pages-testing` (for testing)
   - Folder: `/ (root)`

2. **First deployment creates the branch automatically:**
```bash
./deploy.sh dev
# or
./deploy.sh testing
```

3. **Access URLs:**
   - Dev: `https://[username].github.io/threatlvl.games/`
   - Testing: Configure as second GitHub Pages site or use gh-pages-testing branch

**Note:** GitHub Pages only allows one active deployment per repository by default. For multiple environments:
- Option A: Use different branches (gh-pages-dev for dev)
- Option B: Fork repository for testing environment
- Option C: Use GitHub Pages + custom domains

### AWS S3 (Staging) Setup

1. **Create S3 Bucket:**
```bash
aws s3 mb s3://threatlvl-staging --region us-east-1
```

2. **Configure for website hosting:**
```bash
aws s3 website s3://threatlvl-staging \
  --index-document index.html \
  --error-document 404.html
```

3. **Set bucket policy (public read):**
```bash
cat > bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::threatlvl-staging/*"
  }]
}
EOF

aws s3api put-bucket-policy \
  --bucket threatlvl-staging \
  --policy file://bucket-policy.json
```

4. **Optional: Create CloudFront Distribution:**
```bash
aws cloudfront create-distribution \
  --origin-domain-name threatlvl-staging.s3-website-us-east-1.amazonaws.com \
  --default-root-object index.html
```

### GCP Cloud Storage (Production) Setup

1. **Create Storage Bucket:**
```bash
gsutil mb gs://threatlvl.games
```

2. **Make bucket publicly readable:**
```bash
gsutil iam ch allUsers:objectViewer gs://threatlvl.games
```

3. **Configure as website:**
```bash
gsutil web set -m index.html -e 404.html gs://threatlvl.games
```

4. **Optional: Set up Load Balancer with Cloud CDN:**
```bash
# Create backend bucket
gcloud compute backend-buckets create threatlvl-backend \
  --gcs-bucket-name=threatlvl.games \
  --enable-cdn

# Create URL map
gcloud compute url-maps create threatlvl-cdn \
  --default-backend-bucket=threatlvl-backend

# Create HTTP(S) proxy
gcloud compute target-http-proxies create threatlvl-http-proxy \
  --url-map=threatlvl-cdn

# Create forwarding rule
gcloud compute forwarding-rules create threatlvl-http-rule \
  --global \
  --target-http-proxy=threatlvl-http-proxy \
  --ports=80
```

## Domain Configuration

### AWS Route 53 (for staging.threatlvl.games)

```bash
# Create hosted zone
aws route53 create-hosted-zone --name staging.threatlvl.games

# Add CNAME record pointing to S3 or CloudFront
aws route53 change-resource-record-sets \
  --hosted-zone-id YOUR_ZONE_ID \
  --change-batch file://staging-dns.json
```

### GCP Cloud DNS (for threatlvl.games)

```bash
# Create DNS zone
gcloud dns managed-zones create threatlvl \
  --dns-name=threatlvl.games \
  --description="ThreatLvl Games production domain"

# Add A record
gcloud dns record-sets create threatlvl.games. \
  --zone=threatlvl \
  --type=A \
  --ttl=300 \
  --rrdatas=YOUR_LOAD_BALANCER_IP
```

## Deployment

### Quick Deploy

```bash
# Make deploy script executable
chmod +x deploy.sh

# Deploy to dev (GitHub Pages - fastest, for quick testing)
./deploy.sh dev

# Deploy to testing (GitHub Pages - QA environment)
./deploy.sh testing

# Deploy to staging (AWS - pre-production)
./deploy.sh staging

# Deploy to production (GCP - live site)
./deploy.sh production
```

### Deployment Flow

Recommended workflow:
1. **Dev** → Test locally, deploy to dev branch for quick review
2. **Testing** → QA team validates on testing branch
3. **Staging** → Final checks in AWS environment
4. **Production** → Deploy to GCP when all tests pass

```bash
# Example workflow
git checkout feature-branch
zola serve  # Test locally

./deploy.sh dev  # Quick deploy to GitHub Pages dev

# After code review
./deploy.sh testing  # QA testing

# After QA approval
./deploy.sh staging  # Pre-production check

# After final approval
./deploy.sh production  # Live deployment
```

### Manual Deployment

**Dev (GitHub Pages):**
```bash
# Build
zola build

# Deploy to gh-pages-dev branch
git checkout -B gh-pages-dev
cp -r public/* .
git add -f *.html *.css *.js docs/ blog/
git commit -m "Deploy dev build"
git push -f origin gh-pages-dev
git checkout main
```

**Testing (GitHub Pages):**
```bash
# Build
zola build

# Deploy to gh-pages-testing branch
git checkout -B gh-pages-testing
cp -r public/* .
git add -f *.html *.css *.js docs/ blog/
git commit -m "Deploy testing build"
git push -f origin gh-pages-testing
git checkout main
```

**Staging (AWS):**
```bash
# Build
zola build

# Upload to S3
aws s3 sync public/ s3://threatlvl-staging --delete --acl public-read

# Invalidate CloudFront (if using)
aws cloudfront create-invalidation \
  --distribution-id YOUR_DIST_ID \
  --paths "/*"
```

**Production (GCP):**
```bash
# Build
zola build

# Upload to GCS
gsutil -m rsync -r -d public/ gs://threatlvl.games

# Invalidate CDN cache (if using)
gcloud compute url-maps invalidate-cdn-cache threatlvl-cdn --path "/*"
```

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches:
      - main        # Production
      - staging     # Staging

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Install Zola
        run: |
          wget https://github.com/getzola/zola/releases/download/v0.18.0/zola-v0.18.0-x86_64-unknown-linux-gnu.tar.gz
          tar xzf zola-v0.18.0-x86_64-unknown-linux-gnu.tar.gz
          sudo mv zola /usr/local/bin/
      
      - name: Build site
        run: zola build
      
      - name: Deploy to Staging (AWS)
        if: github.ref == 'refs/heads/staging'
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 sync public/ s3://threatlvl-staging --delete --acl public-read
      
      - name: Deploy to Production (GCP)
        if: github.ref == 'refs/heads/main'
        env:
          GCP_SA_KEY: ${{ secrets.GCP_SA_KEY }}
        run: |
          echo "$GCP_SA_KEY" | base64 -d > ${HOME}/gcp-key.json
          gcloud auth activate-service-account --key-file ${HOME}/gcp-key.json
          gsutil -m rsync -r -d public/ gs://threatlvl.games
```

## Cost Estimates

### GitHub Pages (Dev & Testing)
- **Cost:** FREE ✨
- **Bandwidth:** 100GB/month soft limit
- **Build time:** ~10 seconds (after push)
- **Best for:** Development and QA environments

### AWS (Staging)
- **S3 Storage:** $0.023/GB/month (~$0.05/month for docs site)
- **S3 Requests:** $0.0004 per 1,000 requests (~$0.10/month)
- **CloudFront (Optional):** $0.085/GB + $0.0075 per 10,000 requests
- **Total:** ~$1-3/month without CloudFront, ~$5-10/month with CloudFront

### GCP (Production)
- **Cloud Storage:** $0.020/GB/month (~$0.04/month for docs site)
- **Network Egress:** $0.12/GB (first 1TB)
- **Cloud CDN (Optional):** $0.08/GB + $0.0075 per 10,000 requests
- **Total:** ~$2-5/month without CDN, ~$10-20/month with CDN

## SSL/HTTPS

### AWS Certificate Manager (Free)
```bash
aws acm request-certificate \
  --domain-name staging.threatlvl.games \
  --validation-method DNS
```

### GCP Managed SSL (Free)
```bash
gcloud compute ssl-certificates create threatlvl-cert \
  --domains=threatlvl.games
```

## Monitoring

### AWS CloudWatch
```bash
# Enable S3 bucket metrics
aws s3api put-bucket-metrics-configuration \
  --bucket threatlvl-staging \
  --id EntireBucket \
  --metrics-configuration '{}'
```

### GCP Cloud Monitoring
```bash
# Metrics automatically available in Cloud Console
gcloud monitoring dashboards create \
  --config-from-file=monitoring-dashboard.json
```

## Rollback Strategy

### Quick Rollback
```bash
# AWS - Use S3 versioning
aws s3api put-bucket-versioning \
  --bucket threatlvl-staging \
  --versioning-configuration Status=Enabled

# GCP - Use object versioning
gsutil versioning set on gs://threatlvl.games

# Restore previous version
gsutil cp gs://threatlvl.games/index.html#version_id gs://threatlvl.games/index.html
```

## Troubleshooting

### Check deployment status
```bash
# AWS
aws s3 ls s3://threatlvl-staging/

# GCP
gsutil ls -l gs://threatlvl.games/
```

### View logs
```bash
# AWS CloudFront logs
aws logs tail /aws/cloudfront/threatlvl --follow

# GCP Load Balancer logs
gcloud logging read "resource.type=http_load_balancer"
```

## Security Best Practices

1. **Use IAM roles with minimum required permissions**
2. **Enable versioning on both S3 and GCS**
3. **Configure CORS if needed:**
   ```bash
   # AWS
   aws s3api put-bucket-cors --bucket threatlvl-staging --cors-configuration file://cors.json
   
   # GCP
   gsutil cors set cors.json gs://threatlvl.games
   ```
4. **Enable access logging:**
   ```bash
   # AWS
   aws s3api put-bucket-logging --bucket threatlvl-staging --bucket-logging-status file://logging.json
   
   # GCP
   gsutil logging set on -b gs://threatlvl-logs gs://threatlvl.games
   ```

## Support

For deployment issues:
- AWS Support: https://console.aws.amazon.com/support
- GCP Support: https://console.cloud.google.com/support
- Project Issues: https://github.com/djpost/threatlvl.games/issues

