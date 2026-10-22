#!/usr/bin/env bash
# Publish the bundle plugin (openclaw.plugin.json + skills + hosted MCP server) to ClawHub
# as @orshot/orshot. Bump "version" in openclaw.plugin.json and package.json first.
# Pass --dry-run to only print.
set -euo pipefail
cd "$(dirname "$0")/.."
OWNER="${CLAWHUB_OWNER:-orshot}"
CLAWHUB="${CLAWHUB:-$(command -v clawhub || echo "npx -y clawhub@0.23.3")}"
VERSION="$(python3 -c 'import json;print(json.load(open("openclaw.plugin.json"))["version"])')"
COMMIT="$(git rev-parse HEAD 2>/dev/null || echo uncommitted)"
REF="$(git describe --tags --exact-match 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
if [[ -n "$(git status --porcelain)" && "${1:-}" != "--dry-run" ]]; then
  echo "Working tree is not clean. Commit first so provenance points at a real commit." >&2; exit 1
fi
$CLAWHUB package validate . --out /tmp/orshot-plugin-reports >/dev/null
$CLAWHUB package publish . \
  --family bundle-plugin \
  --name orshot \
  --display-name "Orshot: Automate video, PDF and image generation from templates and social media posting" \
  --owner "$OWNER" \
  --version "$VERSION" \
  --changelog "Bundle plugin $VERSION: hosted Orshot MCP server (OAuth) plus the orshot, orshot-social-media-scheduler, orshot-carousel and orshot-social-media-content skills" \
  --categories media \
  --topics "image-generation,pdf-generation,video-generation,social-media-scheduler,mcp" \
  --source-repo Orshot-HQ/orshot-openclaw \
  --source-commit "$COMMIT" \
  --source-ref "$REF" \
  ${1:-}
