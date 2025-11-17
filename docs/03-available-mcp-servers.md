# Available MCP Servers for Dynamics Development

This guide documents all available Model Context Protocol (MCP) servers that can enhance your Dynamics 365 development environment.

## 🎯 Dynamics 365-Specific MCPs

### Official Microsoft MCPs

#### 1. **Dynamics 365 ERP MCP Server** (Official - Preview)
**Status**: Public Preview (as of 2025)
**For**: Dynamics 365 Finance & Operations
**Documentation**: https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/copilot/copilot-mcp

**Key Features**:
- Access to hundreds of thousands of ERP functions
- 12 core interaction tools: `open_menu_item`, `find_menu_item`, `set_control_value`, `click_control`, `filter_form`, `sort_grid_column`, `select_grid_row`
- Automatically reflects extensions and personalization
- Security role aware

**Requirements**:
- Finance and Operations version 10.0.2428.15+
- Tier 2+ environment

**Setup**:
```bash
# Configure with Azure AD credentials
claude mcp add dynamics365-erp --scope user
# Set your Dynamics environment URL and credentials
```

#### 2. **Dynamics 365 Sales MCP Server** (Official - Preview)
**Status**: Public Preview
**For**: Dynamics 365 Sales Cloud
**Documentation**: https://learn.microsoft.com/en-us/dynamics365/sales/connect-to-model-context-protocol-sales

**Available Tools**:
- `D365_Sales_ListLeads` - Query and search leads
- `D365_Sales_QualifyLeadToOpportunity` - Convert leads
- `D365_Sales_InvokeLeadSummary` - AI-powered lead analysis
- `D365_Sales_DraftOutreachEmail` - Create personalized emails
- `D365_Sales_SendOutreachEmail` - Send outreach

**Prerequisites**:
- Dataverse MCP server configured first
- Sales Cloud environment access

### Community MCPs

#### 3. **mcp-dynamics365-server** (Srikanth Paladugula)
**Repository**: https://github.com/srikanth-paladugula/mcp-dynamics365-server
**Type**: Node.js/TypeScript
**Platform**: Windows, Mac, Linux

**Features**:
- Get user information
- Fetch accounts and opportunities
- Create/update accounts
- List associated opportunities
- Query custom entities

**Setup**:
```bash
# Clone repository
git clone https://github.com/srikanth-paladugula/mcp-dynamics365-server.git

# Install dependencies
npm install

# Configure .env
DYNAMICS_URL=https://your-org.crm.dynamics.com
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
TENANT_ID=your-tenant-id

# Build and run
npm run build
node build/index.js
```

**Configuration in Claude**:
```json
{
  "mcpServers": {
    "dynamics365": {
      "command": "node",
      "args": ["/path/to/mcp-dynamics365-server/build/index.js"],
      "env": {
        "DYNAMICS_URL": "https://your-org.crm.dynamics.com",
        "CLIENT_ID": "your-client-id",
        "CLIENT_SECRET": "your-client-secret",
        "TENANT_ID": "your-tenant-id"
      }
    }
  }
}
```

## 🔌 Power Platform MCPs

### Dataverse & Power Automate

#### 4. **Power-Platform-MCP** (Cliveo)
**Repository**: https://github.com/Cliveo/Power-Platform-MCP
**Type**: .NET 10
**Platform**: All platforms with .NET SDK

**Features**:
- **Dataverse Tools**:
  - Retrieve plugin trace logs
  - Execute OData queries with formatted values
  - Activate/deactivate workflows
  - List entities and retrieve metadata

- **Power Automate Tools**:
  - Discover flow triggers
  - Generate manual trigger callback URLs
  - View flow run history and execution details
  - Track actions within flows

**Setup**:
```bash
# Install .NET 10 SDK
dotnet --version

# Install Azure CLI
az login

# Clone and run
git clone https://github.com/Cliveo/Power-Platform-MCP.git
cd Power-Platform-MCP
dotnet run

# Configure in Claude
{
  "mcpServers": {
    "power-platform": {
      "command": "dotnet",
      "args": ["run", "--project", "/path/to/Power-Platform-MCP"],
      "env": {
        "POWERPLATFORM_URL": "https://your-env.crm.dynamics.com",
        "AZURE_SUBSCRIPTION_ID": "your-subscription-id"
      }
    }
  }
}
```

#### 5. **PowerPlatform-MCP** (michsob)
**Repository**: https://github.com/michsob/powerplatform-mcp
**Type**: Node.js/npm
**Installation**: `npm install -g powerplatform-mcp`

**Features**:
- Entity metadata exploration
- Advanced OData query support
- Relationship mapping and visualization
- Attribute access with option sets
- AI-assisted natural language queries
- 8 primary tools for Dataverse access

**Setup**:
```bash
# Install globally
npm install -g powerplatform-mcp

# Or use with npx
npx powerplatform-mcp

# Configure environment variables
POWERPLATFORM_URL=https://your-env.crm.dynamics.com
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
TENANT_ID=your-tenant-id

# Add to Claude
{
  "mcpServers": {
    "powerplatform": {
      "command": "npx",
      "args": ["powerplatform-mcp"],
      "env": {
        "POWERPLATFORM_URL": "https://your-env.crm.dynamics.com",
        "CLIENT_ID": "your-client-id",
        "CLIENT_SECRET": "your-client-secret",
        "TENANT_ID": "your-tenant-id"
      }
    }
  }
}
```

## ☁️ Azure & Cloud MCPs

### Azure Cloud Integration

#### 6. **Azure MCP Server** (Official - Microsoft)
**Repository**: https://github.com/microsoft/mcp
**Documentation**: https://learn.microsoft.com/en-us/azure/developer/azure-mcp-server/

**Features**:
- Azure AI Search
- Log Analytics queries
- Cosmos DB operations
- Azure SQL databases
- AKS cluster management
- Container Registry
- Key Vault secrets
- App Configuration
- Azure CLI execution

**Setup**:
```bash
# Install VS Code extension (recommended)
# Or configure manually

{
  "mcpServers": {
    "azure": {
      "command": "npx",
      "args": ["-y", "@microsoft/azure-mcp-server"],
      "env": {
        "AZURE_SUBSCRIPTION_ID": "your-subscription-id",
        "AZURE_RESOURCE_GROUP": "your-resource-group"
      }
    }
  }
}

# Authenticate
az login
az account set --subscription "your-subscription-id"
```

#### 7. **Azure DevOps MCP Server** (Official)
**Documentation**: https://learn.microsoft.com/en-us/azure/devops/mcp-server/mcp-server-overview

**Features**:
- Repository management
- Project access and navigation
- Pipeline handling
- Work item management
- Git operations

**Setup**:
```bash
{
  "mcpServers": {
    "azure-devops": {
      "command": "npx",
      "args": ["-y", "@microsoft/azure-devops-mcp"],
      "env": {
        "AZURE_DEVOPS_ORG_URL": "https://dev.azure.com/your-org",
        "AZURE_DEVOPS_PAT": "your-personal-access-token"
      }
    }
  }
}
```

## 🔧 Development & Build Tools

### Version Control & CI/CD

#### 8. **GitHub MCP Server** (Official)
**For**: GitHub repositories, issues, PRs, workflows
**Status**: Public Preview

**Features**:
- Repository search and browsing
- Issue management
- Pull request operations
- Workflow management
- Project management

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

#### 9. **GitLab MCP Server** (Official)
**Documentation**: https://docs.gitlab.com/user/gitlab_duo/model_context_protocol/mcp_server/

**Features**:
- Repository and project management
- CI/CD pipeline triggering
- Pipeline trigger tokens
- CI/CD variables
- Job status and logs

#### 10. **Git MCP Server** (Official - Anthropic)
**For**: Local Git repositories
**Features**:
- Read repository history
- Search commits and code
- Manipulate Git repositories

```json
{
  "mcpServers": {
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"]
    }
  }
}
```

#### 11. **CircleCI MCP Server**
**For**: Fixing build failures
**URL**: https://circleci.com/mcp/

**Features**:
- Pipeline management
- Build monitoring
- Automated failure analysis

### Code Quality & Testing

#### 12. **Playwright MCP Server** (Official)
**For**: Browser automation testing
**Features**:
- Web page interaction
- Screenshot generation
- Test code generation
- Web scraping

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

#### 13. **Snyk MCP Server**
**Repository**: https://github.com/sammcj/mcp-snyk

**Features**:
- Dependency scanning (SCA)
- Code security scanning (SAST)
- Infrastructure as Code scanning
- OWASP LLMSVS security controls

**Setup**:
```bash
npm install -g mcp-snyk

# Configure Snyk
snyk auth

# Add to Claude
{
  "mcpServers": {
    "snyk": {
      "command": "snyk-mcp-server"
    }
  }
}
```

## 📦 Package Management

#### 14. **Package Registry MCP**
**Repository**: https://github.com/artmann/package-registry-mcp

**Supports**:
- NPM (Node.js/JavaScript)
- PyPI (Python)
- NuGet (.NET)
- Crates.io (Rust)

**Features**:
- Search packages
- Get detailed information
- Version checking

```json
{
  "mcpServers": {
    "package-registry": {
      "command": "npx",
      "args": ["-y", "package-registry-mcp"]
    }
  }
}
```

#### 15. **NPM Documentation MCP**
**Repository**: https://github.com/bsmi021/mcp-npm_docs-server

**Features**:
- Fetch NPM package metadata
- Get README content
- Local SQLite caching

```json
{
  "mcpServers": {
    "npm-docs": {
      "command": "npx",
      "args": ["-y", "mcp-npm_docs-server"]
    }
  }
}
```

## 🗄️ Database MCPs

#### 16. **PostgreSQL MCP Server** (Official)
**For**: PostgreSQL databases
**Features**:
- SQL query execution
- Schema information
- Read/write access control

```json
{
  "mcpServers": {
    "postgresql": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@localhost/dbname"
      }
    }
  }
}
```

#### 17. **SQLite MCP Server** (Official)
**For**: SQLite databases
**Features**:
- Local database access
- SQL queries
- Schema inspection

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "/path/to/database.db"]
    }
  }
}
```

#### 18. **MongoDB MCP Server** (Official)
**Documentation**: https://www.mongodb.com/docs/mcp-server/get-started/

**Features**:
- Database queries
- Collection management
- Index management

## 🌐 Web & API Tools

#### 19. **Fetch MCP Server** (Official)
**For**: Web content fetching
**Features**:
- HTML to Markdown conversion
- Web page content retrieval
- API request handling

```json
{
  "mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

#### 20. **Brave Search MCP Server** (Official)
**For**: Web search
**Features**:
- Search Brave's independent index
- AI-optimized results

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_SEARCH_API_KEY": "your-api-key"
      }
    }
  }
}
```

## 💬 Communication

#### 21. **Slack MCP Server** (Official)
**For**: Slack workspace integration

**Features**:
- Channel management
- Message posting
- User profile retrieval
- Message history

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-token"
      }
    }
  }
}
```

## 📁 File System

#### 22. **Filesystem MCP Server** (Official)
**For**: Secure file operations

**Features**:
- File read/write with access controls
- Directory traversal
- Safe operations

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    }
  }
}
```

## Configuration Guide

### Adding MCPs to Your Project

#### Method 1: CLI (Recommended)
```bash
# For public MCPs
claude mcp add [name] --scope project

# Examples
claude mcp add github --scope project
claude mcp add playwright --scope project
```

#### Method 2: Edit `.mcp.json`
```json
{
  "mcpServers": {
    "your-mcp-name": {
      "command": "npx",
      "args": ["-y", "@org/server-name"],
      "env": {
        "API_KEY": "your-key-here"
      }
    }
  }
}
```

#### Method 3: Settings
Edit `.claude/settings.json`:
```json
{
  "enabledMcpjsonServers": [
    "github",
    "playwright",
    "dynamics365",
    "powerplatform"
  ]
}
```

### Environment Variables

Store sensitive values:
```bash
# .env file (NOT in git)
GITHUB_TOKEN=ghp_xxx
DYNAMICS_CLIENT_ID=xxx
POWERPLATFORM_URL=https://xxx.crm.dynamics.com
```

Load in MCP config:
```json
{
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
  }
}
```

## Recommended MCPs for Dynamics Development

### Minimum Setup
1. **GitHub** - Version control
2. **Dynamics 365 ERP or Sales** - Official MCPs (if available for your scenario)
3. **PowerPlatform-MCP** - Dataverse/Power Automate access
4. **Git** - Local repository operations
5. **Playwright** - Testing and browser automation

### Full Development Setup
Add to above:
6. **Azure** - Cloud resources
7. **PostgreSQL/SQLite** - Testing databases
8. **Package Registry** - Dependency management
9. **Slack** - Team communication
10. **Snyk** - Security scanning

## Discovery & Exploration

### Find More MCPs
- **MCPServers.org**: https://mcpservers.org/ (best curated collection)
- **Awesome MCP**: https://github.com/wong2/awesome-mcp-servers
- **Glama AI**: https://glama.ai/mcp/servers

### Testing MCPs
Use **MCP Inspector**:
```bash
npm install -g @modelcontextprotocol/inspector
mcp-inspector
```

Then visit `http://localhost:5173` to test MCPs visually.

## Troubleshooting

### MCP Not Connecting
1. Verify credentials/environment variables
2. Check if server is running: `npm list -g [package-name]`
3. Test with MCP Inspector
4. Check logs for errors

### Permission Errors
1. Update environment variables
2. Verify API tokens are valid
3. Check scopes/permissions in API settings
4. Ensure service account has required access

### Performance Issues
1. Limit scope of queries
2. Enable caching where possible
3. Use pagination for large result sets
4. Monitor MCP resource usage

## Best Practices

✅ **Do**:
- Use official MCPs when available
- Store credentials in environment variables
- Test MCPs with MCP Inspector before deploying
- Document which MCPs are required
- Version lock MCP server versions
- Monitor MCP performance

❌ **Don't**:
- Commit API keys or tokens to git
- Install MCPs globally in production
- Use untested MCPs in critical workflows
- Give MCPs more permissions than needed
- Mix different versions of the same MCP

## Next Steps

1. **Identify your needs**: Which development tasks need MCPs?
2. **Install MCPs**: Start with the recommended setup
3. **Test**: Use MCP Inspector to verify functionality
4. **Document**: Update your setup documentation
5. **Share**: Commit `.mcp.json` to your repo (without secrets)

For detailed setup of specific MCPs, refer to their documentation links above.

---

**Last Updated**: November 2025
**MCPs Documented**: 22 (with 100+ available in community registries)
