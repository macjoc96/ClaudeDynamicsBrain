# Claude Dynamics Brain - Setup Instructions

Welcome to the Claude Dynamics Brain development environment! This guide will walk you through setting up your local environment for Dynamics 365 and Power Platform development.

**Estimated Setup Time**: 30-45 minutes
**Platform Support**: Windows 10/11, macOS 11+, Linux (Ubuntu 20+)

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start (5 minutes)](#quick-start-5-minutes)
3. [Detailed Setup Steps](#detailed-setup-steps)
4. [Credential Configuration](#credential-configuration)
5. [Validation & Testing](#validation--testing)
6. [Troubleshooting](#troubleshooting)
7. [Next Steps](#next-steps)

---

## Prerequisites

### Required Software

Before starting setup, ensure you have installed:

- [ ] **Git** (v2.30+)
  - [Download](https://git-scm.com/downloads)
  - Verify: `git --version`

- [ ] **Node.js** (v18+ LTS recommended)
  - [Download](https://nodejs.org/)
  - Verify: `node --version && npm --version`
  - Install npm dependencies globally: `npm install -g npm`

- [ ] **.NET SDK** (6.0+ for Dynamics plugins)
  - [Download](https://dotnet.microsoft.com/download)
  - Verify: `dotnet --version`

- [ ] **Claude Code** (Latest version)
  - [Installation guide](https://docs.claude.com)
  - Verify it opens this project

### Required Accounts & Access

- [ ] **Azure AD Tenant** with admin access
  - Required for: Dynamics 365 app registration
  - Contact: Your tenant administrator

- [ ] **Dynamics 365 Instance** (v9.0+ required)
  - URL format: `https://yourorg.crm.dynamics.com`
  - Required role: System Administrator or System Customizer
  - Contact: Your organization administrator

- [ ] **GitHub Account** (optional, for GitHub MCP)
  - Required for: GitHub integration and code search
  - [Sign up](https://github.com/signup)

### Platform-Specific Requirements

**Windows 10/11**:
- PowerShell 5.1+ (usually included)
- Visual Studio or Visual Studio Code
- Access to run scripts (execution policy)

**macOS 11+**:
- Xcode Command Line Tools: `xcode-select --install`
- Homebrew (optional but recommended): `brew --version`

**Linux (Ubuntu 20+)**:
- Build essentials: `sudo apt-get install build-essential`
- curl or wget for downloads

---

## Quick Start (5 minutes)

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd ClaudeDynamicsBrainSettings
```

### Step 2: Run Platform-Specific Setup Script

**Windows (PowerShell)**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup\setup-environment.ps1
```

**macOS/Linux (Bash)**:
```bash
chmod +x setup/setup-environment.sh
./setup/setup-environment.sh
```

### Step 3: Configure Credentials

```bash
# Interactive credential setup
./setup/setup-credentials.sh    # macOS/Linux
# or
.\setup\setup-credentials.ps1   # Windows
```

Follow the prompts to enter:
- Dynamics 365 organization URL
- Azure AD tenant ID
- Client ID (from Azure app registration)
- Client Secret
- GitHub personal access token (optional)

### Step 4: Validate Setup

```bash
./setup/validate-setup.sh      # macOS/Linux
# or
.\setup\validate-setup.ps1     # Windows
```

Expected output:
```
✓ Git installed and configured
✓ Node.js v18.12.0 installed
✓ .NET SDK v6.0.0 installed
✓ MCP servers ready
✓ Dynamics 365 credentials valid
✓ Setup complete!
```

**You're done!** Skip to [Next Steps](#next-steps).

---

## Detailed Setup Steps

### Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/your-org/ClaudeDynamicsBrainSettings.git
cd ClaudeDynamicsBrainSettings

# Verify directory structure
ls -la  # macOS/Linux
dir     # Windows
```

Expected structure:
```
.
├── .claude/              # Claude configuration
│   ├── agents/
│   ├── commands/
│   ├── skills/
│   ├── templates/
│   ├── .mcp.json
│   ├── settings.json
│   └── settings.local.json
├── docs/                 # Documentation
├── setup/                # Setup scripts
├── .gitignore
├── CLAUDE.md
├── SETUP_INSTRUCTIONS.md # This file
└── README.md
```

### Step 2: Install Global Dependencies

Install required Node.js packages globally:

```bash
npm install -g npm@latest
npm install -g @modelcontextprotocol/server-github@latest
npm install -g @modelcontextprotocol/server-git@latest
```

Verify installation:
```bash
npm list -g @modelcontextprotocol/server-github
```

### Step 3: Install Project Dependencies

```bash
# Install local npm dependencies (if any)
npm install --no-save

# For C# plugin development, restore NuGet packages
dotnet nuget update source
```

### Step 4: Azure AD App Registration

Register an application in Azure AD for Dynamics 365 access:

**Option A: Using Azure Portal (Recommended for First-Time Setup)**

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to **Azure Active Directory** → **App registrations**
3. Click **+ New registration**
4. Fill in details:
   - **Name**: `Claude Dynamics Brain [YourTeam]`
   - **Supported account types**: Single tenant
   - **Redirect URI**: Leave blank (not needed for CLI)
5. Click **Register**
6. Go to **Certificates & secrets**
7. Click **+ New client secret**
8. Create secret with name `claude-dynamics-brain`
9. **Copy and save** the secret value (you won't see it again)
10. Go to **Overview** and copy:
    - Application (client) ID
    - Directory (tenant) ID

**Option B: Using Azure CLI**

```bash
# Login to Azure
az login

# Create app registration
az ad app create --display-name "Claude Dynamics Brain"

# Create service principal
az ad sp create --id <app-id>

# Create client secret
az ad app credential reset --id <app-id> --credential-description "claude-brain"
```

### Step 5: Grant Dynamics 365 Permissions

In Azure Portal, configure permissions for your registered app:

1. Go to **API permissions**
2. Click **+ Add a permission**
3. Select **APIs my organization uses**
4. Search for **Dynamics CRM**
5. Select **Delegated permissions**
6. Check:
   - [ ] `user_impersonation` - Access Dynamics 365
7. Click **Add permissions**
8. Click **Grant admin consent**

### Step 6: Store Credentials Securely

**IMPORTANT**: Never commit credentials to version control.

Create `.claude/settings.local.json` with your environment-specific credentials:

```json
{
  "dynamicsConfiguration": {
    "instanceUrl": "https://yourorg.crm.dynamics.com",
    "clientId": "your-app-id-here",
    "clientSecret": "your-secret-here",
    "tenantId": "your-tenant-id-here"
  },
  "githubToken": "your-github-token-here"
}
```

**This file is in `.gitignore` and will NOT be committed.**

### Step 7: Configure MCP Servers

Update `.claude/.mcp.json` with your credentials:

```json
{
  "mcpServers": {
    "dynamics365": {
      "env": {
        "DYNAMICS_URL": "https://yourorg.crm.dynamics.com",
        "CLIENT_ID": "your-app-id",
        "CLIENT_SECRET": "your-secret",
        "TENANT_ID": "your-tenant-id"
      }
    }
  }
}
```

---

## Credential Configuration

### Dynamics 365 Credentials

**What you need**:
- Organization URL (e.g., `https://contoso.crm.dynamics.com`)
- Azure AD Tenant ID
- Application (Client) ID
- Client Secret

**Where to find them**:

1. **Organization URL**:
   - Open Dynamics 365
   - URL bar shows: `https://orgname.crm.dynamics.com`

2. **Azure AD Tenant ID**:
   - Azure Portal → Azure Active Directory → Overview
   - Copy: **Directory (tenant) ID**

3. **Client ID & Secret**:
   - Azure Portal → App registrations → Your app
   - Copy: **Application (client) ID**
   - Go to: **Certificates & secrets**
   - Copy secret value (not ID)

### GitHub Credentials (Optional)

For GitHub MCP server integration:

1. Go to [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
2. Click **Generate new token**
3. Name: `Claude Dynamics Brain`
4. Scopes needed:
   - [ ] `repo` - Full control of private repositories
   - [ ] `gist` - Create gists
   - [ ] `read:org` - Read organization data
5. Copy the token immediately (you won't see it again)
6. Store in `.claude/settings.local.json`:

```json
{
  "integrations": {
    "github": {
      "token": "ghp_your_token_here"
    }
  }
}
```

### Rotating Credentials

Update credentials when:
- Client secret expires
- Team member leaves organization
- Security breach suspected
- Regular rotation policy (quarterly recommended)

To rotate:

1. **Create new secret** in Azure Portal (keep old one briefly)
2. **Update** `.claude/settings.local.json` with new secret
3. **Test** connection using `/validate-mcp`
4. **Delete old secret** from Azure Portal after 24 hours

---

## Validation & Testing

### Automated Validation

Run the validation script:

```bash
# macOS/Linux
./setup/validate-setup.sh

# Windows (PowerShell)
.\setup\validate-setup.ps1
```

**Expected output**:
```
Claude Dynamics Brain Setup Validation
======================================

✓ Git found: git version 2.38.1
✓ Node.js found: v18.12.0
✓ npm found: 9.2.0
✓ .NET SDK found: 6.0.300
✓ Project structure valid
✓ Claude Code configured
✓ MCP servers available

Attempting credential tests...
✓ Dynamics 365 connection successful
✓ GitHub connection successful (optional)

Setup Status: READY ✓

Your environment is ready for development!
Next: Read the getting started guide
```

### Manual Testing

If validation script fails:

**Test Git**:
```bash
git --version
git config --list
```

**Test Node.js**:
```bash
node --version
npm --version
npm list -g @modelcontextprotocol/server-github
```

**Test .NET**:
```bash
dotnet --version
dotnet --list-sdks
```

**Test Dynamics 365 Connection**:
```bash
# In Claude Code, run:
I need to test my Dynamics 365 connection
```

**Test GitHub (Optional)**:
```bash
# In Claude Code, run:
List repositories using GitHub MCP
```

### First Project Creation

Test your setup by creating your first project:

```bash
# Open Claude Code in this project
# Run first command:
/plugin-scaffold TestPlugin

# This will:
# 1. Create plugin project structure
# 2. Test file creation
# 3. Validate templates
# 4. Show success message
```

---

## Troubleshooting

### Issue: "Node.js not found"

**Solution**:
```bash
# Verify installation
node --version

# If not installed:
# Windows: https://nodejs.org/
# macOS: brew install node
# Linux: sudo apt-get install nodejs npm
```

### Issue: ".NET SDK not found"

**Solution**:
```bash
# Verify installation
dotnet --version

# If not installed:
# Visit: https://dotnet.microsoft.com/download
# Install .NET 6.0 SDK or later
```

### Issue: "Dynamics 365 connection failed"

**Solution**:
1. Verify credentials in `.claude/settings.local.json`:
   ```bash
   cat .claude/settings.local.json  # Check values exist
   ```

2. Confirm organization URL:
   - Should be: `https://orgname.crm.dynamics.com`
   - NOT: `https://orgname.crm.microsoft.com` (wrong)

3. Check Azure AD app permissions:
   - Azure Portal → App registrations → Your app
   - Click **API permissions**
   - Ensure "Dynamics CRM" has `user_impersonation` permission
   - Admin consent given? Click **Grant admin consent**

4. Verify client secret hasn't expired:
   - Azure Portal → Certificates & secrets
   - Check expiration date
   - If expired, create new secret

5. Check network connectivity:
   ```bash
   # Test access to organization
   curl https://yourorg.crm.dynamics.com
   ```

### Issue: "Credential setup script not found"

**Solution**:
```bash
# Check if setup directory exists
ls setup/  # or dir setup (Windows)

# If missing:
# The scripts are optional - use manual steps instead
# See: Credential Configuration section above
```

### Issue: "Cannot find module '@modelcontextprotocol/server-github'"

**Solution**:
```bash
# Reinstall MCP servers
npm install -g @modelcontextprotocol/server-github@latest
npm install -g @modelcontextprotocol/server-git@latest

# Verify installation
npm list -g @modelcontextprotocol/server-github
```

### Issue: "PowerShell execution policy error" (Windows)

**Solution**:
```powershell
# Allow script execution for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Verify
Get-ExecutionPolicy
```

### Issue: "Permission denied" (macOS/Linux)

**Solution**:
```bash
# Make scripts executable
chmod +x setup/*.sh

# Try again
./setup/validate-setup.sh
```

### Issue: "Settings.local.json conflicts with .gitignore"

**Solution**:
This is expected and correct behavior:
```bash
# settings.local.json is in .gitignore (won't be committed)
# But it's needed for local development
# This is intentional and secure
```

### Getting Help

If issues persist:

1. **Check Documentation**:
   - [docs/07-credential-setup.md](docs/07-credential-setup.md) - Credential details
   - [docs/12-troubleshooting.md](docs/12-troubleshooting.md) - Known issues
   - [CLAUDE.md](CLAUDE.md) - Project context

2. **Ask in Team Chat**:
   - Share error message
   - Include platform (Windows/macOS/Linux)
   - Include output of `validate-setup.sh/ps1`

3. **Create Issue**:
   - Go to GitHub Issues
   - Title: "[SETUP] Brief problem description"
   - Include: Error message, platform, setup script output

---

## Next Steps

### 1. Read Getting Started Guide

Once setup is complete, read the getting started guide:

```bash
# Open in editor or browser
cat docs/01-getting-started.md
```

Key topics:
- Claude Dynamics Brain features
- Using specialized agents
- Available skills and commands
- Project templates

### 2. Create Your First Project

Try each major feature:

```bash
# Create a plugin project
/plugin-scaffold MyFirstPlugin

# Create a cloud flow template
/flow-template cloud-flow Account

# Create a custom connector
/connector-stub MyConnector
```

### 3. Explore Specialized Agents

Ask agents for help:

```
# In Claude Code:
I need help with plugin development. Can you delegate to the plugin-developer agent?
```

### 4. Review Security Guidelines

Before any development:

```bash
cat docs/05-security-guidelines.md
```

Key topics:
- Input validation
- Credential handling
- SQL injection prevention
- XSS prevention

### 5. Understand Configuration

Learn about your environment:

```bash
cat docs/08-configuration-guide.md  # (will be created)
```

### 6. Check Team Guidelines

Understand team processes:

```bash
cat CONTRIBUTING.md  # (will be created)
```

---

## Verification Checklist

Before starting development, verify:

- [ ] Git configured and working
- [ ] Node.js v18+ installed
- [ ] .NET SDK v6+ installed
- [ ] Claude Code can open this project
- [ ] Azure AD app registered
- [ ] Dynamics 365 organization URL confirmed
- [ ] Client ID and Secret stored safely
- [ ] GitHub token configured (optional)
- [ ] Validation script passes
- [ ] First project creation succeeds
- [ ] Security guidelines reviewed
- [ ] Team guidelines understood

---

## Frequently Asked Questions

### Q: Do I need all MCP servers?

**A**: No. You can disable unused servers in `.claude/settings.json`:
```json
{
  "enabledMcpjsonServers": ["github", "filesystem", "fetch"]
}
```

### Q: Can I use different credentials for different projects?

**A**: Yes. Create separate app registrations in Azure AD and store in different `settings.local.json` environments.

### Q: How do I update credentials after setup?

**A**: Edit `.claude/settings.local.json` directly. Changes take effect immediately.

### Q: What if I can't get Azure AD access?

**A**: Contact your Azure AD administrator. Request:
- Permission to create app registrations
- Access to Dynamics 365 instance
- API permission assignment rights

### Q: Can I use this on Linux/macOS?

**A**: Yes! All tools support cross-platform development. See [docs/11-cross-platform-setup.md](docs/11-cross-platform-setup.md).

### Q: What if validation fails?

**A**:
1. Run validation with verbose output: `validate-setup.sh -v`
2. Check the error message
3. See [Troubleshooting](#troubleshooting) section
4. Ask your team or create an issue

---

## Support Resources

- **Documentation**: Read `docs/` directory
- **Troubleshooting**: See [docs/12-troubleshooting.md](docs/12-troubleshooting.md)
- **Team Help**: Ask in team chat with error details
- **Issues**: Create GitHub issue with setup output

---

**Setup Complete!** 🎉

You're now ready to start Dynamics 365 development with Claude Dynamics Brain.

**Ready to code?** → [Read the Getting Started Guide](docs/01-getting-started.md)

---

**Last Updated**: November 2025
**Version**: 1.0
**Maintainers**: Your Team
