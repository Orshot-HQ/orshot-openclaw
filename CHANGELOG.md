# Changelog

One entry per published ClawHub version. Skill versions live in each `SKILL.md` frontmatter (`metadata.version`).

## 2026-10-22

### orshot 1.4.0

- Description and body rewritten around the jobs people search for: image generation, PDF generation, video generation from templates, OG images, social media posts, carousels, thumbnails, invoices, certificates, and the 13 social platforms.
- MCP connection first (`openclaw mcp add` + `openclaw mcp login`), REST with an API key as the headless fallback. Every capability names the MCP tool before the REST route.
- Capability list and example prompts mirror the Orshot connector listing in the Claude directory.
- Social posting section: accounts, render and post in one call, post existing media, held posts, analytics and best time. 1.3.0 covered render plus publish and account listing only.
- Safety rules for agents and confirmation notes next to delete routes and workflow runs.
- `metadata.openclaw` block (emoji, homepage, `primaryEnv`, `envVars` with `required: false` because OAuth over MCP needs no key).
- `Bearer <ORSHOT_API_KEY>` placeholders replaced with `$ORSHOT_API_KEY`, which the ClawHub scanner no longer reads as a hardcoded secret.
- SDK installs pinned (`orshot@0.3.1`, `orshot==0.2.0`, `rishimohan/orshot:0.2.0`, `gem orshot -v 0.2.0`).
- SKILL.md shrunk from 57 KB to about 16 KB; long material moved to `references/`, loaded on demand.

### orshot-social-media-scheduler 1.0.0

- First release. Connect over MCP, list accounts, send the user to the dashboard to connect accounts when the list is empty, draft, schedule and publish to 13 platforms, manage held posts, analytics and best time to post, six common patterns, safety rules, gotchas.

### orshot-carousel 1.0.0

- First release. Six-slide formula, template rules with TikTok safe zones, create the template if none exists, render in one call, post as a draft through Orshot or hand to Postiz, learning loop.

### orshot-social-media-content 1.2.0

- Renamed from `orshot-design` for ClawHub (the agent-skills plugin keeps the old name). Description rewritten around social media content, Instagram post, LinkedIn post, TikTok and social media design.
- New opening section: connect over MCP, then generate a template for a platform (preset table, spec, brand kit, create with thumbnails, critique, render, hand off to the scheduler and carousel skills).
- Craft rules, systems, compatibility, motion and anti-patterns unchanged. Em dashes replaced.
- `metadata.openclaw` block, homepage and license added.
