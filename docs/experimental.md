# PowerShell Experimental Surface

- Live-provider concepts are modeled separately from the deterministic baseline.
- OpenAI-compatible APIs, Anthropic APIs, and consumer-account adapters remain documentation and interface work until the later provider rollout.
- `--experimental-provider <name>` fails fast in this deterministic-first tranche.
- Experimental additions must not change seeded parity fixtures by default.
