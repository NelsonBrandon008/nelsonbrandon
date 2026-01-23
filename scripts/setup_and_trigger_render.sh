#!/usr/bin/env bash
set -euo pipefail

REPO="NelsonBrandon008/nelsonbrandon"

echo "This script will set two GitHub repository secrets (RENDER_API_KEY and RENDER_SERVICE_ID)"
echo "using the GitHub CLI (gh), and then push an empty commit to trigger CI/deploy."
echo
if ! command -v gh >/dev/null 2>&1; then
  echo "Error: gh (GitHub CLI) is not installed or not in PATH."
  echo "Install it and authenticate (gh auth login) first: https://cli.github.com/"
  exit 1
fi

read -r -p "Proceed and set secrets for repo $REPO? [y/N] " proceed
if [[ "$proceed" != "y" && "$proceed" != "Y" ]]; then
  echo "Aborted by user."
  exit 0
fi

echo
echo "Enter your Render API Key (it will be hidden while typing):"
stty -echo
read -r RENDER_API_KEY
stty echo
echo

read -r -p "Enter the Render Service ID (e.g. srv-abc123): " RENDER_SERVICE_ID
echo

echo "Setting GitHub secret RENDER_API_KEY..."
gh secret set RENDER_API_KEY --body "$RENDER_API_KEY" --repo "$REPO"

echo "Setting GitHub secret RENDER_SERVICE_ID..."
gh secret set RENDER_SERVICE_ID --body "$RENDER_SERVICE_ID" --repo "$REPO"

echo "Creating an empty commit to trigger CI/deploy..."
git commit --allow-empty -m "ci: trigger deploy (via setup script)" || true
git push origin main

echo
echo "Done. The workflow should start shortly. Check Actions here:"
echo "https://github.com/$REPO/actions"
echo
echo "If you'd like, paste the Actions run URL here and I'll watch it and verify the Render deploy and live site." 
