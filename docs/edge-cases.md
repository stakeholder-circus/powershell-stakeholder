# PowerShell Edge Cases

- Seeded JSON runs must remain byte-stable for the same family and seed.
- Dashed family input is normalized to underscore family ids.
- Later families route through grouped fallback renderers until they get dedicated implementations.
- Experimental live-provider concepts must not affect default deterministic output.
