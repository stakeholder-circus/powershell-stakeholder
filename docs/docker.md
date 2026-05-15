# PowerShell Docker

## Build and test
- `docker build -t powershell-stakeholder .`
- `docker run --rm powershell-stakeholder --list-values`
- `docker run --rm powershell-stakeholder --output-format json --focus-family code_analyzer --seed 123`

## Rationale
- The image packages the deterministic PowerShell CLI on the official PowerShell runtime.
- Docker is the reproducible Linux gate; host checks still cover local shell behavior.
