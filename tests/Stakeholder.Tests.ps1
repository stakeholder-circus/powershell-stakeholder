BeforeAll {
    $script:RepoRoot = Split-Path -Parent $PSScriptRoot
    $script:CliPath = Join-Path $script:RepoRoot 'bin/powershell-stakeholder.ps1'

    function Invoke-StakeholderProcess {
        param([Parameter(Mandatory)][string[]] $CliArgs)
        $id = [guid]::NewGuid().ToString('N')
        $stdout = Join-Path $TestDrive "stdout-$id.txt"
        $stderr = Join-Path $TestDrive "stderr-$id.txt"
        $argumentList = @('-NoLogo', '-NoProfile', '-File', $script:CliPath) + $CliArgs
        $process = Start-Process -FilePath 'pwsh' -ArgumentList $argumentList -Wait -PassThru -NoNewWindow -RedirectStandardOutput $stdout -RedirectStandardError $stderr
        [pscustomobject]@{
            ExitCode = $process.ExitCode
            StdOut = if (Test-Path $stdout) { Get-Content -Raw -Path $stdout } else { '' }
            StdErr = if (Test-Path $stderr) { Get-Content -Raw -Path $stderr } else { '' }
        }
    }
}

Describe 'powershell-stakeholder deterministic first tranche' {
    It 'lists full registry metadata' {
        $result = Invoke-StakeholderProcess -CliArgs @('--list-values')
        $result.ExitCode | Should -Be 0
        $values = $result.StdOut | ConvertFrom-Json
        @($values.generatorFamilies).Count | Should -Be 45
        $values.flags | Should -Contain 'focus-family'
        $values.classicSix | Should -Contain 'code-analyzer'
        $values.modernCore | Should -Contain 'platform-engineering'
        $values.fallbackFamilies | Should -Contain 'knowledge-retrieval'
    }

    It 'renders deterministic JSON for a dedicated family' {
        $result = Invoke-StakeholderProcess -CliArgs @('--output-format', 'json', '--focus-family', 'code_analyzer', '--seed', '123')
        $result.ExitCode | Should -Be 0
        $payload = $result.StdOut | ConvertFrom-Json
        $payload.family | Should -Be 'code_analyzer'
        $payload.context.rendererKey | Should -Be 'classic-six.code_analyzer'
    }

    It 'normalizes dashed family names' {
        $result = Invoke-StakeholderProcess -CliArgs @('--output-format', 'json', '--focus-family', 'platform-engineering', '--seed', '41')
        $result.ExitCode | Should -Be 0
        $payload = $result.StdOut | ConvertFrom-Json
        $payload.family | Should -Be 'platform_engineering'
        $payload.context.tranche | Should -Be 'modern-core'
    }

    It 'routes later families through grouped fallback' {
        $result = Invoke-StakeholderProcess -CliArgs @('--output-format', 'json', '--focus-family', 'ai_inference_ops', '--seed', '7')
        $result.ExitCode | Should -Be 0
        $payload = $result.StdOut | ConvertFrom-Json
        $payload.context.rendererKey | Should -Be 'fallback.ai_governance'
        $payload.context.fallbackFamily | Should -Be 'ai_governance'
    }

    It 'emits byte-identical JSON for the same seed and arguments' {
        $args = @('--output-format', 'json', '--seed', '12345', '--focus-family', 'platform_engineering')
        $first = Invoke-StakeholderProcess -CliArgs $args
        $second = Invoke-StakeholderProcess -CliArgs $args
        $first.ExitCode | Should -Be 0
        $second.ExitCode | Should -Be 0
        $first.StdOut | Should -BeExactly $second.StdOut
    }

    It 'fails fast when an experimental provider is requested' {
        $result = Invoke-StakeholderProcess -CliArgs @('--experimental-provider', 'openai-compatible')
        $result.ExitCode | Should -Be 2
        $result.StdErr | Should -Match 'experimental provider'
    }
}
