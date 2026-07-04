# new-project.ps1
# Scaffolds a new project from the personal Claude Code template, then hands
# off directly into a Claude Code session so /setup-project can take over.
#
# Usage:
#   .\new-project.ps1 -Name my-cool-app
#   .\new-project.ps1 -Name my-cool-app -Path "C:\Users\Elkan\dev"

param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [string]$Path = "$HOME\dev",

    [string]$ConfigRoot = "C:\Users\Elkan\dev\claude-config"
)

$TemplateRoot = Join-Path $ConfigRoot "project-template"
$Destination  = Join-Path $Path $Name

if (-not (Test-Path $TemplateRoot)) {
    Write-Error "Template not found at $TemplateRoot — check -ConfigRoot."
    exit 1
}

if (Test-Path $Destination) {
    Write-Error "'$Destination' already exists — pick a different name or -Path."
    exit 1
}

Write-Host "Scaffolding '$Name' at $Destination ..."

New-Item -ItemType Directory -Force -Path $Destination | Out-Null

# Copy the template's real contents — deliberately skips the template's own
# README.md and gitignore.append.txt, since those are meta-docs about the
# template itself, not files a real project should end up with.
Copy-Item "$TemplateRoot\CLAUDE.md" "$Destination\CLAUDE.md"
Copy-Item "$TemplateRoot\.mcp.json" "$Destination\.mcp.json"
Copy-Item "$TemplateRoot\.claude" "$Destination\.claude" -Recurse

# settings.local.json.example -> settings.local.json (gitignored, not committed)
Move-Item "$Destination\.claude\settings.local.json.example" "$Destination\.claude\settings.local.json"

# Build .gitignore from the template's snippet, dropping its instructional header
Get-Content "$TemplateRoot\gitignore.append.txt" | Select-Object -Skip 2 | Set-Content "$Destination\.gitignore"

Set-Location $Destination
git init | Out-Null
git add .
git commit -m "Scaffold from personal Claude Code template" | Out-Null

Write-Host ""
Write-Host "'$Name' is ready at $Destination"
Write-Host "Dropping you into Claude Code now — run /setup-project once it opens."
Write-Host ""

claude
