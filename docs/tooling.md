# PowerShell Tooling

## Commands
- `python3 scripts/validate_scaffold.py`
- `pwsh -NoLogo -NoProfile -Command "Invoke-Pester -Path tests -PassThru"`
- `pwsh -NoLogo -NoProfile -File bin/powershell-stakeholder.ps1 --list-values`
- `docker build -t powershell-stakeholder .`
- `docker run --rm powershell-stakeholder --list-values`

## Extended local checks
- Deterministic same-seed JSON diff for `platform_engineering`.
- Experimental-provider fail-fast smoke.
- Pester contract tests.

## Notes
- The Docker path is the reproducible Linux baseline.
- Native CI should still cover macOS, Linux, and Windows PowerShell semantics.
