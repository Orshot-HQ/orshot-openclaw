---
name: orshot-carousel
description: "TikTok carousel, Instagram carousel and LinkedIn carousel generator from a template with Orshot. Also a TikTok slideshow maker: photo carousels, slideshows, swipe posts and TikTok photo mode posts. Six slides with a hook on slide one and a CTA on the last, brand fonts and colors, text overlays laid out by the template instead of hand-written canvas code, rendered in one call and posted as a draft through Orshot or handed to Postiz. Use when a user wants carousel posts, slideshow posts, a carousel generator, or an agent that produces slides on a schedule and learns from views."
homepage: https://orshot.com/agents/openclaw
license: MIT-0
metadata:
  author: Orshot
  version: "1.0.0"
  openclaw:
    emoji: "🎠"
    homepage: https://orshot.com/agents/openclaw
    primaryEnv: ORSHOT_API_KEY
    requires:
      env: []
      bins: []
    envVars:
      - name: ORSHOT_API_KEY
        required: false
        description: Orshot API key. Only for REST. Not needed over the hosted MCP server with OAuth.
---

# Orshot Carousel: six slides, one call

A carousel (TikTok calls it a photo carousel or slideshow, Instagram and LinkedIn call it a carousel) is six images with the same layout and different words. That is a template render, not an image-editing job. The template holds the fonts, colors, safe zones and text sizing once; every post only sends six lines of copy and six background images. No node-canvas, no font files, no overlay code.

## Setup

1. Connect the Orshot MCP server (no key): `openclaw mcp add orshot --url https://mcp.orshot.com/mcp --transport streamable-http --auth oauth` then `openclaw mcp login orshot`. Headless jobs can use `ORSHOT_API_KEY` over REST instead. Details in the `orshot` skill.
2. Pick a carousel template: an Orshot studio template with 6 pages, each `1080x1920` (TikTok, Reels, Stories) or `1080x1350` (Instagram and LinkedIn carousels). `orshot_list_studio_templates` with a search for "carousel". If the workspace has none, create one (below).
3. Decide where it posts: Orshot social accounts (`orshot_list_social_accounts`) or Postiz.

## The 6-slide formula

```
Slide 1  Hook, full sentence, biggest text, never split across slides
Slide 2  The problem the viewer has
Slide 3  The discovery or the turn
Slide 4  Proof 1 (number, screenshot, quote)
Slide 5  Proof 2 or the how
Slide 6  CTA (follow, link in bio, app name)
```

Hook rule: person + doubt or conflict + specific detail beats a feature line. "my trainer asked me to log a week of meals, she wasn't ready" beats "track calories in seconds".

## Template rules (bake these into the template, not into the agent)

- **Safe zones for 1080x1920:** keep text between 15% and 80% of the height. TikTok's status bar covers the top, its caption and buttons cover the bottom 20%, the right 15% holds the action rail.
- **Text:** one text layer per slide, `parameterId` `page1@text` through `page6@text`, `textMode: "fit"` with a `minFontSize`, starting size about 6.5% of the height (70px on 1920), bold, line height 1.2, centered, max width 75% of the canvas. White fill with a dark stroke or a dark translucent box behind it so it reads on any photo.
- **Background:** one image layer per slide with `objectFit: "cover"`, `parameterId` `page1@image` through `page6@image`. Optional dark gradient overlay at 30% so text stays legible.
- **Brand:** fonts and colors from the brand kit (`orshot_get_brand_kit`), logo small on slide 6 only.
- **Consistency:** same layout on all six pages. Only the words and photos change.

## Create the template if none exists

Over MCP, read `orshot://template-design-spec`, then `orshot_create_template_design` with a six-page `pages_data` that follows the rules above and `includeThumbnails: true`. Name it "Carousel 6 (TikTok)" or "Carousel 6 (Instagram)". Over REST use `POST /v1/studio/templates/create` with the same `pages_data`. Keep the template; reuse it for every post. The `orshot-social-media-content` skill holds the craft rules.

## Render the carousel

`orshot_render_template` over MCP takes the same body.

```bash
curl -s -X POST https://api.orshot.com/v1/studio/render \
  -H "Authorization: Bearer $ORSHOT_API_KEY" -H "Content-Type: application/json" \
  -d '{
    "templateId": 123,
    "modifications": {
      "page1@text": "nobody told me the 3pm slump was my breakfast",
      "page1@image": "https://.../1.jpg",
      "page2@text": "I was eating 60g of sugar before 9am",
      "page2@image": "https://.../2.jpg",
      "page3@text": "then I logged one week, every meal",
      "page3@image": "https://.../3.jpg",
      "page4@text": "swapped the juice, kept the toast",
      "page4@image": "https://.../4.jpg",
      "page5@text": "two weeks later the slump was gone",
      "page5@image": "https://.../5.jpg",
      "page6@text": "the app is free, link in bio",
      "page6@image": "https://.../6.jpg"
    },
    "response": { "type": "url", "format": "png" }
  }'
```

The response `data` is an array of six `{ page, content }` URLs in order. Background images come from the brand kit, stock search (`orshot_search_stock_media`), an image model the user already pays for, or the user's own folder. Any public URL works.

## Post it

**Through Orshot (one call, no second tool):** add `publish` to the render request. Six pages post as a photo carousel on TikTok, Instagram, LinkedIn, Threads and Bluesky.

```json
"publish": {
  "accounts": [7],
  "content": "caption with the hook repeated #hashtags",
  "status": "draft",
  "tiktokSettings": { "autoAddMusic": true }
}
```

Keep `status: "draft"` until the user has seen the six slides (`orshot_get_social_post` shows them as a card). Then `orshot_publish_social_draft`, or schedule it with `orshot_update_social_post` and `status: "scheduled"`. No accounts connected yet? The user connects them in the Orshot dashboard (Workspace > Socials > Accounts); it is a paid add-on, see the `orshot-social-media-scheduler` skill.

**Through Postiz:** download the six URLs, `postiz upload` each file, then `postiz posts:create` with `-m` for every uploaded URL and the TikTok privacy set to draft (SELF_ONLY). Postiz needs media uploaded to Postiz first; external URLs are rejected there.

## Learning loop

Daily, for posts made through Orshot: `orshot_get_social_analytics` with `source: "orshot"`, sort by impressions and engagement, and compare hooks.

- High views, low saves or clicks: wrong audience or weak CTA, change slide 6.
- Low views: change the hook style on slide 1 (question, confession, number).
- Same hook style wins three times: make it the default and rotate the proof slides instead.

Keep a short log the user can read: date, hook, views, change made.

## Safety

- Never publish without the user seeing the slides. Drafts are free; a wrong post is not.
- Confirm the account (platform and username) and the caption before sending.
- Say how many credits a batch costs before rendering more than ten posts.

## Gotchas

1. Six pages means six `pageN@` prefixes. A bare `text` key only changes slide 1.
2. Keep every slide's text under about 20 words so the fit mode does not shrink it unreadably.
3. The response is an array for multi-page templates. Read `data[i].content`.
4. TikTok rejects single images and PDFs; a photo carousel needs 2 to 35 images.
5. Reuse one template. Creating a new template per post is slow and spends design effort twice.
6. Photos must be public URLs. Render URLs from Orshot are.

Related skills: `orshot` (API and render details), `orshot-social-media-scheduler` (scheduling and analytics), `orshot-social-media-content` (designing the template well).
