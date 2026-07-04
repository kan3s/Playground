# install.ps1
# Run this from inside the cloned/templated claude-config repo:
#   .\install.ps1
#
# What it does, in order:
#   1. Installs Git, GitHub CLI, and Claude Code if any are missing (skips
#      anything already present).
#   2. Makes ~/.claude BE this repo:
#      - If ~/.claude doesn't exist yet, moves this repo there.
#      - If ~/.claude already exists (e.g. Claude Code has been run before,
#        or an older symlink-based version of this setup is in place),
#        removes any old symlinks and copies this repo's files in-place,
#        preserving Claude Code's own internal state.
#   3. Adds the `newproj` shortcut to your PowerShell profile.
#
# Safe to re-run - every step checks whether it's already done first.

$RepoRoot   = $PSScriptRoot
$ClaudeHome = "$HOME\.claude"

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# --- 1. Prerequisites ---------------------------------------------------

Write-Host "== Checking prerequisites ==" -ForegroundColor Cyan

if (-not (Test-Command git)) {
    Write-Host "Installing Git for Windows..."
    winget install --id Git.Git -e --source winget
} else {
    Write-Host "Git: found"
}

if (-not (Test-Command gh)) {
    Write-Host "Installing GitHub CLI..."
    winget install --id GitHub.cli -e --source winget
} else {
    Write-Host "GitHub CLI: found"
}

# Refresh PATH in this session in case winget just installed something new
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Test-Command gh)) {
    Write-Warning "gh was just installed but isn't visible in this session yet."
    Write-Warning "Close this window, open a new PowerShell, and re-run .\install.ps1 to continue."
    exit 1
}

gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Authenticating GitHub CLI..."
    gh auth login
}

if (-not (Test-Command claude)) {
    Write-Host "Installing Claude Code..."
    irm https://claude.ai/install.ps1 | iex
    Write-Warning "Claude Code was just installed. Close this window, open a new PowerShell,"
    Write-Warning "and re-run .\install.ps1 to continue (PATH only updates in new sessions)."
    exit 0
}
Write-Host "Claude Code: found ($(claude --version))"

# --- 2. Wire up ~/.claude ------------------------------------------------

Write-Host "`n== Setting up $ClaudeHome ==" -ForegroundColor Cyan

if ((Resolve-Path $RepoRoot).Path -ieq (Resolve-Path -ErrorAction SilentlyContinue $ClaudeHome).Path) {
    Write-Host "Already running from $ClaudeHome - nothing to move."
}
elseif (-not (Test-Path $ClaudeHome)) {
    Write-Host "$ClaudeHome doesn't exist yet - moving this repo there."
    Move-Item $RepoRoot $ClaudeHome
    Set-Location $ClaudeHome
}
else {
    Write-Host "$ClaudeHome already exists - migrating in place."

    # Remove any symlinks left over from an older, symlink-based version of
    # this setup. Real files (like settings.json) are left untouched.
    Get-ChildItem $ClaudeHome -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.LinkType -eq "SymbolicLink" } |
        ForEach-Object {
            Write-Host "  Removing old symlink: $($_.FullName)"
            Remove-Item $_.FullName -Force
        }

    # Copy this repo's tracked files into ~/.claude, preserving whatever
    # Claude Code's own internal state already lives there.
    Copy-Item "$RepoRoot\*" $ClaudeHome -Recurse -Force -Exclude ".git"

    $OldRoot = $RepoRoot
    Set-Location $ClaudeHome
    Remove-Item $OldRoot -Recurse -Force -ErrorAction SilentlyContinue

    if (-not (Test-Path "$ClaudeHome\.git")) {
        git init | Out-Null
    }
}

git add .
git commit -m "Set up ~/.claude as its own repo" *> $null

# --- 3. newproj shortcut --------------------------------------------------

Write-Host "`n== Adding the newproj shortcut ==" -ForegroundColor Cyan

$funcBlock = @'
function New-ClaudeProject {
    param([Parameter(Mandatory=$true)][string]$Name, [string]$Path = "$HOME\dev")
    & "$HOME\.claude\scripts\new-project.ps1" -Name $Name -Path $Path
}
Set-Alias newproj New-ClaudeProject
'@

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

if ((Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue) -notmatch "New-ClaudeProject") {
    Add-Content -Path $PROFILE -Value "`n$funcBlock"
    Write-Host "Added 'newproj' to your PowerShell profile."
} else {
    Write-Host "'newproj' is already in your profile - skipped."
}

Write-Host "`nDone. Open a new PowerShell window, then run:" -ForegroundColor Green
Write-Host "  newproj my-first-app`n" -ForegroundColor Green
