#!/bin/bash

# Clone repository
git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" --branch gh-pages --single-branch gh-pages
cp -r _build/* gh-pages
cp favicon.ico gh-pages/

# Deploy to GitHub Pages
cd gh-pages
touch .nojekyll
# Official github-actions[bot] noreply email (user ID 41898282) so commits are attributed to the bot in the GitHub UI
git config --local user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --local user.name "GitHub Actions"
git add .
git commit -m "Publish docs" || true
git push origin gh-pages --force-with-lease
