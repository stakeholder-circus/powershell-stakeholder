# PowerShell Toolchain

- State: deterministic-first local validation complete
- Toolchain source: `built-in-plus-module`

## Native commands
- `pwsh -NoLogo -NoProfile -Command 'Get-Module -ListAvailable Pester | Select-Object -First 1 Version'`
- `python3 scripts/validate_scaffold.py`
- `pwsh -NoLogo -NoProfile -Command "Invoke-Pester -Path tests -PassThru"`
- `pwsh -NoLogo -NoProfile -File bin/powershell-stakeholder.ps1 --list-values`
- `pwsh -NoLogo -NoProfile -File bin/powershell-stakeholder.ps1 --output-format json --focus-family code_analyzer --seed 123`

## Docker commands
- `docker build -t powershell-stakeholder .`
- `docker run --rm powershell-stakeholder --list-values`
- `docker run --rm powershell-stakeholder --output-format json --focus-family platform_engineering --seed 123`

## Optional setup
- `pwsh -NoLogo -NoProfile -Command 'Install-Module Pester -Scope CurrentUser -Force -SkipPublisherCheck'`
- `pwsh -NoLogo -NoProfile -Command 'Get-Module -ListAvailable Pester | Select-Object -First 1 Version'`

## Nix
- `/nix/var/nix/profiles/default/bin/nix --extra-experimental-features 'nix-command flakes' flake lock`
- `/nix/var/nix/profiles/default/bin/nix --extra-experimental-features 'nix-command flakes' flake show`

## Current limitation
- Full live-provider/runtime support is deferred. The deterministic runtime fails fast for provider flags.
- Docker Desktop on Apple Silicon may run the current PowerShell base image through amd64 emulation; this is acceptable for the local Docker gate when runtime smokes pass.
