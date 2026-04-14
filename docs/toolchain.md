  # PowerShell Toolchain

  - State: scaffold-only next-20 prep
  - Toolchain source: `built-in-plus-module`

  ## Planned commands after promotion
    - `pwsh -NoLogo -NoProfile -Command 'Install-Module Pester -Scope CurrentUser -Force -SkipPublisherCheck'`
- `pwsh -NoLogo -NoProfile -Command 'Get-Module -ListAvailable Pester | Select-Object -First 1 Version'`

  ## Scaffold-time checks
  - `python3 scripts/validate_scaffold.py`
  - `/nix/var/nix/profiles/default/bin/nix --extra-experimental-features 'nix-command flakes' flake lock`

  ## Current limitation
  - pwsh is present; Pester must be installed per-user before implementation.
