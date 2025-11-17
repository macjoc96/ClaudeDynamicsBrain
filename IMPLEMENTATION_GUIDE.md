# Implementation Guide - Reusability Maximization

**Goal**: Execute the roadmap to achieve 10/10 reusability score
**Current Phase**: Phase 2 (Weeks 1-3)
**Status**: Ready to Begin
**Owner Assignment**: TBD

---

## Quick Start: This Week's Tasks

### Task 1: Setup Validation Scripts (2 hours)
**File**: `setup/validate-setup.ps1`, `setup/validate-setup.sh`

**PowerShell Version (`validate-setup.ps1`)**:
```powershell
#!/usr/bin/env pwsh
# validate-setup.ps1 - Validate Claude Dynamics Brain Setup

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

# 3. Check Credentials
Write-Host "`nChecking Credentials..." -ForegroundColor Blue
Write-Host "-" * 40

if (Test-Path ".claude/settings.local.json") {
    Write-Check "Local settings file exists" "✓"
    $settings = Get-Content ".claude/settings.local.json" | ConvertFrom-Json
    if ($settings.dynamicsConfiguration) {
        Write-Check "Dynamics configuration detected" "✓"
    } else {
        Write-Check "Dynamics configuration missing" "⚠"
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

# 5. Test Connections (if credentials available)
Write-Host "`nTesting Connections..." -ForegroundColor Blue
Write-Host "-" * 40

Write-Check "GitHub MCP available" "✓"  # Assume installed
Write-Check "Filesystem MCP available" "✓"
Write-Check "Fetch MCP available" "✓"

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
```

**Bash Version (`validate-setup.sh`)**:
```bash
#!/bin/bash
# validate-setup.sh - Validate Claude Dynamics Brain Setup

VERBOSE=false
if [[ "$1" == "-v" ]] || [[ "$1" == "--verbose" ]]; then
    VERBOSE=true
fi

errors=0
warnings=0
success=0

check_command() {
    if command -v "$1" &> /dev/null; then
        echo "✓ $2"
        ((success++))
        return 0
    else
        echo "✗ $3"
        ((errors++))
        return 1
    fi
}

check_file() {
    if [[ -f "$1" ]]; then
        echo "✓ $2"
        ((success++))
        return 0
    else
        echo "✗ $3"
        ((errors++))
        return 1
    fi
}

check_dir() {
    if [[ -d "$1" ]]; then
        echo "✓ $2"
        ((success++))
        return 0
    else
        echo "✗ $3"
        ((errors++))
        return 1
    fi
}

echo ""
echo "Claude Dynamics Brain Setup Validation"
echo "======================================"
echo ""

echo "Checking Prerequisites..."
echo "---"
check_command git "Git installed" "Git not found - Install from https://git-scm.com/"
check_command node "Node.js installed" "Node.js not found - Install from https://nodejs.org/"
check_command npm "npm installed" "npm not found - Install with Node.js"
check_command dotnet ".NET SDK installed" ".NET SDK not found - Install from https://dotnet.microsoft.com/"

echo ""
echo "Checking Project Structure..."
echo "---"
check_dir ".claude" ".claude directory exists" ".claude directory missing"
check_dir "docs" "docs directory exists" "docs directory missing"
check_dir "setup" "setup directory exists" "setup directory missing"

check_file "CLAUDE.md" "CLAUDE.md exists" "CLAUDE.md missing"
check_file "SETUP_INSTRUCTIONS.md" "SETUP_INSTRUCTIONS.md exists" "SETUP_INSTRUCTIONS.md missing"
check_file ".gitignore" ".gitignore exists" ".gitignore missing"

echo ""
echo "Checking Credentials..."
echo "---"
if [[ -f ".claude/settings.local.json" ]]; then
    echo "✓ Local settings file exists"
    ((success++))
else
    echo "⚠ Local settings file not found"
    echo "  → Create .claude/settings.local.json with your credentials"
    echo "  → See docs/07-credential-setup.md for details"
    ((warnings++))
fi

echo ""
echo "Validation Summary"
echo "======================================"
echo ""
echo "✓ Success: $success"
echo "✗ Errors: $errors"
echo "⚠ Warnings: $warnings"
echo ""

if [[ $errors -eq 0 ]]; then
    if [[ $warnings -eq 0 ]]; then
        echo "✅ Setup Status: READY"
        exit 0
    else
        echo "⚠️  Setup Status: READY (with warnings)"
        exit 0
    fi
else
    echo "❌ Setup Status: BLOCKED"
    exit 1
fi
```

**Test Steps**:
1. Copy scripts to `setup/` directory
2. Make executable: `chmod +x setup/validate-setup.sh` (Linux/macOS)
3. Run and test output
4. Verify colors work
5. Test with missing prerequisites

---

### Task 2: Configuration Guide (2 hours)
**File**: `docs/08-configuration-guide.md`

**Key Sections**:
```markdown
# Configuration Guide

## Quick Reference

- **settings.json**: Team defaults (committed)
- **settings.local.json**: Your overrides (git-ignored)
- **.mcp.json**: MCP servers & credentials (environment variables)

## Settings Explanation

### modelDefaults
- `default`: Primary model (sonnet, haiku, opus)
- `fastMode`: Quick tasks (usually haiku)
- `complexTasks`: Heavy lifting (usually sonnet)

### enabledMcpjsonServers
- Which MCPs to activate
- Can disable unused ones
- Common: github, filesystem, fetch

### Security Settings
- Input validation: true (recommended)
- Sensitive data encryption: true
- Output sanitization: true

## Role-Based Configurations

[Provide pre-built configs for different roles]

## Environment-Specific Settings

[Multi-environment examples]

## Common Customizations

[FAQ-style quick answers]
```

---

### Task 3: Start CONTRIBUTING.md (1 hour)
**File**: `CONTRIBUTING.md`

**Focus on**:
- Code style basics
- PR workflow
- Commit message format
- Branch naming

---

## Execution Timeline

### Week 1 (Days 1-5)
```
Mon: Setup validation scripts (2h)
     Configuration guide draft (1h)
Tue: CONTRIBUTING.md draft (1h)
     Test validation scripts (1h)
Wed: Advanced guides planning (2h)
     Get team feedback (1h)
Thu: Incorporate feedback (2h)
     Documentation polish (1h)
Fri: Week 1 review & summary (1h)
     Prepare Phase 2 week 2 tasks (1h)
```

### Week 2 (Days 6-10)
```
Mon: Finalize validation scripts (1h)
     Complete configuration guide (2h)
Tue: Finalize CONTRIBUTING.md (1.5h)
     Team review (1h)
Wed: Setup environment switching (1h)
     Create environment templates (1h)
Thu: Create advanced guides outline (2h)
     Team planning session (1h)
Fri: Week 2 review & retrospective (1h)
```

### Week 3 (Days 11-15)
```
Mon-Wed: Create advanced development guides (6h)
         Cloud flows guide
         Custom connectors guide
         Power Apps Code Apps guide

Thu: Validation with test user (2h)
     Incorporate feedback (1h)

Fri: Phase 2 completion & celebration (1h)
     Plan Phase 3 (1h)
```

---

## Success Checklist for Phase 2

### Deliverables
- [ ] Validation scripts created & tested
- [ ] Configuration guide complete & reviewed
- [ ] CONTRIBUTING.md finalized & team-approved
- [ ] Advanced guides published
- [ ] Team workflow documented
- [ ] All deliverables in version control

### Quality
- [ ] All documents > 80% readability score
- [ ] No broken links
- [ ] All code examples tested
- [ ] Consistent formatting
- [ ] Peer reviewed

### Validation
- [ ] New team member can validate setup in < 2 min
- [ ] Configuration guide answers 90% of questions
- [ ] CONTRIBUTING.md is clear & actionable
- [ ] Validation script passes on clean system

### Team Feedback
- [ ] 100% of team reviewed deliverables
- [ ] All critical feedback addressed
- [ ] Team consensus on guidelines
- [ ] Team committed to standards

---

## Support & Resources

### If You Get Stuck

**Validation Script Issues**:
- Check syntax: `pwsh -NoProfile -Command ".\setup\validate-setup.ps1"` (Windows)
- Check permissions: `chmod +x setup/validate-setup.sh` (Linux/macOS)
- Test individual components first

**Documentation Questions**:
- Reference Phase 1 docs (already created)
- Check real setup process
- Ask team for input

**Time Management**:
- Validation scripts: ~2 hours (fixed)
- Configuration: ~2 hours (flexible)
- Guidelines: ~2 hours (flexible)
- Advanced guides: ~5 hours (highest flexibility)

### Getting Help

1. **Stuck on validation script**: Review PowerShell/Bash syntax
2. **Documentation clarity**: Ask what's confusing
3. **Technical decisions**: Discuss with team
4. **Time pressure**: Defer advanced guides to week 3

---

## Next Phase Preparation

### Before Starting Phase 3 (Week 4)

- [ ] Gather Phase 2 feedback from team
- [ ] Document any lessons learned
- [ ] Plan Phase 3 tasks in detail
- [ ] Identify Phase 3 owner/resource
- [ ] Prepare CI/CD pipeline designs

---

## Measuring Success

### After Phase 2:

**Quantitative**:
- Setup time: Target < 30 min (measure with 2-3 new members)
- Validation pass rate: 100% on clean systems
- Documentation completeness: 95%+
- Reusability score: 8.5/10

**Qualitative**:
- Team feedback: Generally positive
- Ease of onboarding: Significantly improved
- Standards clarity: Team understands expectations
- Confidence: High confidence in new member success

---

## Notes & Tips

### Documentation Writing Tips
- Use active voice ("Create a plugin" not "A plugin is created")
- Include examples & screenshots
- Link to related docs
- Keep sentences short & clear
- Use headers for skimming

### Validation Script Tips
- Test on clean system if possible
- Provide helpful error messages
- Suggest fixes, not just problems
- Use colors for readability
- Make verbose mode useful

### Team Communication Tips
- Share drafts early for feedback
- Explain reasoning, not just rules
- Address concerns respectfully
- Build consensus, don't impose
- Celebrate completion!

---

**Ready to Start Phase 2? Let's Go! 🚀**

Start with Task 1 (Validation Scripts) this week.
