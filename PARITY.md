# PowerShell Parity

- Role: local-only full-parity target in the next-20 wave
- Parity class: full-parity

## Review model
- Rust remains the canonical source-of-truth.
- `stakeholder-core` remains the behavioral contract.
- This repo is deterministic-first for the initial tranche.

## Implemented parity surface
- Full dedicated `classic-six`.
- Full dedicated `modern-core`.
- Grouped fallback for later families.
- Deterministic normalized JSON output.
- `--list-values` full registry metadata.
- Same-seed byte-stable JSON.
- Explicit experimental-provider fail-fast.

## Promotion blockers
- Publication/governance wave complete and remote access available.
- Second-pass live-provider rollout for eventual program completeness.
