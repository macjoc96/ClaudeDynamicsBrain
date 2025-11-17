# Bot & Chatbot Integration for Dynamics 365 Development

This guide covers MCP servers and bot frameworks specifically designed to work with **Microsoft Dynamics 365** and the **Power Platform**.

## 🎯 Dynamics-Specific Bot Options

| Solution | Platform | Status | Link |
|----------|----------|--------|------|
| **Microsoft Copilot Studio** | Any (Cloud) | ✅ GA | https://learn.microsoft.com/en-us/microsoft-copilot-studio/agent-extend-action-mcp |
| **Power Virtual Agents** | Dynamics/Teams | ✅ GA | https://learn.microsoft.com/en-us/power-virtual-agents/ |
| **Microsoft Teams Bot** | Teams (Official) | ✅ GA | https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/ |
| **Agent Framework** | Any (.NET/Python) | 🔄 Preview | https://learn.microsoft.com/en-us/agent-framework/ |

---

## 🤖 Microsoft Copilot Studio + Dynamics (RECOMMENDED)

**Official Documentation**: https://learn.microsoft.com/en-us/microsoft-copilot-studio/agent-extend-action-mcp
**Status**: ✅ Generally Available (GA)

Copilot Studio is **Microsoft's official solution** for building AI agents that work with Dynamics 365.

### Key Advantages for Dynamics
- Native Dynamics 365 connectors
- Direct access to Dynamics data
- No custom MCP needed for basic operations
- Seamless Teams integration
- Built-in security & governance

### Setup Steps
1. Go to: https://copilotstudio.microsoft.com
2. Create new copilot
3. Add "Extend with MCP" (for advanced scenarios)
4. Connect Dynamics 365 connector
5. Configure actions and flows

### MCP Integration
For advanced scenarios, you can extend with custom MCPs:
1. Access copilot in Copilot Studio
2. Select "Add a Tool"
3. Search for MCP server
4. Use MCP onboarding wizard

### Example: Query Dynamics Data
```python
# Use Copilot Studio's Dynamics connector
# No MCP needed for standard operations

# For custom MCP integration:
# 1. Create MCP server with Dynamics API calls
# 2. Register in Copilot Studio
# 3. Add to copilot actions
```

**Tutorial**: https://ariel-ibarra.medium.com/how-to-connect-microsoft-copilot-studio-with-mcp-servers-a-complete-integration-guide-506e0c96f843

---

## 👥 Microsoft Teams Bot + Dynamics (RECOMMENDED)

**Official Documentation**: https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/

Teams is a **native Microsoft enterprise platform** - optimal for Dynamics integration.

### Option 1: Microsoft Agent Framework (NEW - Preview)
**Status**: Public Preview (October 2, 2025)
**Blog**: https://azure.microsoft.com/en-us/blog/introducing-microsoft-agent-framework/
**Docs**: https://learn.microsoft.com/en-us/agent-framework/

**Features**:
- Native MCP support
- Multi-agent orchestration
- Direct Dynamics API access
- Teams deployment ready

**MCP with Dynamics Integration**:
```python
# Example: Agent that queries Dynamics
import asyncio
from agent_framework import Agent

agent = Agent(
    name="Dynamics Helper",
    description="Assists with Dynamics 365 queries"
)

# Add Dynamics API as MCP
agent.add_mcp_server(
    "dynamics365",
    "Dynamics API MCP server endpoint",
    auth_token="your_dynamics_token"
)

# Agent can now query Dynamics using MCP
```

---

### Option 2: IF-MCP-Server-for-Microsoft-Teams (Official)
**GitHub**: https://github.com/microsoft/IF-MCP-Server-for-Microsoft-Teams
**Setup Guide**: https://github.com/microsoft/IF-MCP-Server-for-Microsoft-Teams/blob/main/docs/teams-bot-setup.md

**Prerequisites**:
- .NET 8 SDK
- Azure subscription
- Dynamics 365 environment

**Configuration** (appsettings.json):
```json
{
  "MicrosoftAppId": "your-app-id",
  "MicrosoftAppPassword": "client-secret",
  "DynamicsUrl": "https://yourorg.crm.dynamics.com",
  "DynamicsClientId": "your-client-id",
  "DynamicsClientSecret": "your-client-secret"
}
```

---

## ⚡ Power Virtual Agents + Dynamics (GA)

**Official Documentation**: https://learn.microsoft.com/en-us/power-virtual-agents/
**For Dynamics Integration**: https://learn.microsoft.com/en-us/power-virtual-agents/advanced-fundamentals-topics

Power Virtual Agents is the **low-code chatbot solution** in Power Platform.

### Integration with Dynamics
1. Create chatbot in Power Virtual Agents
2. Add Dynamics connector
3. Configure topics to query/update Dynamics records
4. Deploy to Teams or web

### Example: Dynamics-Connected Chatbot

```yaml
Topic: "Get Account Info"
Trigger: "Show me account {AccountName}"

Actions:
  1. List Dynamics accounts where name = {AccountName}
  2. Show account details
  3. Offer related operations (create opportunity, etc.)
```

**Benefits for Dynamics**:
- No coding required
- Native Dynamics 365 connector
- Teams/Web deployment
- Automatic authentication

---

## 🔌 Dynamics-Specific MCPs

### Official Microsoft Dynamics MCPs

#### 1. Dynamics 365 Sales MCP (Official - Preview)
**Documentation**: https://learn.microsoft.com/en-us/dynamics365/sales/connect-to-model-context-protocol-sales

**Features**:
- Lead management
- Opportunity creation
- Lead summaries
- Outreach email drafting
- Direct Dynamics Sales integration

**Available Tools**:
- `D365_Sales_ListLeads` - Query leads
- `D365_Sales_QualifyLeadToOpportunity` - Convert leads
- `D365_Sales_InvokeLeadSummary` - AI lead summaries
- `D365_Sales_DraftOutreachEmail` - Email generation

**Setup**:
1. Requires: Dataverse MCP server
2. Authentication: Service principal with Sales permissions
3. Use with: Claude, Copilot Studio agents

---

#### 2. Dynamics 365 ERP MCP Server (Official - Preview)
**Documentation**: https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/copilot/copilot-mcp

**Features**:
- Access to hundreds of thousands of ERP functions
- 12 core interaction tools
- Automatically reflects environment customizations
- Security role aware

**Requirements**:
- Finance and Operations version 10.0.2428.15+
- Tier 2+ environment

---

### Community Dynamics MCPs

#### 3. mcp-dynamics365-server (Community)
**GitHub**: https://github.com/srikanth-paladugula/mcp-dynamics365-server
**Type**: Node.js/TypeScript

**Features**:
- User info retrieval
- Account CRUD operations
- Opportunity queries
- Custom entity support

**Setup**:
```bash
git clone https://github.com/srikanth-paladugula/mcp-dynamics365-server.git
npm install

# .env
DYNAMICS_URL=https://yourorg.crm.dynamics.com
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
TENANT_ID=your-tenant-id

npm run build
node build/index.js
```

---

#### 4. PowerPlatform-MCP (Community - For Dataverse)
**GitHub**: https://github.com/michsob/powerplatform-mcp
**Type**: Node.js

**Features**:
- Entity metadata exploration
- OData queries
- Relationship mapping
- Attribute access with option sets
- Works with any Dataverse environment

**Setup**:
```bash
npm install -g powerplatform-mcp

# Environment variables
POWERPLATFORM_URL=https://yourenv.crm.dynamics.com
CLIENT_ID=your-client-id
CLIENT_SECRET=your-client-secret
TENANT_ID=your-tenant-id
```

---

## 📚 Dynamics-Focused Learning Resources

### Microsoft Official Documentation
- **Copilot Studio MCP**: https://learn.microsoft.com/en-us/microsoft-copilot-studio/agent-extend-action-mcp
- **Agent Framework**: https://learn.microsoft.com/en-us/agent-framework/
- **Teams Bot Development**: https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/
- **Power Virtual Agents**: https://learn.microsoft.com/en-us/power-virtual-agents/
- **Dynamics Sales MCP**: https://learn.microsoft.com/en-us/dynamics365/sales/connect-to-model-context-protocol-sales

### Tutorials & Guides
- **Copilot Studio + MCP Integration**: https://ariel-ibarra.medium.com/how-to-connect-microsoft-copilot-studio-with-mcp-servers-a-complete-integration-guide-506e0c96f843
- **Microsoft MCP for Beginners**: https://github.com/microsoft/mcp-for-beginners

---

## ⚙️ Configuring Dynamics MCPs for Claude Code

### Add Official Dynamics MCPs

```bash
# Add Dynamics 365 MCP (if available for your scenario)
claude mcp add dynamics365-mcp --scope project

# Configure environment variables in .mcp.json
```

### Configuration Template

```json
{
  "mcpServers": {
    "dynamics365": {
      "command": "npx",
      "args": ["mcp-dynamics365-server"],
      "env": {
        "DYNAMICS_URL": "https://yourorg.crm.dynamics.com",
        "CLIENT_ID": "your-client-id",
        "CLIENT_SECRET": "your-client-secret",
        "TENANT_ID": "your-tenant-id"
      }
    },
    "powerplatform": {
      "command": "npx",
      "args": ["-y", "powerplatform-mcp"],
      "env": {
        "POWERPLATFORM_URL": "https://yourenv.crm.dynamics.com",
        "CLIENT_ID": "your-client-id",
        "CLIENT_SECRET": "your-client-secret",
        "TENANT_ID": "your-tenant-id"
      }
    }
  }
}
```

---

## ✅ Security Best Practices for Dynamics Bots

1. **Store credentials securely**: Use `.env` files (NOT in git)
2. **Azure Key Vault**: Production use should reference Azure Key Vault
3. **Service Principals**: Use dedicated service principals for bot operations
4. **Least Privilege**: Grant only necessary Dynamics permissions
5. **Audit Logging**: Enable Dynamics audit trail for bot actions
6. **Never hardcode**: Credentials must always be environment variables

```env
# .env (NOT in git)
DYNAMICS_URL=https://yourorg.crm.dynamics.com
CLIENT_ID=xxxxxxxxxxxx
CLIENT_SECRET=xxxxxxxxxxxx
TENANT_ID=xxxxxxxxxxxx
```

---

## 🎯 Dynamics Bot Use Cases

### 1. **Copilot Studio Bots**
Best for: Non-technical users building Dynamics-connected chatbots
- Access any Dynamics entity
- No coding required
- Native Teams/web deployment
- Built-in security & governance

### 2. **Teams Integrated Bots**
Best for: Enterprise Teams deployments with Dynamics data access
- Deep Teams integration
- MCP support for custom operations
- Agent Framework for complex logic
- Enterprise security

### 3. **Power Virtual Agents**
Best for: Low-code chatbot solutions
- Native Dynamics connector
- Visual workflow designer
- Teams/web deployment
- No coding knowledge required

### 4. **Custom MCP Servers**
Best for: Advanced Dynamics integrations via Claude
- Full programmatic control
- Custom business logic
- Integration with multiple systems
- Development team focused

---

## 🚀 Quick Start for Dynamics Bots

### 1. **Fastest (Copilot Studio)**
1. Go to: https://copilotstudio.microsoft.com
2. Create new copilot
3. Add Dynamics 365 connector
4. Configure topics for your use cases
5. Deploy to Teams

### 2. **Teams Integration**
Use **Microsoft Agent Framework** or **Teams AI Library**:
- Leverage official MCP support
- Deploy to Teams natively
- Access Dynamics via Dataverse

### 3. **Custom MCP Integration**
Deploy a community MCP server:
- **Dynamics**: https://github.com/srikanth-paladugula/mcp-dynamics365-server
- **PowerPlatform**: https://github.com/michsob/powerplatform-mcp

---

## ⚠️ Important Notes

### Microsoft Agent Framework
- **Status**: Public Preview (Oct 2, 2025)
- **Native MCP support**: Yes
- **Dynamics integration**: Full via Dataverse API
- **Recommendation**: Use this for new development

### Bot Framework SDK
- **Status**: Deprecating
- **Final Support**: December 31, 2025
- **Migration**: Move to Agent Framework
- **Guide**: https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/bf-migration-guidance

---

## 🔗 Dynamics Bot Resources

| Resource | Purpose | Link |
|----------|---------|------|
| **Copilot Studio** | Official AI agent builder | https://copilotstudio.microsoft.com |
| **Power Virtual Agents** | Low-code chatbots | https://learn.microsoft.com/en-us/power-virtual-agents/ |
| **Agent Framework** | Advanced agent development | https://learn.microsoft.com/en-us/agent-framework/ |
| **Teams Bot Docs** | Teams integration | https://learn.microsoft.com/en-us/microsoft-365/agents-sdk/ |
| **MCP Registry** | Find Dynamics MCPs | https://registry.modelcontextprotocol.io |

---

**Last Updated**: November 2025
**Dynamics-Specific Bot Options**: 4 Official + 2 Community MCPs
