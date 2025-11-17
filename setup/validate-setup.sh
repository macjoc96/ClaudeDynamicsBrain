#!/bin/bash
# validate-setup.sh - Validate Claude Dynamics Brain Setup
# This script checks prerequisites, project structure, credentials, and connections

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

# 1. Check Prerequisites
echo "Checking Prerequisites..."
echo "---"
check_command git "Git installed" "Git not found - Install from https://git-scm.com/"
check_command node "Node.js installed" "Node.js not found - Install from https://nodejs.org/"
check_command npm "npm installed" "npm not found - Install with Node.js"
check_command dotnet ".NET SDK installed" ".NET SDK not found - Install from https://dotnet.microsoft.com/"

# 2. Check Project Structure
echo ""
echo "Checking Project Structure..."
echo "---"
check_dir ".claude" ".claude directory exists" ".claude directory missing"
check_dir "docs" "docs directory exists" "docs directory missing"
check_dir "setup" "setup directory exists" "setup directory missing"

check_file "CLAUDE.md" "CLAUDE.md exists" "CLAUDE.md missing"
check_file "SETUP_INSTRUCTIONS.md" "SETUP_INSTRUCTIONS.md exists" "SETUP_INSTRUCTIONS.md missing"
check_file ".gitignore" ".gitignore exists" ".gitignore missing"
check_file ".claude/settings.json" ".claude/settings.json exists" ".claude/settings.json missing"
check_file ".claude/.mcp.json" ".claude/.mcp.json exists" ".claude/.mcp.json missing"

# 3. Check Credentials
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

# 4. Check Environment Variables
echo ""
echo "Checking Environment Variables..."
echo "---"
env_vars=("DYNAMICS_URL" "DYNAMICS_CLIENT_ID" "DYNAMICS_CLIENT_SECRET" "DYNAMICS_TENANT_ID")
found_count=0
for var in "${env_vars[@]}"; do
    if [[ -n "${!var}" ]]; then
        echo "✓ $var set"
        ((success++))
        ((found_count++))
    fi
done
if [[ $found_count -eq 0 ]]; then
    echo "⚠ No environment variables found"
    echo "  → Set environment variables OR use .claude/settings.local.json"
    ((warnings++))
fi

# 5. Check MCP Configuration
echo ""
echo "Checking MCP Configuration..."
echo "---"
if [[ -f ".claude/.mcp.json" ]]; then
    echo "✓ MCP configuration file exists"
    ((success++))
    if command -v jq &> /dev/null; then
        if jq empty ".claude/.mcp.json" 2>/dev/null; then
            echo "✓ MCP configuration is valid JSON"
            ((success++))
        else
            echo "✗ MCP configuration file is invalid JSON"
            ((errors++))
        fi
    fi
else
    echo "✗ MCP configuration file missing"
    ((errors++))
fi

# 6. Summary
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
