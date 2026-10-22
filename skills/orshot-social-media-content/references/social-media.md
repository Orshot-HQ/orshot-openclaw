# Social Media Design Pack (2026)

For posts / stories / carousels. **Follows the general craft rules in SKILL.md**: the
shape→inherit→build→critique workflow, 2-font rule, 60-30-10 color, brand-first, variety,
and compatibility rules all apply. This pack adds only the social-specific formats,
archetypes, and a concrete recipe.

## 1. Formats & safe areas
- **Default: 4:5 portrait, 1080×1350.** Portrait dominates the 2026 feed + grid.
- Story / Reel / TikTok: 1080×1920. Keep text/CTAs inside the middle ~80%, the top
  ~250px and bottom ~320px are covered by platform UI.
- Square: 1080×1080.
- Edge margin: keep content ≥64px from every edge (≥96px on stories top/bottom).

## 2. Social specifics (on top of the general systems)
- **Typography is the hero in 2026**: oversized headline (≈90–160px on a 1080-wide canvas)
  paired with minimal support text.
- Color leans **vibrant** this year: bold hues, unexpected pairings, gradient blends
  (e.g. `linear-gradient(135deg, #6D28D9, #DB2777)`). A cohesive palette correlates with
  ~34% more saves / ~27% more shares.

## 3. Archetypes (pick one; vary from the last design)

### type-hero, the headline IS the design
- Solid or gradient background (dominant color).
- Huge headline, 2–4 words emphasized, left- or bottom-aligned (NOT dead-center).
- Small kicker/eyebrow above; brand logo + @handle in a footer row.

### split-block
- Canvas split (e.g. top 55% image / bottom 45% solid block, or 50/50 vertical).
- Headline + short support in the solid block; image fills the other half (`objectFit:"cover"`).

### photo-overlay
- Full-bleed image (`objectFit:"cover"`), dark gradient scrim at the bottom for legibility.
- Headline + CTA pinned to the lower-left over the scrim.

### quote
- Large quotation set in the display font; attribution row (avatar + name/title) below.
- Accent bar or an oversized quotation mark as a graphic anchor.

### carousel-cover
- Bold cover that promises a list/story ("5 ways to…"); number or topic huge.
- Small "swipe →" affordance bottom-right.

## 4. Concrete element tree, `type-hero` at 1080×1350
```json
{
  "canvas": { "width": 1080, "height": 1350, "backgroundColor": "#0F172A" },
  "elements": [
    {
      "id": "bg-accent",
      "type": "shape", "shapeType": "circle",
      "position": { "x": 620, "y": -180 }, "dimensions": { "width": 700, "height": 700 },
      "style": { "fill": "#6D28D9", "opacity": "1" },
      "zIndex": 1
    },
    {
      "id": "kicker",
      "type": "text", "content": "NEW DROP",
      "position": { "x": 64, "y": 760 }, "dimensions": { "width": 600, "height": 60 },
      "style": { "fontFamily": "Inter", "fontSize": "32px", "fontWeight": "700",
                 "color": "#A78BFA", "letterSpacing": "4px", "textTransform": "uppercase",
                 "textAlign": "left" },
      "zIndex": 2,
      "parameterizable": true, "parameterId": "kicker", "parameterType": "text"
    },
    {
      "id": "headline",
      "type": "text", "content": "Ship faster.\nLook incredible.",
      "position": { "x": 64, "y": 830 }, "dimensions": { "width": 880, "height": 340 },
      "style": { "fontFamily": "Inter", "fontSize": "120px", "fontWeight": "800",
                 "color": "#FFFFFF", "lineHeight": 1.02, "letterSpacing": "-2px",
                 "textAlign": "left", "textMode": "fit", "minFontSize": "64px" },
      "zIndex": 3,
      "parameterizable": true, "parameterId": "headline", "parameterType": "text"
    },
    {
      "id": "logo",
      "type": "image", "content": "https://logo-url",
      "position": { "x": 64, "y": 1230 }, "dimensions": { "width": 56, "height": 56 },
      "style": { "objectFit": "contain", "borderRadius": "12px" },
      "zIndex": 4,
      "parameterizable": true, "parameterId": "logo", "parameterType": "imageUrl"
    },
    {
      "id": "handle",
      "type": "text", "content": "@yourbrand",
      "position": { "x": 132, "y": 1238 }, "dimensions": { "width": 400, "height": 40 },
      "style": { "fontFamily": "Inter", "fontSize": "28px", "fontWeight": "600",
                 "color": "#CBD5E1", "textAlign": "left" },
      "zIndex": 4,
      "parameterizable": true, "parameterId": "handle", "parameterType": "text"
    }
  ]
}
```
Adapt this skeleton for the other archetypes, move the headline, add an image/scrim, swap
the accent shape, but keep the format/safe-area rules and brand mapping. Remember: `\n` for
line breaks (never `<br>`), and all style values are strings with units.

## 5. Social-specific anti-patterns
- Centered headline + paragraph (reads like a slide, not a post).
- Text outside the story safe area (hidden behind platform UI).
- Wrong aspect (square when the feed default is now 4:5 portrait).
- Same archetype as the last post for this brand.
