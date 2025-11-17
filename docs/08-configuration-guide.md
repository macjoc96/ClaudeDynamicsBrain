# Configuration Guide - Claude Dynamics Brain

This guide explains how to configure your Claude Dynamics Brain setup for your specific needs and environment.

## Quick Reference

| File | Purpose | Scope | Git Status |
|------|---------|-------|-----------|
| `.claude/settings.json` | Team defaults | Applied to all team members | Committed ✓ |
| `.claude/settings.local.json` | Your overrides | Per-machine only | Git-ignored (not committed) |
| `.claude/.mcp.json` | MCP servers & credentials | Environment variable references | Committed ✓ |

---

## Files Overview

### `.claude/settings.json` (Team-Wide Defaults)

This file contains team-wide configuration applied to all members. Changes here affect everyone.

```json
{
  "modelDefaults": {
    "default": "sonnet",      // Primary Claude model for most tasks
    "fastMode": "haiku",       // Quick, cost-effective tasks
    "complexTasks": "opus"     // Heavy-lifting analysis and coding
  },
  "enabledMcpServers": [
    "github",
    "filesystem",
    "fetch"
  ],
  "security": {
    "inputValidation": true,
    "sensitiveDataEncryption": true,
    "outputSanitization": true
  },
  "development": {
    "defaultLanguage": "typescript",
    "testFramework": "jest",
    "linter": "eslint"
  }
}
```

**When to modify**:
- Team decides on new standard tools
- Security policy changes
- Default behavior needs updating for entire team

**Example**: "Everyone should use Sonnet for complex tasks" → Update `complexTasks: sonnet`

---

### `.claude/settings.local.json` (Personal Overrides)

This file contains YOUR personal preferences, overriding team defaults. It's never committed to git.

```json
{
  "modelDefaults": {
    "default": "haiku",        // You prefer cost-effective models
    "fastMode": "haiku"        // Always use fast mode
  },
  "myPreferences": {
    "theme": "dark",
    "language": "python"       // You prefer Python over TypeScript
  }
}
```

**When to modify**:
- You want different model preferences
- You prefer different tools than team defaults
- You have specific local environment needs
- You want to test new configurations

**Example**: "I want to use Haiku for everything" → Add to `settings.local.json`

---

### `.claude/.mcp.json` (MCP Server Configuration)

This file configures MCP servers and how they connect to external services.

```json
{
  "mcpServers": {
    "github": {
      "enabled": true,
      "command": "npx",
      "args": ["@anthropic-ai/github-mcp"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "filesystem": {
      "enabled": true,
      "command": "npx",
      "args": ["@anthropic-ai/filesystem-mcp"]
    },
    "fetch": {
      "enabled": true,
      "command": "npx",
      "args": ["@anthropic-ai/fetch-mcp"]
    }
  }
}
```

**Using environment variables**:
- Store sensitive values in environment variables
- Reference with `${VARIABLE_NAME}` syntax
- Never hardcode secrets
- Load from `.env` file or system environment

---

## Configuration by Role

Choose the configuration that matches your role:

### C# Plugin Developer

Focus on: Dynamics 365 plugins, plugin registration, entity operations

```json
{
  "modelDefaults": {
    "default": "sonnet",
    "fastMode": "haiku",
    "complexTasks": "opus"
  },
  "enabledMcpServers": [
    "github",
    "filesystem",
    "fetch"
  ],
  "development": {
    "defaultLanguage": "csharp",
    "testFramework": "mstest"
  }
}
```

**Key tools**: C# IDE, .NET CLI, git

---

### TypeScript/JavaScript Developer

Focus: Cloud flows, Power Platform actions, web development

```json
{
  "modelDefaults": {
    "default": "sonnet",
    "fastMode": "haiku"
  },
  "enabledMcpServers": [
    "github",
    "filesystem",
    "fetch"
  ],
  "development": {
    "defaultLanguage": "typescript",
    "testFramework": "jest",
    "packageManager": "npm"
  }
}
```

**Key tools**: VS Code, Node.js, npm

---

### Low-Code Developer

Focus: Canvas apps, model-driven apps, Power Pages

```json
{
  "modelDefaults": {
    "default": "sonnet",
    "fastMode": "haiku"
  },
  "enabledMcpServers": [
    "filesystem",
    "fetch"
  ],
  "development": {
    "platform": "powerplatform",
    "focusAreas": [
      "canvas-apps",
      "model-driven-apps",
      "power-pages"
    ]
  }
}
```

**Key tools**: Power Apps Studio, Power Pages design studio

---

### Cloud Architect

Focus: Cloud flows, automation, integration design

```json
{
  "modelDefaults": {
    "default": "opus",          // Complex flows need deeper analysis
    "fastMode": "sonnet"
  },
  "enabledMcpServers": [
    "github",
    "filesystem",
    "fetch"
  ],
  "development": {
    "platform": "powerplatform",
    "focusAreas": [
      "cloud-flows",
      "automation",
      "integration-design"
    ]
  }
}
```

**Key tools**: Power Automate, Azure DevOps, documentation

---

## Environment-Specific Settings

### Development (Local Machine)

Use relaxed settings for fast iteration:

```json
{
  "modelDefaults": {
    "default": "haiku",         // Cost-effective for local work
    "fastMode": "haiku"
  },
  "development": {
    "debugMode": true,
    "logLevel": "verbose"
  }
}
```

### Testing/UAT Environment

Use balanced settings:

```json
{
  "modelDefaults": {
    "default": "sonnet",
    "fastMode": "haiku"
  },
  "development": {
    "debugMode": false,
    "logLevel": "info"
  }
}
```

### Production Environment

Use safe, quality-focused settings:

```json
{
  "modelDefaults": {
    "default": "sonnet",
    "complexTasks": "opus"
  },
  "development": {
    "debugMode": false,
    "logLevel": "error",
    "requireApproval": true
  }
}
```

---

## Common Configuration Tasks

### Task 1: Change Your Primary Model

**Scenario**: You prefer Haiku for cost reasons

**Steps**:
1. Open `.claude/settings.local.json`
2. Add:
```json
{
  "modelDefaults": {
    "default": "haiku"
  }
}
```
3. Save and close
4. Your local Claude Code will now use Haiku by default

---

### Task 2: Enable Additional MCP Servers

**Scenario**: You want to use GitHub MCP for better repo access

**Steps**:
1. Edit `.claude/.mcp.json`
2. Ensure GitHub section is enabled:
```json
{
  "mcpServers": {
    "github": {
      "enabled": true,
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```
3. Set `GITHUB_TOKEN` environment variable
4. Restart Claude Code

---

### Task 3: Customize Development Settings

**Scenario**: You want to use Python instead of TypeScript

**Steps**:
1. Open `.claude/settings.local.json`
2. Add:
```json
{
  "development": {
    "defaultLanguage": "python",
    "packageManager": "pip"
  }
}
```
3. Save and restart

---

## Decision Tree: Which File to Edit?

```
Do you want to change something?
│
├─ YES: This affects the entire team
│   └─ Edit: .claude/settings.json
│       └─ Commit to git
│       └─ Notify team of changes
│
├─ NO: This is just for me
│   └─ Edit: .claude/settings.local.json
│       └─ DON'T commit (it's in .gitignore)
│       └─ Changes are automatic
│
└─ SPECIAL: Configuring MCP servers or credentials
    └─ Edit: .claude/.mcp.json
        └─ Use environment variables: ${VAR_NAME}
        └─ Store sensitive values in .env or system env
        └─ Never hardcode secrets
```

---

## Model Selection Guide

### Claude Haiku (Fast & Cheap)
- **Best for**: Quick answers, simple tasks, prototyping
- **Cost**: Lowest
- **Speed**: Fastest
- **Quality**: Good for straightforward work
- **Use cases**: File formatting, simple bugs, quick research

### Claude Sonnet (Balanced)
- **Best for**: Most development work, good balance
- **Cost**: Medium
- **Speed**: Fast
- **Quality**: High for code and analysis
- **Use cases**: Plugin development, flow design, code reviews

### Claude Opus (Powerful)
- **Best for**: Complex analysis, architecture decisions
- **Cost**: Higher
- **Speed**: Slower
- **Quality**: Highest reasoning ability
- **Use cases**: System design, performance optimization, security analysis

---

## Security Settings Explained

```json
{
  "security": {
    "inputValidation": true,           // Validate all inputs before processing
    "sensitiveDataEncryption": true,   // Encrypt sensitive data at rest
    "outputSanitization": true         // Remove sensitive data from outputs
  }
}
```

- **inputValidation**: Prevents malformed data from causing issues
- **sensitiveDataEncryption**: Protects credentials in memory
- **outputSanitization**: Prevents accidental credential leaks in responses

**Recommendation**: Keep all security settings `true` in production

---

## Troubleshooting Configuration

### Problem: Claude Code won't start

**Check**:
1. Is `.claude/settings.json` valid JSON? Use an online JSON validator
2. Are all required fields present?
3. Try renaming `settings.local.json` temporarily

**Fix**:
```bash
# Validate JSON syntax
cat .claude/settings.json | jq empty
# If error, fix the JSON
```

---

### Problem: Changes to settings.json aren't taking effect

**Check**:
1. Is Claude Code still running? Restart it.
2. Does `.claude/settings.local.json` override your change?
3. Is the field name spelled correctly?

**Fix**:
1. Close Claude Code completely
2. Verify JSON syntax
3. Restart Claude Code
4. Check `settings.local.json` for conflicting settings

---

### Problem: Environment variables aren't being read

**Check**:
1. Is the variable actually set? Run: `echo $VARIABLE_NAME`
2. Did you restart Claude Code after setting the variable?
3. Is the `.mcp.json` reference correct: `${VAR_NAME}`?

**Fix**:
```bash
# Linux/macOS
export GITHUB_TOKEN="your-token"

# PowerShell (Windows)
$env:GITHUB_TOKEN = "your-token"

# Verify it's set
echo $GITHUB_TOKEN
```

---

## Advanced: Multiple Configurations

### Using Environment Profiles

Create separate `.mcp.json` files for different environments:

```
.claude/
├── .mcp.json              (checked in, base config)
├── .mcp.development.json  (for dev environment)
├── .mcp.testing.json      (for test environment)
└── .mcp.production.json   (for production)
```

Switch using: `setup/switch-environment.ps1` (Windows) or `setup/switch-env.sh` (Linux/macOS)

---

## Best Practices

✅ **DO**:
- Keep team settings in `settings.json`
- Keep personal settings in `settings.local.json`
- Use environment variables for secrets
- Document why you're changing settings
- Review settings regularly with team

❌ **DON'T**:
- Hardcode secrets in any config file
- Check in `settings.local.json`
- Commit environment variable values
- Change team settings without discussion
- Use plaintext passwords anywhere

---

## Getting Help

- **Questions about configuration?** Check this guide or ask your team lead
- **Settings not working?** Validate JSON syntax and restart Claude Code
- **Need a new setting?** Discuss with team before adding to `settings.json`
- **Having security concerns?** Review `docs/05-security-guidelines.md`

---

## Quick Links

- **Credential Setup**: `docs/07-credential-setup.md`
- **Security Guidelines**: `docs/05-security-guidelines.md`
- **Setup Validation**: Run `setup/validate-setup.sh` (Linux/macOS) or `setup/validate-setup.ps1` (Windows)
- **MCP Servers**: `docs/03-available-mcp-servers.md`

---

**Last Updated**: November 16, 2025
**Version**: 1.0
**Author**: Claude Dynamics Brain Team
