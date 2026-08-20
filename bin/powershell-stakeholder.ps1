#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ClassicSix = @('code_analyzer', 'data_processing', 'jargon', 'metrics', 'network_activity', 'system_monitoring')
$ModernCore = @('agent_workflows', 'platform_engineering', 'observability_ai_runtime', 'delivery_preview_ops', 'supply_chain_security')
$AiGovernance = @('ai_inference_ops', 'evaluation_and_guardrails', 'knowledge_retrieval', 'edge_client_runtime', 'identity_and_trust', 'aibom_provenance', 'agent_boundary_security', 'embedded_agentic_pipeline', 'data_governance_compliance', 'finops_capacity')
$SecurityBlockchain = @('blockchain_protocol_ops', 'cross_chain_interop', 'proof_and_sequencer_ops')
$OverlayQuantum = @('hybrid_runtime_ops', 'capacity_cost_controller', 'batch_execution_tuner', 'compiler_maintainer', 'interop_adapter_engineer', 'preflight_capacity_planner', 'simulator_performance_engineer')
$HealthProtocol = @('fhir_profile_generator', 'smart_launch_oauth', 'bulk_fhir_population_ops', 'hl7v2_feed_ops', 'clinical_workflow_events', 'dicomweb_imaging_ops', 'openehr_semantic_record_ops', 'device_telemetry_clinical', 'emr_vendor_adapter', 'ocpp_chargepoint_ops', 'ocpi_roaming_ops', 'mcp_a2a_ops', 'streaming_bus_ops', 'service_mesh_rpc_ops')
$AllFamilies = @($ClassicSix + $ModernCore + $AiGovernance + $SecurityBlockchain + $OverlayQuantum + $HealthProtocol)

$Dedicated = @{
    code_analyzer = @{ Renderer = 'classic-six.code_analyzer'; Tranche = 'classic-six'; ContextKey = 'analysisFocus'; ContextValue = 'cmdlet-contract-audit' }
    data_processing = @{ Renderer = 'classic-six.data_processing'; Tranche = 'classic-six'; ContextKey = 'dataWindow'; ContextValue = 'object-pipeline-reconciliation' }
    jargon = @{ Renderer = 'classic-six.jargon'; Tranche = 'classic-six'; ContextKey = 'languagePolicy'; ContextValue = 'powershell-ecosystem-glossary' }
    metrics = @{ Renderer = 'classic-six.metrics'; Tranche = 'classic-six'; ContextKey = 'signalBlend'; ContextValue = 'latency-error-saturation' }
    network_activity = @{ Renderer = 'classic-six.network_activity'; Tranche = 'classic-six'; ContextKey = 'transportMix'; ContextValue = 'http-sse-remoting' }
    system_monitoring = @{ Renderer = 'classic-six.system_monitoring'; Tranche = 'classic-six'; ContextKey = 'telemetryScope'; ContextValue = 'runtime-build-host' }
    agent_workflows = @{ Renderer = 'modern-core.agent_workflows'; Tranche = 'modern-core'; ContextKey = 'coordinationMode'; ContextValue = 'script-orchestration-handshake' }
    platform_engineering = @{ Renderer = 'modern-core.platform_engineering'; Tranche = 'modern-core'; ContextKey = 'platformSurface'; ContextValue = 'pwsh-release-lane' }
    observability_ai_runtime = @{ Renderer = 'modern-core.observability_ai_runtime'; Tranche = 'modern-core'; ContextKey = 'runtimeSignals'; ContextValue = 'logs-metrics-provider-audit' }
    delivery_preview_ops = @{ Renderer = 'modern-core.delivery_preview_ops'; Tranche = 'modern-core'; ContextKey = 'deliveryGuardrail'; ContextValue = 'preview-release-checkpoints' }
    supply_chain_security = @{ Renderer = 'modern-core.supply_chain_security'; Tranche = 'modern-core'; ContextKey = 'supplyChainPosture'; ContextValue = 'script-integrity-attestation' }
}

function Get-RegistryId {
    param([Parameter(Mandatory)][string] $Family)
    $Family.Replace('_', '-')
}

function ConvertTo-FamilyName {
    param([string] $Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $null }
    $normalized = $Value.Trim().ToLowerInvariant().Replace('-', '_')
    if ($AllFamilies -contains $normalized) { return $normalized }
    return $null
}

function Get-FallbackGroup {
    param([Parameter(Mandatory)][string] $Family)
    if ($AiGovernance -contains $Family) { return 'ai_governance' }
    if ($SecurityBlockchain -contains $Family) { return 'security_blockchain' }
    if ($OverlayQuantum -contains $Family) { return 'overlay_quantum' }
    return 'health_protocol'
}

function Get-FamilyDescriptor {
    param([Parameter(Mandatory)][string] $Family)
    if ($Dedicated.ContainsKey($Family)) { return $Dedicated[$Family] }
    $group = Get-FallbackGroup -Family $Family
    return @{ Renderer = "fallback.$group"; Tranche = "fallback-$group"; ContextKey = 'fallbackFamily'; ContextValue = $group }
}

function Get-DeterministicHash {
    param([Parameter(Mandatory)][string] $Value)
    [uint32] $hash = 2166136261
    foreach ($char in $Value.ToCharArray()) {
        $hash = [uint32]($hash -bxor [byte][char]$char)
        $hash = [uint32](([uint64]$hash * 16777619) -band 0xffffffffL)
    }
    $hash
}

function Get-ListValuePayload {
    [ordered]@{
        outputFormats = @('text', 'json')
        flags = @('list-values', 'focus-family', 'output-format', 'seed', 'experimental-provider')
        generatorFamilies = @($AllFamilies | ForEach-Object {
            $meta = Get-FamilyDescriptor -Family $_
            [ordered]@{ id = $_; registryId = Get-RegistryId -Family $_; rendererKey = $meta.Renderer; tranche = $meta.Tranche }
        })
        classicSix = @($ClassicSix | ForEach-Object { Get-RegistryId -Family $_ })
        modernCore = @($ModernCore | ForEach-Object { Get-RegistryId -Family $_ })
        fallbackFamilies = @(($AiGovernance + $SecurityBlockchain + $OverlayQuantum + $HealthProtocol) | ForEach-Object { Get-RegistryId -Family $_ })
        implementationMode = 'family-focus-deterministic'
    }
}

function Get-FocusPayload {
    param(
        [Parameter(Mandatory)][string] $Family,
        [Parameter(Mandatory)][string] $Seed,
        [Parameter(Mandatory)][string] $OutputFormat
    )
    $normalized = ConvertTo-FamilyName -Value $Family
    if (-not $normalized) { throw "invalid family: $Family" }
    $meta = Get-FamilyDescriptor -Family $normalized
    $hash = Get-DeterministicHash -Value "$Seed::$normalized"
    $seconds = $hash % 86400
    $hour = [math]::Floor($seconds / 3600)
    $minute = [math]::Floor(($seconds % 3600) / 60)
    $second = $seconds % 60
    $context = [ordered]@{
        rendererKey = $meta.Renderer
        ($meta.ContextKey) = $meta.ContextValue
        seedFingerprint = "$(Get-RegistryId -Family $normalized)-$($hash.ToString('x'))"
        tranche = $meta.Tranche
        powershellProfile = 'next-20-deterministic-foundation'
    }
    [ordered]@{
        eventType = 'stakeholder.generator.output'
        sequence = 1000 + ($hash % 9000)
        family = $normalized
        message = "Deterministic powershell tranche for $normalized"
        timestamp = ('2026-01-01T{0:00}:{1:00}:{2:00}Z' -f $hour, $minute, $second)
        context = $context
        generationProvenance = [ordered]@{
            sourceRepo = 'powershell-stakeholder'
            baseline = 'next20-family-focus'
            experimental = $false
            adapterType = 'static-catalog'
            promptVersion = $null
        }
        outputFormat = $OutputFormat
    }
}

$focusFamily = $null
$seed = 'default-seed'
$outputFormat = 'text'
$listValues = $false

for ($i = 0; $i -lt $args.Count; $i++) {
    switch ($args[$i]) {
        '--list-values' { $listValues = $true }
        '--focus-family' {
            if (++$i -ge $args.Count) { Write-Error 'missing value for --focus-family' -ErrorAction Continue; exit 2 }
            $focusFamily = ConvertTo-FamilyName -Value $args[$i]
            if (-not $focusFamily) { Write-Error "invalid --focus-family: $($args[$i])" -ErrorAction Continue; exit 2 }
        }
        '--seed' {
            if (++$i -ge $args.Count) { Write-Error 'missing value for --seed' -ErrorAction Continue; exit 2 }
            $seed = $args[$i]
        }
        '--output-format' {
            if (++$i -ge $args.Count) { Write-Error 'missing value for --output-format' -ErrorAction Continue; exit 2 }
            $outputFormat = $args[$i]
            if ($outputFormat -notin @('text', 'json')) { Write-Error "invalid --output-format: $outputFormat" -ErrorAction Continue; exit 2 }
        }
        '--experimental-provider' {
            if (++$i -ge $args.Count) { Write-Error 'missing value for --experimental-provider' -ErrorAction Continue; exit 2 }
            Write-Error "experimental provider '$($args[$i])' is not enabled in the deterministic first tranche" -ErrorAction Continue
            exit 2
        }
        default {
            if ($args[$i].StartsWith('--experimental-')) {
                Write-Error 'experimental flags require --experimental-provider' -ErrorAction Continue
                exit 2
            }
            Write-Error "unknown argument: $($args[$i])" -ErrorAction Continue
            exit 2
        }
    }
}

if ($listValues) {
    Get-ListValuePayload | ConvertTo-Json -Depth 8
    exit 0
}

if (-not $focusFamily) {
    Write-Error 'focus-family is required and must be a known generator family' -ErrorAction Continue
    exit 2
}

$payload = Get-FocusPayload -Family $focusFamily -Seed $seed -OutputFormat $outputFormat
if ($outputFormat -eq 'json') {
    $payload | ConvertTo-Json -Depth 8
    exit 0
}

Write-Output "family: $($payload.family)"
Write-Output "renderer: $($payload.context.rendererKey)"
Write-Output "tranche: $($payload.context.tranche)"
Write-Output "sequence: $($payload.sequence)"
Write-Output "timestamp: $($payload.timestamp)"
Write-Output "message: $($payload.message)"
