# Credential Setup Guide

Complete guide for setting up and managing credentials for Dynamics 365, Power Platform, and GitHub integration with Claude Dynamics Brain.

---

## Table of Contents

1. [Overview](#overview)
2. [Dynamics 365 Credentials](#dynamics-365-credentials)
3. [GitHub Credentials](#github-credentials)
4. [Environment Variables](#environment-variables)
5. [Secure Storage](#secure-storage)
6. [Credential Rotation](#credential-rotation)
7. [Troubleshooting](#troubleshooting)

---

## Overview

Claude Dynamics Brain requires credentials for:

| Service | Purpose | Required | Details |
|---------|---------|----------|---------|
| **Dynamics 365** | Access Dataverse and organizational data | YES | Org URL, Tenant ID, Client ID, Secret |
| **Power Platform** | Manage flows and connectors | Optional | Same as Dynamics 365 |
| **GitHub** | Code search and repository access | Optional | Personal access token |

**Security Principle**: Credentials are **NEVER** hardcoded or committed to version control.

---

## Dynamics 365 Credentials

### What You Need

To connect to Dynamics 365, you need four pieces of information:

1. **Organization URL**
   - Format: `https://orgname.crm.dynamics.com`
   - Example: `https://contoso.crm.dynamics.com`
   - Do NOT include `/main.aspx` or other paths

2. **Azure AD Tenant ID**
   - Format: GUID (32 characters with hyphens)
   - Example: `12345678-1234-1234-1234-123456789012`

3. **Client ID (Application ID)**
   - Format: GUID
   - Created when registering app in Azure AD
   - Example: `87654321-4321-4321-4321-210987654321`

4. **Client Secret**
   - Format: Long alphanumeric string
   - Created in Azure AD Certificates & secrets
   - Example: `Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c=`
   - **⚠️ IMPORTANT**: You cannot recover this later. Save it immediately.

### Step 1: Create Azure AD App Registration

#### Via Azure Portal (Recommended)

1. **Open Azure Portal**
   - Go to [portal.azure.com](https://portal.azure.com)
   - Sign in with your organizational account

2. **Navigate to App Registrations**
   - Click **Azure Active Directory** in left menu
   - Click **App registrations**
   - Click **+ New registration**

3. **Register Application**
   - **Name**: `Claude Dynamics Brain [Team Name]`
     - Good examples:
       - `Claude Dynamics Brain Engineering`
       - `Claude Dynamics Brain Development`
       - `Claude Dynamics Brain [YourName]` (if personal)

   - **Supported account types**: `Accounts in this organizational directory only`
     - This is more secure than multi-tenant

   - **Redirect URI**: Leave blank
     - Not needed for CLI/service principal

   - Click **Register**

4. **Copy Credentials from Overview Page**

   After registration completes, you're on the Overview page.

   - **Application (client) ID**: Copy this value
     - This is your Client ID
     - Save it securely

   - **Directory (tenant) ID**: Copy this value
     - This is your Tenant ID
     - Save it securely

   ```
   Overview page shows:
   ┌─────────────────────────────────────────┐
   │ Application (client) ID                 │
   │ 87654321-4321-4321-4321-210987654321 ← │ COPY THIS
   │ Directory (tenant) ID                   │
   │ 12345678-1234-1234-1234-123456789012 ← │ COPY THIS
   └─────────────────────────────────────────┘
   ```

5. **Create Client Secret**

   - In left menu, click **Certificates & secrets**
   - Click **+ New client secret** button
   - Fill in dialog:
     - **Description**: `claude-dynamics-brain`
     - **Expires**: Recommended `6 months` (for rotation)
     - Click **Add**

   - **⚠️ CRITICAL**: Copy the secret value IMMEDIATELY
     - You will NOT see it again after you leave this page
     - If you lose it, you must create a new one

   ```
   Client secrets shows:
   ┌──────────────────────────────────────────┐
   │ Description │ Expires │ Value            │
   │ claude...   │ 6 mo    │ Eby8vdM02x... ← │ COPY IMMEDIATELY
   └──────────────────────────────────────────┘
   ```

   - Save in secure location (see [Secure Storage](#secure-storage))

#### Via Azure CLI

```bash
# Login to Azure
az login

# Set variables
$appName = "Claude Dynamics Brain"
$description = "Claude development environment for Dynamics 365"

# Create app registration
$app = az ad app create \
  --display-name $appName \
  --description $description \
  --output json

# Get the Application ID
$clientId = $app.appId
echo "Client ID: $clientId"

# Create service principal
az ad sp create --id $clientId

# Create client secret
$secret = az ad app credential reset \
  --id $clientId \
  --credential-description "claude-dynamics-brain" \
  --output json

# Display secret (save immediately!)
echo "Client Secret: $secret.password"
echo "Secret ID: $secret.keyId"
```

### Step 2: Grant Dynamics 365 Permissions

Your app needs permission to access Dynamics 365.

1. **Go to API Permissions**
   - Still in Azure Portal
   - Click **API permissions** in left menu

2. **Add Permission**
   - Click **+ Add a permission**
   - Click **APIs my organization uses**
   - Search for `Dynamics CRM`
   - Click on **Dynamics CRM** result

3. **Select Scopes**
   - Select **Delegated permissions**
   - Check: ✓ `user_impersonation`
   - This allows the app to access data on behalf of users
   - Click **Add permissions**

4. **Grant Admin Consent**
   - Click **Grant admin consent for [Organization]**
   - Click **Yes** in confirmation dialog
   - Status changes to "Granted" (green checkmark)
   - This allows the app to work without additional user consent

### Step 3: Get Dynamics 365 Organization URL

1. **Open Dynamics 365**
   - Sign in to your Dynamics 365 instance
   - Look at browser URL bar
   - Copy the domain part

   ```
   Browser shows:
   https://contoso.crm.dynamics.com/main.aspx?...
                     ↑
   Take just: https://contoso.crm.dynamics.com
   ```

2. **Format URL Correctly**
   - ✅ Correct: `https://contoso.crm.dynamics.com`
   - ❌ Wrong: `https://contoso.crm.dynamics.com/main.aspx`
   - ❌ Wrong: `https://contoso.crm.microsoft.com`

### Step 4: Verify Credentials Work

Before saving credentials, test the connection:

```bash
# Test with curl (verify organization URL is correct)
curl https://contoso.crm.dynamics.com

# Test with Azure CLI (verify credentials work)
az account get-access-token --resource https://contoso.crm.dynamics.com
```

---

## GitHub Credentials

### When You Need GitHub Credentials

GitHub integration is **optional** but recommended for:
- Code search across repositories
- Browsing implementation examples
- Accessing shared templates from GitHub

### Get GitHub Personal Access Token

1. **Go to GitHub Settings**
   - Go to [github.com/settings/tokens](https://github.com/settings/tokens)
   - Or: GitHub menu → Settings → Developer settings → Personal access tokens

2. **Create New Token**
   - Click **Generate new token** (classic)
   - Enter name: `Claude Dynamics Brain`
   - Set expiration: 30 days (or your org's policy)

3. **Select Scopes**
   - Check these permissions:
     - ✓ `repo` - Full control of private repositories
     - ✓ `read:org` - Read organization data
     - ✓ `gist` - Create gists
   - Scopes needed:
     ```
     repo (all)
     ├── repo:status - Access commit status
     ├── repo_deployment - Access deployment status
     ├── public_repo - Access public repositories
     └── repo:invite - Accept/manage invitations
     read:org
     gist
     ```

4. **Generate and Copy**
   - Click **Generate token**
   - **⚠️ COPY IMMEDIATELY** - You won't see it again
   - Token format: `ghp_` followed by letters and numbers
   - Example: `ghp_16C7e42F292c6912E7710c838347Ae178B4a`

5. **Save Securely**
   - See [Secure Storage](#secure-storage) section

### Testing GitHub Connection

```bash
# Test with curl
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user

# Should return your GitHub profile information
```

---

## Environment Variables

### Using Environment Variables

Instead of hardcoding credentials in files, use environment variables:

```bash
# Set environment variables
export DYNAMICS_URL="https://contoso.crm.dynamics.com"
export DYNAMICS_CLIENT_ID="87654321-4321-4321-4321-210987654321"
export DYNAMICS_CLIENT_SECRET="Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c="
export DYNAMICS_TENANT_ID="12345678-1234-1234-1234-123456789012"
export GITHUB_TOKEN="ghp_16C7e42F292c6912E7710c838347Ae178B4a"
```

### Setting Environment Variables

#### Windows (PowerShell)

**Permanently** (system):
```powershell
# Set system environment variable (requires Admin)
[System.Environment]::SetEnvironmentVariable(
  "DYNAMICS_URL",
  "https://contoso.crm.dynamics.com",
  "Machine"
)

# Verify
$env:DYNAMICS_URL
```

**Session only**:
```powershell
# Temporary for current PowerShell session
$env:DYNAMICS_URL = "https://contoso.crm.dynamics.com"
```

**In .env file**:
```bash
# Create .env file (not committed to git)
DYNAMICS_URL=https://contoso.crm.dynamics.com
DYNAMICS_CLIENT_ID=87654321-4321-4321-4321-210987654321
DYNAMICS_CLIENT_SECRET=Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c=
DYNAMICS_TENANT_ID=12345678-1234-1234-1234-123456789012
GITHUB_TOKEN=ghp_16C7e42F292c6912E7710c838347Ae178B4a

# Load with: Get-Content .env | ForEach-Object { ... }
```

#### macOS/Linux

**Permanently** (bash):
```bash
# Add to ~/.bashrc or ~/.zshrc
export DYNAMICS_URL="https://contoso.crm.dynamics.com"
export DYNAMICS_CLIENT_ID="87654321-4321-4321-4321-210987654321"
export DYNAMICS_CLIENT_SECRET="Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c="
export DYNAMICS_TENANT_ID="12345678-1234-1234-1234-123456789012"
export GITHUB_TOKEN="ghp_16C7e42F292c6912E7710c838347Ae178B4a"

# Reload shell
source ~/.bashrc
```

**Session only**:
```bash
export DYNAMICS_URL="https://contoso.crm.dynamics.com"
export DYNAMICS_CLIENT_ID="..."
```

**In .env file**:
```bash
# Create .env (not committed)
DYNAMICS_URL=https://contoso.crm.dynamics.com
DYNAMICS_CLIENT_ID=87654321-4321-4321-4321-210987654321
DYNAMICS_CLIENT_SECRET=Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c=
DYNAMICS_TENANT_ID=12345678-1234-1234-1234-123456789012
GITHUB_TOKEN=ghp_16C7e42F292c6912E7710c838347Ae178B4a

# Load with: source .env
```

### Verify Environment Variables

```bash
# Windows (PowerShell)
echo $env:DYNAMICS_URL
echo $env:GITHUB_TOKEN

# macOS/Linux
echo $DYNAMICS_URL
echo $GITHUB_TOKEN
```

---

## Secure Storage

### Local File Storage

**Location**: `.claude/settings.local.json`

```json
{
  "dynamicsConfiguration": {
    "instanceUrl": "https://contoso.crm.dynamics.com",
    "clientId": "87654321-4321-4321-4321-210987654321",
    "clientSecret": "Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c=",
    "tenantId": "12345678-1234-1234-1234-123456789012"
  },
  "github": {
    "token": "ghp_16C7e42F292c6912E7710c838347Ae178B4a"
  }
}
```

**Security Considerations**:
- ✅ File is in `.gitignore` (won't be committed)
- ✅ File is readable/writable by user only (permissions: 600)
- ✅ Not accessible to other users on shared systems
- ⚠️ Still stored in plain text locally
- ⚠️ If laptop is stolen, credentials could be compromised

**Better: Operating System Credential Storage**

#### Windows Credential Manager

```powershell
# Store credential
$credential = New-Object System.Management.Automation.PSCredential(
  "dynamics365-client",
  (ConvertTo-SecureString "Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c=" -AsPlainText -Force)
)
$credential | Export-Clixml -Path "$env:APPDATA\Dynamics365\credential.xml" -Force

# Retrieve credential
$credential = Import-Clixml -Path "$env:APPDATA\Dynamics365\credential.xml"
$secret = $credential.GetNetworkCredential().Password
```

#### macOS Keychain

```bash
# Store credential
security add-generic-password -s "dynamics365-client-secret" \
  -a "claude-dynamics" \
  -w "Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c="

# Retrieve credential
security find-generic-password -s "dynamics365-client-secret" -w
```

#### Linux Credential Manager (pass)

```bash
# Install pass
sudo apt-get install pass

# Initialize password store
pass init your-gpg-key-id

# Store credential
pass insert dynamics365/client-secret
# Prompts for password, enter: Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c=

# Retrieve credential
pass show dynamics365/client-secret
```

### CI/CD Environment Variables

For GitHub Actions, Azure DevOps, etc.:

#### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy solution
        env:
          DYNAMICS_URL: ${{ secrets.DYNAMICS_URL }}
          DYNAMICS_CLIENT_ID: ${{ secrets.DYNAMICS_CLIENT_ID }}
          DYNAMICS_CLIENT_SECRET: ${{ secrets.DYNAMICS_CLIENT_SECRET }}
          DYNAMICS_TENANT_ID: ${{ secrets.DYNAMICS_TENANT_ID }}
        run: |
          ./deploy.sh
```

**Setup secrets**:
1. Go to GitHub repository
2. Settings → Secrets and variables → Actions
3. Click **New repository secret**
4. Add each secret:
   - `DYNAMICS_URL`
   - `DYNAMICS_CLIENT_ID`
   - `DYNAMICS_CLIENT_SECRET`
   - `DYNAMICS_TENANT_ID`

#### Azure DevOps

```yaml
# azure-pipelines.yml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  - group: 'Dynamics365Credentials'  # Variable group

stages:
  - stage: Deploy
    jobs:
      - job: DeployDynamics
        steps:
          - script: |
              echo "##vso[task.setvariable variable=dynamicsUrl]$(DYNAMICS_URL)"
            displayName: 'Set variables'
```

**Setup variable group**:
1. Azure DevOps project
2. Pipelines → Library → + Variable group
3. Name: `Dynamics365Credentials`
4. Add variables, mark as secret:
   - `DYNAMICS_URL`
   - `DYNAMICS_CLIENT_ID`
   - `DYNAMICS_CLIENT_SECRET`
   - `DYNAMICS_TENANT_ID`

---

## Credential Rotation

### When to Rotate Credentials

**Quarterly** (recommended):
```
Jan 1, Apr 1, Jul 1, Oct 1
```

**Immediately**:
- [ ] Team member leaves
- [ ] Credential accidentally committed to GitHub
- [ ] Security breach suspected
- [ ] Credential expires (check Azure Portal)

### Rotation Steps

1. **Create New Secret in Azure Portal**

   - Azure Portal → App registrations → Your app
   - Click **Certificates & secrets**
   - Click **+ New client secret**
   - Fill in: Description: `claude-dynamics-brain-[date]`, Expires: 6 months
   - Copy new secret immediately
   - Note: Keep old secret for 24 hours (transition period)

2. **Update Local Configuration**

   - Edit `.claude/settings.local.json`
   - Replace old secret with new one:
   ```json
   {
     "dynamicsConfiguration": {
       "clientSecret": "NEW_SECRET_HERE"
     }
   }
   ```

3. **Test Connection**

   - Run validation script:
   ```bash
   ./setup/validate-setup.sh
   ```
   - Should see: `✓ Dynamics 365 connection successful`

4. **Delete Old Secret**

   - Azure Portal → App registrations → Your app
   - Click **Certificates & secrets**
   - Find old secret
   - Click **Delete** (trash icon)
   - Confirm deletion

5. **Notify Team**

   - Post in team chat: "Credentials rotated - all systems nominal"
   - If issues arise, team members can reach out

### Automating Rotation

Use Azure automation to rotate secrets:

```powershell
# rotate-credentials.ps1
param(
    [string]$AppId = "87654321-4321-4321-4321-210987654321",
    [string]$TenantId = "12345678-1234-1234-1234-123456789012"
)

# Login to Azure
Connect-AzAccount -TenantId $TenantId

# Create new secret
$newSecret = New-AzADAppCredential -ApplicationId $AppId -EndDate (Get-Date).AddMonths(6)
Write-Host "New secret created: $($newSecret.SecretText)"

# Update settings file
$settingsPath = ".\.claude\settings.local.json"
$settings = Get-Content $settingsPath | ConvertFrom-Json
$settings.dynamicsConfiguration.clientSecret = $newSecret.SecretText
$settings | ConvertTo-Json | Set-Content $settingsPath

# Delete old secrets (keep only 1 active)
Get-AzADAppCredential -ApplicationId $AppId |
    Where-Object { $_.EndDate -lt (Get-Date).AddDays(1) } |
    Remove-AzADAppCredential
```

---

## Troubleshooting

### "Invalid client secret"

**Causes**:
- Secret copied incorrectly
- Secret value includes quotes or spaces
- Secret expired

**Solution**:
```bash
# Verify secret format
grep "clientSecret" .claude/settings.local.json
# Should show: "clientSecret": "Eby8vdM02xNOcqFlqUwJPLMRigZYaFzLFvQwbWNOE5c="
# (no extra quotes or spaces)

# Check expiration in Azure Portal
# Certificates & secrets → check "Expires" column
```

### "Unauthorized - The user does not have permission"

**Causes**:
- User doesn't have System Administrator role
- App doesn't have Dynamics CRM permission
- Admin consent not granted

**Solution**:
1. Verify app permissions in Azure:
   ```
   Azure Portal → App registrations → Your app → API permissions
   Should show: Dynamics CRM - user_impersonation ✓
   ```

2. Grant admin consent:
   - If not showing as "Granted", click **Grant admin consent for [Org]**

3. Check user role in Dynamics:
   - Dynamics 365 → Settings → Users
   - Find your user
   - Verify role includes System Administrator or similar

### "AADSTS50076: Multifactor authentication required"

**Cause**:
- Your tenant requires MFA
- Service principal doesn't support MFA

**Solution**:
- Use a service principal (doesn't need MFA)
- Service principal is already created - it's your app registration
- Try connection again (should work with app credentials)

### "Connection timeout"

**Causes**:
- Wrong organization URL
- Network connectivity issue
- Firewall blocking connection

**Solution**:
```bash
# Verify URL is reachable
curl https://contoso.crm.dynamics.com
# Should return HTML (not error)

# Check network connectivity
ping contoso.crm.dynamics.com

# Verify correct URL format
# ✅ Correct: https://contoso.crm.dynamics.com
# ❌ Wrong: https://contoso.crm.microsoft.com
```

### "Token has expired"

**Causes**:
- MCP server token expired
- Session timeout

**Solution**:
- Credentials are valid, just session expired
- Restart Claude Code
- Or rotate credentials (see [Credential Rotation](#credential-rotation))

### GitHub token not working

**Causes**:
- Token expired
- Wrong scopes
- Token revoked

**Solution**:
```bash
# Test token
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
# Should show your user info

# If not working:
# 1. Go to github.com/settings/tokens
# 2. Check token hasn't expired
# 3. Check scopes (needs 'repo' and 'read:org')
# 4. If expired or wrong, delete and create new one
```

---

## Security Best Practices

### Do's ✅
- ✅ Store credentials in `.claude/settings.local.json` (git-ignored)
- ✅ Use environment variables for CI/CD
- ✅ Rotate credentials quarterly
- ✅ Use short-lived secrets when possible
- ✅ Use credential manager (Windows/macOS/Linux)
- ✅ Enable MFA on Azure AD account
- ✅ Log access to sensitive resources
- ✅ Use least-privilege principle for app permissions

### Don'ts ❌
- ❌ Never hardcode secrets in code
- ❌ Never commit `.env` files or credential files
- ❌ Never share secrets in Slack/email/chat
- ❌ Never use same credentials for dev and production
- ❌ Never put secrets in log files
- ❌ Never grant unnecessary permissions to app
- ❌ Never reuse service principal across teams
- ❌ Never store credentials in version control history

---

## Summary

| Step | Action | Result |
|------|--------|--------|
| 1 | Create Azure AD app | Have Client ID |
| 2 | Create client secret | Have Client Secret |
| 3 | Grant permissions | App can access Dynamics |
| 4 | Get Dynamics URL | Have Organization URL |
| 5 | Store credentials | Have Tenant ID |
| 6 | Test connection | Credentials verified ✓ |
| 7 | Rotate quarterly | Credentials stay fresh ✓ |

**Next**: Return to [SETUP_INSTRUCTIONS.md](../SETUP_INSTRUCTIONS.md)

---

**Last Updated**: November 2025
**Version**: 1.0
