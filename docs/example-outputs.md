# PowerShell Example Outputs

## Registry
```bash
pwsh -NoLogo -NoProfile -File bin/powershell-stakeholder.ps1 --list-values
```

## Classic six
```bash
pwsh -NoLogo -NoProfile -File bin/powershell-stakeholder.ps1 --output-format json --focus-family code_analyzer --seed 42
```

## Modern core
```bash
pwsh -NoLogo -NoProfile -File bin/powershell-stakeholder.ps1 --output-format json --focus-family platform_engineering --seed 7
```
