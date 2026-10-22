#!/usr/bin/env bash
# Publish every skill in skills/ to ClawHub at the version in its SKILL.md frontmatter.
# Skips a skill when that version is already on ClawHub. Pass --dry-run to only print.
#
# Needs: clawhub CLI (npm install -g clawhub@0.23.3) and a login (clawhub login).
# Display names below carry the phrases people search for on ClawHub; keep them in sync
# with the frontmatter descriptions. ClawHub allows at most 5 topics per skill.
set -euo pipefail

cd "$(dirname "$0")/.."

OWNER="${CLAWHUB_OWNER:-orshot}"
CLAWHUB="${CLAWHUB:-$(command -v clawhub || echo "npx -y clawhub@0.23.3")}"
REPO="Orshot-HQ/orshot-openclaw"
COMMIT="$(git rev-parse HEAD 2>/dev/null || echo uncommitted)"
REF="$(git describe --tags --exact-match 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)"
DRY_RUN=""
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN="--dry-run"

if [[ -n "$(git status --porcelain)" && -z "$DRY_RUN" ]]; then
  echo "Working tree is not clean. Commit first so provenance points at a real commit." >&2
  exit 1
fi

display_name() {
  case "$1" in
    orshot) echo "Orshot: Automate video, PDF and image generation from templates and social media posting (OG images, social media posts, carousels, thumbnails, invoices, certificates)" ;;
    orshot-social-media-scheduler) echo "Orshot Social Media Scheduler: schedule posts, post to Instagram, LinkedIn, X, TikTok, Facebook, Pinterest, Threads, Bluesky, Reddit, YouTube, Telegram, Snapchat and Google Business from templates" ;;
    orshot-carousel) echo "Orshot Carousel Generator: TikTok carousel, Instagram carousel, LinkedIn carousel and TikTok slideshow maker from a template" ;;
    orshot-social-media-content) echo "Orshot Social Media Content Generator: design Instagram post, LinkedIn post, TikTok, story, ad and carousel templates on brand" ;;
    *) echo "$1" ;;
  esac
}


# ClawHub category slugs (max 3): integrations, automation, research, development, productivity,
# communication, creative, knowledge, agents, operations, security, finance, lifestyle, other.
categories() {
  case "$1" in
    orshot) echo "creative,automation,integrations" ;;
    orshot-social-media-scheduler) echo "communication,automation,productivity" ;;
    orshot-carousel) echo "creative,communication,automation" ;;
    orshot-social-media-content) echo "creative,productivity,automation" ;;
  esac
}

topics() {
  case "$1" in
    orshot) echo "image-generation,pdf-generation,video-generation,templates,social-media" ;;
    orshot-social-media-scheduler) echo "social-media-scheduler,social-media-automation,schedule-posts,instagram,linkedin" ;;
    orshot-carousel) echo "carousel,tiktok-carousel,instagram-carousel,linkedin-carousel,tiktok-slideshow" ;;
    orshot-social-media-content) echo "social-media-content,instagram-post,linkedin-post,social-media-design,content-creation" ;;
  esac
}

for dir in skills/*/; do
  slug="$(basename "$dir")"
  version="$(sed -n 's/^  version: "\(.*\)"/\1/p' "$dir/SKILL.md" | head -1)"
  [[ -z "$version" ]] && { echo "$slug: no metadata.version in frontmatter" >&2; exit 1; }

  published="$(curl -sf "https://clawhub.ai/api/v1/skills/$slug" | sed -n 's/.*"latestVersion":{"version":"\([^"]*\)".*/\1/p' || true)"
  if [[ "$published" == "$version" ]]; then
    echo "$slug $version already published, skipping"
    continue
  fi

  changelog="$(awk -v s="### $slug $version" '$0==s{f=1;next} f&&/^### /{exit} f&&/^- /{print}' CHANGELOG.md | sed 's/^- //' | paste -sd ';' -)"
  [[ -z "$changelog" ]] && changelog="Version $version"

  echo "publishing $slug $version (was ${published:-unpublished})"
  $CLAWHUB skill publish "$dir" \
    --slug "$slug" \
    --name "$(display_name "$slug")" \
    --owner "$OWNER" \
    --version "$version" \
    --changelog "$changelog" \
    --categories "$(categories "$slug")" \
    --topics "$(topics "$slug")" \
    --source-repo "$REPO" \
    --source-commit "$COMMIT" \
    --source-ref "$REF" \
    --source-path "$dir" \
    $DRY_RUN
done

[[ -n "$DRY_RUN" ]] && exit 0
echo
echo "Audit reports:"
for dir in skills/*/; do
  slug="$(basename "$dir")"
  version="$(sed -n 's/^  version: "\(.*\)"/\1/p' "$dir/SKILL.md" | head -1)"
  echo "  $CLAWHUB scan --slug $slug --version $version --json"
done
