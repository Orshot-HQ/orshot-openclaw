---
name: orshot-social-media-content
description: "Social media content generator and social media design for AI agents. Create on-brand Instagram post, LinkedIn post, TikTok, Reels, story, ad, banner, thumbnail and carousel templates with Orshot, then render them with new copy on every post. Use for content creation for Instagram, LinkedIn, TikTok, X, Facebook, YouTube and Pinterest, for a content creator or marketing team that wants designed templates instead of one-off AI images, as a Canva alternative an agent can drive, and when refining a template that looks generic. Applies the craft rules (clear hierarchy, 2-font typography, 60-30-10 color, restrained motion), consults the brand kit first, varies layouts so designs never repeat, and runs a render-and-critique loop over the hosted Orshot MCP server."
homepage: https://orshot.com/agents/openclaw
license: MIT-0
metadata:
  author: Orshot
  version: "1.2.0"
  mcp-server: orshot
  openclaw:
    emoji: "🎨"
    homepage: https://orshot.com/agents/openclaw
    primaryEnv: ORSHOT_API_KEY
    requires:
      env: []
      bins: []
    envVars:
      - name: ORSHOT_API_KEY
        required: false
        description: Orshot API key. Only for REST. Template design tools run over the hosted MCP server with OAuth, no key needed.
---

# Orshot Social Media Content: design the template once, post from it forever

Social media content from Orshot is a designed template plus fresh copy per post, not a new AI image every time. This skill makes Orshot studio templates that look professionally designed, not the generic centered-text "AI" look, for Instagram posts, LinkedIn posts, TikTok and Reels, stories, ads, banners, thumbnails and carousels. It is the knowledge layer on top of the Orshot MCP server's design tools (`orshot_create_template_design`, `orshot_update_template_design`, `orshot_patch_template_elements`, `orshot_get_brand_kit`).

## Connect first

```bash
openclaw mcp add orshot --url https://mcp.orshot.com/mcp --transport streamable-http --auth oauth
openclaw mcp login orshot
```

Design tools return inline thumbnails and design checks, so they are MCP only. The free plan (100 credits a month, no card) covers template creation and previews. Details and the REST fallback for rendering live in the `orshot` skill.

## Generate a template for a platform

1. **Pick the format.** Pass the preset as `size` on create and render, or give width and height.

| Platform | Preset | Pixels |
| --- | --- | --- |
| Instagram post (portrait, the 2026 default) | `instagram-post-portrait` | 1080x1350 |
| Instagram square | `instagram-post` | 1080x1080 |
| Instagram story, Reels cover, TikTok, YouTube Short | `instagram-story`, `tiktok-video`, `youtube-short` | 1080x1920 |
| LinkedIn post | `linkedin-post` | 1200x627 |
| LinkedIn carousel (PDF or image pages) | `linkedin-carousel` | square or 4:5 pages |
| X post, X header | `twitter-post`, `twitter-header` | 1200x675, 1500x500 |
| Facebook post, story, cover | `facebook-post`, `facebook-story`, `facebook-cover` | 1200x630, 1080x1920, 851x315 |
| Pinterest pin | `pinterest-pin` | 1000x1500 |
| YouTube thumbnail | `youtube-thumbnail` | 1280x720 |

Full list: the `orshot://formats` MCP resource.

2. **Read the spec and the brand.** `orshot://template-design-spec` (element schema, the animation gotchas), then `orshot_get_brand_kit` when the design should be on brand.
3. **Read the pack** `references/social-media.md` for safe areas, archetypes and a recipe. Pick an archetype different from the last template of this type.
4. **Create** with `orshot_create_template_design`, complete `pages_data`, every text element `textMode: "fit"` with `minFontSize`, dynamic fields marked `parameterizable: true` with snake_case `parameterId`s (`headline`, `subtitle`, `product_image`), `includeThumbnails: true`.
5. **Critique** the thumbnail and the design check, fix with `orshot_update_template_design` or `orshot_patch_template_elements`. Never ship the first pass unseen.
6. **Render** it with real copy (`orshot_render_template`) and show the user the output. One design, every size: `extraSizes: ["instagram-story", "linkedin-post", "1080x1080"]`.
7. **Hand off.** Posting, scheduling and analytics are in the `orshot-social-media-scheduler` skill; six-slide carousels in `orshot-carousel`. Keep the template; every future post is a render, not a redesign.

## When to use
Use whenever you are designing or refining a visual template: a social post/story/carousel,
an ad creative, a banner, a thumbnail, a launch graphic. For the studio element schema and
render gotchas, also consult the MCP resource `orshot://template-design-spec`.

## Boundaries
- This is design guidance, it does NOT replace the schema spec. Style values are always
  strings with units; `position`/`dimensions` are nested objects. See Compatibility below.
- It composes with the `orshot` skill (API/generation mechanics): use that to render.

## Operating principle
**Design serves the task.** Decide the ONE thing the viewer must take away, then make
everything support it. Respect the brand and the platform over generic prettiness. Prefer
the deterministic rules below over subjective iteration.

## Required workflow (in order)
1. **Shape**: restate the goal, audience, and the single key message before placing anything.
2. **Inherit the brand (when on-brand)**: IF the design should match the user's
   brand/product (the prompt implies it, or asks for "our" style), call `orshot_get_brand_kit`
   (tag-filter to the purpose) and map brand colors/fonts/logo onto the roles in Systems. If
   the prompt asks for a generic/standalone look, use the pack defaults, don't force brand in.
3. **Pick the vertical pack**: read the matching file in `references/` (e.g.
   `references/social-media.md`) for format, safe areas, archetypes, and a concrete recipe.
   Choose a DIFFERENT archetype from recent templates of this type.
4. **Build**: establish one focal element, then support it. Keep the design simple on the
   first create; refine in a follow-up update.
5. **Critique**: create/update with `includeThumbnails:true`, READ the thumbnail, and fix
   issues with `orshot_update_template_design` / `orshot_patch_template_elements`. Never ship
   the first pass unseen. (The create tool also returns a "🎨 Design check", resolve its ⚠s.)

## Systems
- **Hierarchy**: one clear focal point via size, weight, and position. Not everything centered.
- **Typography**: exactly **2 font families** (display + body). Hierarchy from scale/weight.
  Tight `lineHeight` (1.0–1.15) and slightly negative `letterSpacing` on large display type.
  Heaviest brand font → display, lighter → body.
- **Color, 60-30-10**: 60% dominant, 30% secondary, 10% accent. Cohesive palette beats more
  colors. Clear WCAG AA contrast. Map brand colors to roles by USAGE, not by "primary" label.
- **Composition & space**: generous margins (≥ ~6% of canvas per edge), align to an implied
  grid, prefer off-center over dead-center stacking.
- **Imagery**: full-bleed or intentionally framed; `objectFit:"cover"` for photos; add a
  gradient scrim under text over busy photos.

## Brand (contextual, not mandatory)
Use the brand kit WHEN the design should be on-brand (the prompt references the user's brand,
product, or identity): colors → 60-30-10 roles, fonts → display/body, logo → a small
corner/footer mark, images → hero/product. For a generic/exploratory/standalone look, the
pack palette is fine, don't force brand assets in.

## Variety
**Never repeat a layout for the same content type.** Vary archetype, focal placement, and
color emphasis between designs of the same kind.

## Compatibility (get these right or the render silently breaks)
- ALL style values are **strings with units**: `"48px"`, `"700"`, `"12px"`: never bare numbers.
- `position` and `dimensions` are **nested objects** (`{x,y}`, `{width,height}`).
- **Set `textMode:"fit"` + `minFontSize` on EVERY text element** (floors: headline 48,
  subtitle 28, body 24, kicker 18, caption 14). The default `"overflow"` does not shrink or
  reflow, long/parameterized text spills out of its box.
- Line breaks: use `\n`, **NEVER `<br>`**; avoid multiple `<p>` blocks (they overlap). For a
  multi-line headline with one accent-colored word, use one text element per line.
- A **background-highlight `<span>` (colored pill) forces the whole element to one line**
  (`white-space: nowrap`) → overflow on long text. Highlight only 1–3 words; for long
  headlines use `color` emphasis (no background) or split per line.
- Parameterizable fields need `parameterizable:true`, a unique snake_case `parameterId`, and a
  `parameterType` matching the element (text→"text", image→"imageUrl", shape→"fill",
  canvas/container→"backgroundColor").
- Shapes with transparent fill + a border render nothing; SVG `content` must be a data-URI.

## Motion & audio (video templates)
Making video look designed, not generated:
- **Reveal in sections over ~4–5s.** Elements that form one unit (icon+label, a spec row,
  the footer) share the SAME `enter` type and `showAt`; stagger ~0.3–0.5s BETWEEN sections in
  reading order. `showAt`/`hideAt` are siblings of `enter`/`exit`: never nested inside them.
- **Every full-bleed photo gets a `kenBurns` ambient** (zoom 1.08–1.15). A still photo held
  3 seconds reads as a dead frame; a slow push reads as footage. Alternate `panX` direction
  between pages.
- **Ambient stays subtle and SLOW**: 6–10s cycles against a 0.5s enter. If the viewer can
  name the motion it is too strong, unless it is a deliberate accent (a badge that wiggles).
  `shake`/`slowRotate` need `easing: "linear"` or the loop seam shows.
- **One `pageTransition` for the whole video**, 0.3–0.5s. A different transition per cut is
  the clearest tell of an auto-generated edit.
- **Sound default**: narration track at volume 1 + a restrained generated ambient bed
  (`sfx`, volume 0.08–0.18, loop) + `page.subtitle { source: "auto-audio" }` with a caption
  preset (`karaoke`/`bold`) and strokeWidth 2–3 over busy footage. Budget narration at
  ~2 words/second with 1s headroom. Call `orshot_get_audio_authoring_options` before
  authoring generated audio; give `tts.parameterId` so spoken copy stays a render parameter.

## Anti-patterns (the AI-slop tells, avoid)
- Everything centered and stacked; no focal point.
- 3+ fonts, or random sizes with no hierarchy.
- Low-contrast text on a busy photo with no scrim.
- Forcing brand assets when the prompt didn't ask for an on-brand design (or ignoring the kit when it clearly did).
- A tiny headline above a paragraph of body copy (a template is not a document).
- Re-emitting the previous layout for the same content type.

## Vertical packs (progressive disclosure)
Read the one matching the task, each adds format/safe-areas, archetypes, and a recipe:
- `references/social-media.md`: posts, stories, carousels.
- (more verticals, ads, real-estate, e-commerce, added here over time.)

## Examples

### Example 1, "Make an Instagram post announcing our new feature"
1. `orshot_get_brand_kit` (tags: "social-media") → brand colors/fonts/logo.
2. Read `references/social-media.md` → default 4:5 portrait 1080×1350; pick the `type-hero`
   archetype (different from the last post).
3. `orshot_create_template_design` with brand display font for an oversized headline, brand
   dominant color as background, accent color on one word, logo + @handle footer,
   `includeThumbnails:true`.
4. Read the thumbnail + "🎨 Design check"; patch contrast/spacing as needed.

### Example 2, "Refine this template, it looks generic"
1. `orshot_get_studio_template` to inspect the current design.
2. Diagnose against Anti-patterns (centered? 3+ fonts? no focal point? brand ignored?).
3. `orshot_patch_template_elements` to set one focal headline, trim to 2 fonts, apply brand
   60-30-10, left/bottom-align. Re-render with `includeThumbnails:true` and verify.

## Troubleshooting

**Headline shows on one line / `<br>` ignored.** Use `\n`, not `<br>`. For a colored word on
a multi-line headline, split into one text element per line.

**Colors/fonts look off-brand.** You skipped step 2, call `orshot_get_brand_kit` and map the
returned `value` (colors) and `name` (fonts) onto the design.

**"🎨 Design check" warns about repetition.** This layout matches a recent same-type template.
Switch archetype and move the focal point.
