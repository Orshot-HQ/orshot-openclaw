# Orshot skills for OpenClaw

Skills that teach an [OpenClaw](https://openclaw.ai) agent to generate images, PDFs and videos from Orshot templates, design social media content templates, post them to social media, and build carousels. Published on [ClawHub](https://clawhub.ai). This repo is the source of truth and the version history for those listings.

Orshot is an API for automated image, PDF and video generation from templates: https://orshot.com

## Install

Connect the hosted Orshot MCP server once (OAuth, no API key, 100 free credits a month):

```bash
openclaw mcp add orshot --url https://mcp.orshot.com/mcp --transport streamable-http --auth oauth
openclaw mcp login orshot
```

Then install the skills you need:

```bash
openclaw skills install @orshot/orshot                          # automate video, PDF and image generation from templates and social media posting
openclaw skills install @orshot/orshot-social-media-scheduler   # schedule posts, post to Instagram, LinkedIn, X, TikTok and 9 more
openclaw skills install @orshot/orshot-carousel                 # TikTok, Instagram and LinkedIn carousels from a template
openclaw skills install @orshot/orshot-social-media-content     # design Instagram, LinkedIn, TikTok, story, ad and carousel templates
```

Any other agent that reads `SKILL.md` folders (Claude Code, Cursor, Codex) can point at `skills/` directly, or use the plugin repo [orshot-agent-skills](https://github.com/Orshot-HQ/orshot-agent-skills).

## Skills

| Skill | What it covers |
| --- | --- |
| [`orshot`](skills/orshot/SKILL.md) | The main skill. Connect over MCP, find a template, read its parameters, render images, PDFs and video, resize, batch, brand kit, signed URLs, workflows, and the core of social posting. Long material lives in `references/`. |
| [`orshot-social-media-scheduler`](skills/orshot-social-media-scheduler/SKILL.md) | Social media scheduler and automation: connect accounts, draft, schedule and publish to 13 platforms, manage held posts, analytics, best time to post. |
| [`orshot-carousel`](skills/orshot-carousel/SKILL.md) | TikTok, Instagram and LinkedIn carousels (TikTok slideshows) from a six-page template: formula, template rules, render, post as a draft, learning loop. |
| [`orshot-social-media-content`](skills/orshot-social-media-content/SKILL.md) | Social media content generator: design on-brand Instagram, LinkedIn, TikTok, story, ad, thumbnail and carousel templates per platform preset, with the craft rules (hierarchy, type, color, motion) and a render-and-critique loop. |

## Security and data

- The skills carry no credentials. Over MCP the agent authenticates with the user's own Orshot account through OAuth. Over REST it reads `ORSHOT_API_KEY` from the environment and never echoes it.
- Every write that leaves the workspace (publishing a post, running a workflow, deleting a template or asset) is marked in the skill as needing an explicit go-ahead. Social posts default to drafts.
- The skills only call `api.orshot.com` and `mcp.orshot.com`. No shell binaries are required (`requires.bins` is empty).

## Versioning and publishing

Each skill carries its version in `metadata.version` in its frontmatter. Bump it with every content change, add a line to [CHANGELOG.md](CHANGELOG.md), tag the release, and publish with the script:

```bash
npm install -g clawhub@0.23.3
clawhub login
./scripts/publish.sh            # publishes every skill whose version changed, with GitHub provenance
./scripts/publish.sh --dry-run  # shows what would be published
```

The script passes `--source-repo`, `--source-commit` and `--source-ref` so every ClawHub version links back to the commit it came from. After publishing, `clawhub scan --slug <slug> --version <v> --json` pulls the audit report for the new version.

## Contributing

Fixes to endpoint paths, gotchas and examples are welcome. Keep `SKILL.md` files short (the agent loads them whole); put long reference material in `references/`. No em dashes, plain words, and no placeholder keys that look like secrets (`$ORSHOT_API_KEY`, never `<ORSHOT_API_KEY>`).

## License

MIT-0. See [LICENSE](LICENSE).
