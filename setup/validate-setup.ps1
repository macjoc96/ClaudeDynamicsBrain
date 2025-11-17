#!/usr/bin/env pwsh
# validate-setup.ps1 - Validate Claude Dynamics Brain Setup
# This script checks prerequisites, project structure, credentials, and connections

[CmdletBinding()]
param(
    [Switch]$Verbose = $false,
    [Switch]$Report = $false
)

$script:errors = @()
$script:warnings = @()
$script:success = @()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

function Write-Check([string]$message, [string]$status, [string]$color = "Green") {
    if ($status -eq "✓") {
        Write-Host "✓ $message" -ForegroundColor Green
        $script:success += $message
    } elseif ($status -eq "✗") {
        Write-Host "✗ $message" -ForegroundColor Red
        $script:errors += $message
    } elseif ($status -eq "⚠") {
        Write-Host "⚠ $message" -ForegroundColor Yellow
        $script:warnings += $message
    }
}

Write-Host "`nClaude Dynamics Brain Setup Validation" -ForegroundColor Cyan
Write-Host "======================================`n"

# 1. Check Prerequisites
Write-Host "Checking Prerequisites..." -ForegroundColor Blue
Write-Host "-" * 40

try {
    $gitVersion = git --version
    Write-Check "Git installed" "✓"
    if ($Verbose) { Write-Host "  Version: $gitVersion" }
} catch {
    Write-Check "Git not found - Install from https://git-scm.com/" "✗"
}

try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Check "Node.js $nodeVersion installed" "✓"
    Write-Check "npm $npmVersion installed" "✓"
    if ($Verbose) {
        Write-Host "  Node: $nodeVersion`n  npm: $npmVersion"
    }
} catch {
    Write-Check "Node.js/npm not found - Install from https://nodejs.org/" "✗"
}

try {
    $dotnetVersion = dotnet --version
    Write-Check ".NET SDK $dotnetVersion installed" "✓"
} catch {
    Write-Check ".NET SDK not found - Install from https://dotnet.microsoft.com/" "✗"
}

# 2. Check Project Structure
Write-Host "`nChecking Project Structure..." -ForegroundColor Blue
Write-Host "-" * 40

$requiredDirs = @(".claude", "docs", "setup")
foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Check "$dir directory exists" "✓"
    } else {
        Write-Check "$dir directory missing" "✗"
    }
}

$requiredFiles = @("CLAUDE.md", "SETUP_INSTRUCTIONS.md", ".gitignore", ".claude/settings.json", ".claude/.mcp.json")
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Check "$file exists" "✓"
    } else {
        Write-Check "$file missing" "✗"
    }
}

# 3. Check Credentials Configuration
Write-Host "`nChecking Credentials..." -ForegroundColor Blue
Write-Host "-" * 40

if (Test-Path ".claude/settings.local.json") {
    Write-Check "Local settings file exists" "✓"
    try {
        $settings = Get-Content ".claude/settings.local.json" | ConvertFrom-Json
        if ($settings.dynamicsConfiguration) {
            Write-Check "Dynamics configuration detected" "✓"
        } else {
            Write-Check "Dynamics configuration missing" "⚠"
        }
    } catch {
        Write-Check "Local settings file is invalid JSON" "⚠"
    }
} else {
    Write-Check "Local settings file not found" "⚠"
    Write-Host "  → Create .claude/settings.local.json with your credentials`n  → See docs/07-credential-setup.md for details"
}

# 4. Check Environment Variables
Write-Host "`nChecking Environment Variables..." -ForegroundColor Blue
Write-Host "-" * 40

$envVars = @("DYNAMICS_URL", "DYNAMICS_CLIENT_ID", "DYNAMICS_CLIENT_SECRET", "DYNAMICS_TENANT_ID")
$foundCount = 0
foreach ($var in $envVars) {
    $value = [System.Environment]::GetEnvironmentVariable($var)
    if ($value) {
        Write-Check "$var set" "✓"
        $foundCount++
    }
}
if ($foundCount -eq 0) {
    Write-Check "No environment variables found" "⚠"
    Write-Host "  → Set environment variables OR use .claude/settings.local.json"
}

# 5. Check MCP Configuration
Write-Host "`nChecking MCP Configuration..." -ForegroundColor Blue
Write-Host "-" * 40

if (Test-Path ".claude/.mcp.json") {
    Write-Check "MCP configuration file exists" "✓"
    try {
        $mcpConfig = Get-Content ".claude/.mcp.json" | ConvertFrom-Json
        Write-Check "MCP configuration is valid JSON" "✓"
    } catch {
        Write-Check "MCP configuration file is invalid JSON" "✗"
    }
} else {
    Write-Check "MCP configuration file missing" "✗"
}

# 6. Summary
Write-Host "`nValidation Summary" -ForegroundColor Cyan
Write-Host "======================================`n"

Write-Host "✓ Success: $($script:success.Count)" -ForegroundColor Green
Write-Host "✗ Errors: $($script:errors.Count)" -ForegroundColor Red
Write-Host "⚠ Warnings: $($script:warnings.Count)" -ForegroundColor Yellow

if ($script:errors.Count -eq 0 -and $script:warnings.Count -eq 0) {
    Write-Host "`n✅ Setup Status: READY" -ForegroundColor Green
    exit 0
} elseif ($script:errors.Count -eq 0) {
    Write-Host "`n⚠️  Setup Status: READY (with warnings)" -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "`n❌ Setup Status: BLOCKED" -ForegroundColor Red
    Write-Host "`nTo fix:`n"
    $script:errors | ForEach-Object { Write-Host "  • $_" }
    exit 1
}
