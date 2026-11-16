param(
    [ValidateSet("opencode", "claude", "agents", "antigravity", "all")]
    [string]$Target = "opencode"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$SkillSrc = Join-Path $RepoRoot "skills\dev-docs"

function Copy-SkillDir([string]$DestRoot) {
    $Dest = Join-Path $DestRoot "dev-docs"
    New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null
    if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
    Copy-Item -Recurse -Force -Path $SkillSrc -Destination $Dest
    Write-Host "[OK] Installed skill 'dev-docs' -> $Dest" -ForegroundColor Green
}

function Install-AntigravityPlugin {
    $PluginDest = Join-Path $HOME ".gemini\config\plugins\dev-docs-skill"
    $AssetsDest = Join-Path $PluginDest "assets"
    $SkillsDest = Join-Path $PluginDest "skills"

    New-Item -ItemType Directory -Force -Path $AssetsDest | Out-Null
    Copy-Item -Force -Path (Join-Path $RepoRoot "plugin.json") -Destination (Join-Path $PluginDest "plugin.json")
    Copy-Item -Force -Path (Join-Path $RepoRoot "assets\logo.svg") -Destination (Join-Path $AssetsDest "logo.svg")
    Copy-SkillDir $SkillsDest
    Write-Host "[OK] Installed Antigravity plugin 'dev-docs-skill' -> $PluginDest" -ForegroundColor Green
}

if ($Target -in @("opencode", "all")) {
    Copy-SkillDir "$HOME\.config\opencode\skills"
}
if ($Target -in @("claude", "all")) {
    Copy-SkillDir "$HOME\.claude\skills"
}
if ($Target -in @("agents", "all")) {
    Copy-SkillDir "$HOME\.agents\skills"
}
if ($Target -in @("antigravity", "all")) {
    Install-AntigravityPlugin
}
