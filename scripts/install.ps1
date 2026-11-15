param(
    [ValidateSet("opencode", "claude", "agents", "all")]
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

if ($Target -in @("opencode", "all")) {
    Copy-SkillDir "$HOME\.config\opencode\skills"
}
if ($Target -in @("claude", "all")) {
    Copy-SkillDir "$HOME\.claude\skills"
}
if ($Target -in @("agents", "all")) {
    Copy-SkillDir "$HOME\.agents\skills"
}
