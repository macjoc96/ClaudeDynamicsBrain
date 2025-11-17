# Multi-Environment Setup - Claude Dynamics Brain

This guide explains how to configure Claude Dynamics Brain for multiple environments (development, testing, staging, production).

## Overview

Multi-environment setup allows you to work across different Dynamics 365 instances while keeping credentials secure and configurations organized.

---

## Environment Types

### Development (Local)

**Purpose**: Local development and rapid testing

**Characteristics**:
- Your personal/team development org
- Test data only
- No production data
- Full access
- Frequent changes

**Security Level**: Low (testing only)

```
URL: https://dev-org.crm.dynamics.com
Access: Full
Data: Test only
Purpose: Feature development
```

---

### Testing / UAT

**Purpose**: Team testing and validation before release

**Characteristics**:
- Shared test environment
- Mix of test data and representative production data
- Limited access (test team only)
- Stable (minimal changes)
- Used for QA

**Security Level**: Medium (test data)

```
URL: https://test-org.crm.dynamics.com
Access: Test team only
Data: Test + production samples
Purpose: QA and validation
```

---

### Staging / Pre-Production

**Purpose**: Pre-production validation before going live

**Characteristics**:
- Mirrors production setup
- Full production data copy
- Limited access (admins & release team)
- Read-only in some areas
- Final validation before release

**Security Level**: High (production data)

```
URL: https://staging-org.crm.dynamics.com
Access: Admin/Release team only
Data: Full production copy
Purpose: Production validation
```

---

### Production

**Purpose**: Live system with real customer data

**Characteristics**:
- Live customer data
- Restricted access
- Audit logging
- Change control required
- Backups and disaster recovery

**Security Level**: Critical (real data)

```
URL: https://prod-org.crm.dynamics.com
Access: Restricted to operations team
Data: Real customer data
Purpose: Live operations
```

---

## Setting Up Multiple Environments

### Step 1: Create Azure AD App Registrations

You need a separate Azure AD app registration for each environment.

#### For Each Environment

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** → **App registrations**
3. Click **New registration**
4. **Name**: `Claude Dynamics Brain - [Environment]`
   - Example: `Claude Dynamics Brain - Development`
5. **Supported account types**: Single tenant
6. **Redirect URI**: Web - `http://localhost`
7. Click **Register**

#### Get Credentials

For each app registration:
1. Go to **Overview**
2. Note the **Application (client) ID** - copy this
3. Go to **Certificates & secrets**
4. Click **New client secret**
5. **Description**: `Development credentials`
6. **Expires**: Recommended 2 years
7. Copy the **Value** (this is your client secret)
8. Go to **API permissions**
9. Click **Add a permission**
10. Search for **Dynamics CRM**
11. Select **Dynamics CRM** → **user_impersonation**
12. Click **Add permissions**
13. **Grant admin consent** if prompted

#### Result

For each environment, you now have:
- **Application ID** (Client ID)
- **Client Secret**
- **Tenant ID** (same for all, from your organization)

**Save these securely** - you'll need them in the next steps.

---

### Step 2: Configure Environment Variables

Create environment-specific credentials as system environment variables.

#### Development Environment

**Windows (PowerShell)**:
```powershell
# Set environment variables
[Environment]::SetEnvironmentVariable("DEV_DYNAMICS_URL", "https://dev-org.crm.dynamics.com", "User")
[Environment]::SetEnvironmentVariable("DEV_DYNAMICS_CLIENT_ID", "your-dev-app-id", "User")
[Environment]::SetEnvironmentVariable("DEV_DYNAMICS_CLIENT_SECRET", "your-dev-secret", "User")
[Environment]::SetEnvironmentVariable("DYNAMICS_TENANT_ID", "your-tenant-id", "User")

# Verify
[Environment]::GetEnvironmentVariable("DEV_DYNAMICS_URL", "User")
```

**Linux/macOS (Bash)**:
```bash
# Add to ~/.bashrc or ~/.zshrc
export DEV_DYNAMICS_URL="https://dev-org.crm.dynamics.com"
export DEV_DYNAMICS_CLIENT_ID="your-dev-app-id"
export DEV_DYNAMICS_CLIENT_SECRET="your-dev-secret"
export DYNAMICS_TENANT_ID="your-tenant-id"

# Apply changes
source ~/.bashrc  # or source ~/.zshrc

# Verify
echo $DEV_DYNAMICS_URL
```

#### Testing Environment

```powershell
# Windows
[Environment]::SetEnvironmentVariable("TEST_DYNAMICS_URL", "https://test-org.crm.dynamics.com", "User")
[Environment]::SetEnvironmentVariable("TEST_DYNAMICS_CLIENT_ID", "your-test-app-id", "User")
[Environment]::SetEnvironmentVariable("TEST_DYNAMICS_CLIENT_SECRET", "your-test-secret", "User")
```

```bash
# Linux/macOS
export TEST_DYNAMICS_URL="https://test-org.crm.dynamics.com"
export TEST_DYNAMICS_CLIENT_ID="your-test-app-id"
export TEST_DYNAMICS_CLIENT_SECRET="your-test-secret"
```

#### Staging & Production

Repeat for `STAGING_` and `PROD_` prefixes:

```
STAGING_DYNAMICS_URL
STAGING_DYNAMICS_CLIENT_ID
STAGING_DYNAMICS_CLIENT_SECRET

PROD_DYNAMICS_URL
PROD_DYNAMICS_CLIENT_ID
PROD_DYNAMICS_CLIENT_SECRET
```

---

### Step 3: Create MCP Configuration Files

Create environment-specific MCP configuration files in `.claude/` directory.

#### `.claude/.mcp.development.json`

```json
{
  "mcpServers": {
    "dynamics365": {
      "enabled": true,
      "env": {
        "DYNAMICS_URL": "${DEV_DYNAMICS_URL}",
        "DYNAMICS_CLIENT_ID": "${DEV_DYNAMICS_CLIENT_ID}",
        "DYNAMICS_CLIENT_SECRET": "${DEV_DYNAMICS_CLIENT_SECRET}",
        "DYNAMICS_TENANT_ID": "${DYNAMICS_TENANT_ID}"
      }
    },
    "github": {
      "enabled": true,
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "fetch": {
      "enabled": true
    },
    "filesystem": {
      "enabled": true
    }
  }
}
```

#### `.claude/.mcp.testing.json`

```json
{
  "mcpServers": {
    "dynamics365": {
      "enabled": true,
      "env": {
        "DYNAMICS_URL": "${TEST_DYNAMICS_URL}",
        "DYNAMICS_CLIENT_ID": "${TEST_DYNAMICS_CLIENT_ID}",
        "DYNAMICS_CLIENT_SECRET": "${TEST_DYNAMICS_CLIENT_SECRET}",
        "DYNAMICS_TENANT_ID": "${DYNAMICS_TENANT_ID}"
      }
    },
    "github": {
      "enabled": true,
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

#### `.claude/.mcp.staging.json`

```json
{
  "mcpServers": {
    "dynamics365": {
      "enabled": true,
      "env": {
        "DYNAMICS_URL": "${STAGING_DYNAMICS_URL}",
        "DYNAMICS_CLIENT_ID": "${STAGING_DYNAMICS_CLIENT_ID}",
        "DYNAMICS_CLIENT_SECRET": "${STAGING_DYNAMICS_CLIENT_SECRET}",
        "DYNAMICS_TENANT_ID": "${DYNAMICS_TENANT_ID}"
      }
    },
    "github": {
      "enabled": true,
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

#### `.claude/.mcp.production.json`

```json
{
  "mcpServers": {
    "dynamics365": {
      "enabled": true,
      "env": {
        "DYNAMICS_URL": "${PROD_DYNAMICS_URL}",
        "DYNAMICS_CLIENT_ID": "${PROD_DYNAMICS_CLIENT_ID}",
        "DYNAMICS_CLIENT_SECRET": "${PROD_DYNAMICS_CLIENT_SECRET}",
        "DYNAMICS_TENANT_ID": "${DYNAMICS_TENANT_ID}"
      }
    }
  }
}
```

**Note**: For production, GitHub access may be disabled or restricted to specific users.

---

### Step 4: Create Environment Switching Scripts

#### Windows PowerShell: `setup/switch-environment.ps1`

```powershell
#!/usr/bin/env pwsh
# switch-environment.ps1 - Switch between environments

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("development", "testing", "staging", "production")]
    [string]$Environment
)

$configFile = ".\.claude\.mcp.$Environment.json"
$targetFile = ".\.claude\.mcp.json"

if (Test-Path $configFile) {
    Copy-Item $configFile -Destination $targetFile -Force
    Write-Host "✓ Switched to $Environment environment" -ForegroundColor Green
    Write-Host "  Config: $configFile"
    Write-Host "  Active: $targetFile"
    Write-Host ""
    Write-Host "Restart Claude Code for changes to take effect."
    exit 0
} else {
    Write-Host "✗ Environment configuration not found: $configFile" -ForegroundColor Red
    Write-Host ""
    Write-Host "Available environments:"
    Write-Host "  - development"
    Write-Host "  - testing"
    Write-Host "  - staging"
    Write-Host "  - production"
    exit 1
}
```

**Usage**:
```powershell
# Switch to development
.\setup\switch-environment.ps1 -Environment development

# Switch to testing
.\setup\switch-environment.ps1 -Environment testing

# Switch to production
.\setup\switch-environment.ps1 -Environment production
```

#### Linux/macOS Bash: `setup/switch-env.sh`

```bash
#!/bin/bash
# switch-env.sh - Switch between environments

if [[ $# -eq 0 ]]; then
    echo "Usage: ./setup/switch-env.sh [environment]"
    echo ""
    echo "Available environments:"
    echo "  - development"
    echo "  - testing"
    echo "  - staging"
    echo "  - production"
    exit 1
fi

ENVIRONMENT=$1
CONFIG_FILE="./.claude/.mcp.$ENVIRONMENT.json"
TARGET_FILE="./.claude/.mcp.json"

if [[ -f "$CONFIG_FILE" ]]; then
    cp "$CONFIG_FILE" "$TARGET_FILE"
    echo "✓ Switched to $ENVIRONMENT environment"
    echo "  Config: $CONFIG_FILE"
    echo "  Active: $TARGET_FILE"
    echo ""
    echo "Restart Claude Code for changes to take effect."
    exit 0
else
    echo "✗ Environment configuration not found: $CONFIG_FILE"
    echo ""
    echo "Available environments:"
    echo "  - development"
    echo "  - testing"
    echo "  - staging"
    echo "  - production"
    exit 1
fi
```

**Usage**:
```bash
# Make executable first
chmod +x setup/switch-env.sh

# Switch to development
./setup/switch-env.sh development

# Switch to testing
./setup/switch-env.sh testing

# Switch to production
./setup/switch-env.sh production
```

---

## Working with Multiple Environments

### Checking Current Environment

**View active MCP config**:
```bash
cat .claude/.mcp.json | grep DYNAMICS_URL
```

**View full config**:
```bash
cat .claude/.mcp.json
```

---

### Switching Between Environments

#### Windows
```powershell
# Switch to testing
.\setup\switch-environment.ps1 -Environment testing

# Verify
cat .\.claude\.mcp.json | Select-String "DYNAMICS_URL"

# Restart Claude Code
```

#### Linux/macOS
```bash
# Switch to testing
./setup/switch-env.sh testing

# Verify
grep DYNAMICS_URL ./.claude/.mcp.json

# Restart Claude Code
```

---

### Best Practices for Multi-Environment Work

✅ **DO**:
- Always verify which environment you're in before making changes
- Use descriptive commit messages that mention environment
- Test in development first, then staging, then production
- Document environment-specific differences
- Review changes carefully before production

❌ **DON'T**:
- Mix credentials from different environments
- Test destructive operations in production
- Modify production config without approval
- Forget to switch back to dev after testing
- Hardcode environment names

---

## Environment-Specific Workflows

### Development Workflow

```
1. Start in DEVELOPMENT environment
2. Make code changes
3. Test locally
4. Create branch and PR
5. Get review
6. Merge to main
```

### Testing Workflow

```
1. Code is merged to main (dev environment)
2. Create test branch
3. Switch to TESTING environment
4. Deploy to testing org
5. QA validates changes
6. Approve for staging
```

### Staging Workflow

```
1. QA approves from testing
2. Create staging branch
3. Switch to STAGING environment
4. Deploy to staging org
5. Run final validation
6. Get release approval
```

### Production Workflow

```
1. Staging validated
2. Create release PR
3. Switch to PRODUCTION environment
4. Deploy with monitoring
5. Verify in production
6. Communicate change
```

---

## Troubleshooting

### Problem: Environment not switching

**Symptoms**: Still connected to old environment after switching

**Check**:
1. Did you restart Claude Code?
2. Is the config file path correct?
3. Are environment variables set?

**Fix**:
```bash
# Verify config file exists
ls -la ./.claude/.mcp.*.json

# Verify environment variables are set
echo $DEV_DYNAMICS_URL

# Restart Claude Code completely
# Then try switching again
```

---

### Problem: Can't connect to environment

**Symptoms**: Connection error when trying to access Dynamics

**Check**:
1. Is the URL correct?
2. Are credentials valid?
3. Do you have access to that org?
4. Are environment variables set?

**Fix**:
```bash
# Verify credentials
echo $DEV_DYNAMICS_CLIENT_ID
echo $DYNAMICS_TENANT_ID

# Test URL directly
curl "https://dev-org.crm.dynamics.com/api/data/v9.2/"

# Verify Azure AD app permissions
# (Go to Azure Portal → App registrations → API permissions)
```

---

### Problem: Using wrong environment by accident

**Symptoms**: Made changes in wrong org

**Prevention**:
1. Always verify environment before making changes
2. Add environment name to branch (e.g., `feature/testing-something`)
3. Use validation scripts before operations
4. Require approval for production changes

**Recovery**:
1. Check if changes can be rolled back
2. Restore from backup if needed
3. Document what happened
4. Implement safeguards

---

## Security & Best Practices

### Credential Security

✅ **Secure**:
- Store in environment variables
- Store in secure credential manager
- Rotate regularly
- Different credentials per environment
- Limited access (least privilege)

❌ **Insecure**:
- Hardcoded in scripts
- Shared credentials across environments
- Stored in code repositories
- Never rotated
- Shared with everyone

### Production Access Control

For PRODUCTION environment:
1. Require approval before changes
2. Limit who can switch to production
3. Enable audit logging
4. Monitor all operations
5. Require 2-person rule for critical changes

### Testing Against Production Data

✅ **Safe**:
- Use staging environment with production copy
- Test with anonymized/masked data
- Use test accounts with limited permissions
- Delete test records after validation

❌ **Risky**:
- Direct queries against production
- Modifying production data without approval
- Using admin credentials for testing
- Keeping test records in production

---

## Quick Reference

### All Credentials Required

For each environment (development, testing, staging, production):

```
- DYNAMICS_URL
- DYNAMICS_CLIENT_ID
- DYNAMICS_CLIENT_SECRET
- DYNAMICS_TENANT_ID (same for all)
```

### Configuration Files

```
.claude/
├── .mcp.json (active config)
├── .mcp.development.json
├── .mcp.testing.json
├── .mcp.staging.json
└── .mcp.production.json
```

### Environment Variables

```
DEV_DYNAMICS_URL
DEV_DYNAMICS_CLIENT_ID
DEV_DYNAMICS_CLIENT_SECRET

TEST_DYNAMICS_URL
TEST_DYNAMICS_CLIENT_ID
TEST_DYNAMICS_CLIENT_SECRET

STAGING_DYNAMICS_URL
STAGING_DYNAMICS_CLIENT_ID
STAGING_DYNAMICS_CLIENT_SECRET

PROD_DYNAMICS_URL
PROD_DYNAMICS_CLIENT_ID
PROD_DYNAMICS_CLIENT_SECRET

DYNAMICS_TENANT_ID (shared)
GITHUB_TOKEN (optional)
```

---

## Getting Help

- **Questions**: Check this guide or ask team lead
- **Connection issues**: Verify credentials in Azure AD
- **Access denied**: Check permissions in target org
- **Data issues**: Check environment before operations
- **Credentials lost**: Create new Azure AD app registration

---

## Summary

Multi-environment setup allows you to:
1. ✅ Work on multiple Dynamics orgs safely
2. ✅ Keep credentials organized and secure
3. ✅ Test changes before production
4. ✅ Follow proper deployment workflows
5. ✅ Reduce risk of mistakes

**Key Takeaway**: Always verify which environment you're in before making changes!

---

**Last Updated**: November 16, 2025
**Version**: 1.0
**Author**: Claude Dynamics Brain Team
