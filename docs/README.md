# Documentation Index

Welcome to the Claude Dynamics Brain documentation. This directory contains comprehensive guides for developing Dynamics 365 solutions.

## Quick Navigation

### 1. [Getting Started](01-getting-started.md)
**Start here!** Learn how to:
- Use Claude Dynamics Brain tools
- Scaffold projects quickly
- Access specialized agents
- Understand the project structure

### 2. [Plugin Development Guide](02-plugin-development.md)
Comprehensive guide for C# plugin development:
- Plugin fundamentals
- Common patterns (pre/post operations)
- Entity operations
- Query optimization
- Security & permissions
- Testing and debugging
- Performance best practices

### 3. [Dynamics MCPs & Bot Integration](03-available-mcp-servers.md)
Dynamics-specific MCP servers and bot options:
- **Official Microsoft MCPs** for Dynamics 365 ERP and Sales
- **Community MCPs** for Dynamics development
- **Power Platform MCPs** for Dataverse
- Bot integration (Copilot Studio, Teams, Power Virtual Agents)
- Configuration and setup guide
- Security best practices

### 4. [Bot & Chatbot Integration for Dynamics](04-bot-mcp-integrations.md)
Building AI agents that work with Dynamics 365:
- **Microsoft Copilot Studio** (GA - recommended)
- **Teams Bot Integration** (GA - enterprise)
- **Power Virtual Agents** (GA - low-code)
- **Agent Framework** (Preview - advanced)
- Dynamics-specific MCPs
- Security and configuration

### 5. [Power Apps Code Apps Development](06-power-apps-code-apps.md)
Build modern React-based applications in Power Apps:
- React 18 + TypeScript + Vite setup
- Fluent UI v9 components and theming
- Power Platform SDK integration
- Data service architecture (mock + real)
- Server-side DataGrid operations
- Accessibility and responsive design
- Local development with mock data
- Power Apps integration and deployment

### 6. [Security Guidelines](05-security-guidelines.md)
Essential security practices:
- Input validation
- Authentication & authorization
- Data protection
- SQL injection prevention
- XSS prevention
- Secrets management
- Compliance & auditing

## Quick Commands Reference

```bash
# Create a Power Apps Code App project
/code-app-scaffold MyCodeApp

# Create a plugin project
/plugin-scaffold MyPluginName

# Generate a cloud flow template
/flow-template cloud-flow Account

# Create a custom connector skeleton
/connector-stub MyConnector

# Package a solution for deployment
/solution-package MySolution 1.0.0

# Run a security audit
/security-scan ./path/to/code

# Get API documentation
/api-reference web-api

# Setup testing environment
/test-setup unit

# Prepare deployment
/deploy-solution solution.zip production
```

## Specialized Agents

Get expert help from specialized agents:

| Agent | Use For |
|-------|---------|
| **plugin-developer** | C# plugin development, SDK usage |
| **cloud-architect** | Cloud flow design, integration patterns |
| **lowcode-expert** | Canvas apps, model-driven apps, Power Pages |
| **connector-specialist** | Custom connector development |
| **solution-manager** | Solution packaging, deployment, ALM |
| **security-reviewer** | Security audits, vulnerability assessment |
| **code-optimizer** | Performance optimization, query tuning |

## Custom Skills

Claude automatically uses these skills based on context:

- **dynamics-plugin-dev** - C# plugin patterns and best practices
- **power-automate-flows** - Cloud flow optimization
- **custom-connector-builder** - Connector development
- **typescript-actions** - TypeScript/JavaScript development
- **lowcode-automation** - Canvas and model-driven apps
- **yaml-configurations** - Configuration management
- **dynamics-api-integration** - API usage patterns
- **solution-packaging** - Solution management

## Project Structure

```
ClaudeDynamicsBrainSettings/
├── .claude/                          # Claude configuration
│   ├── agents/                       # Specialized agents
│   │   ├── plugin-developer.md
│   │   ├── cloud-architect.md
│   │   ├── lowcode-expert.md
│   │   ├── connector-specialist.md
│   │   ├── solution-manager.md
│   │   ├── security-reviewer.md
│   │   └── code-optimizer.md
│   ├── commands/                     # Slash commands
│   │   ├── plugin-scaffold.md
│   │   ├── flow-template.md
│   │   ├── connector-stub.md
│   │   ├── solution-package.md
│   │   ├── security-scan.md
│   │   ├── api-reference.md
│   │   ├── deploy-solution.md
│   │   └── test-setup.md
│   ├── skills/                       # Domain expertise
│   │   ├── dynamics-plugin-dev/SKILL.md
│   │   ├── power-automate-flows/SKILL.md
│   │   ├── custom-connector-builder/SKILL.md
│   │   ├── typescript-actions/SKILL.md
│   │   ├── lowcode-automation/SKILL.md
│   │   ├── yaml-configurations/SKILL.md
│   │   ├── dynamics-api-integration/SKILL.md
│   │   └── solution-packaging/SKILL.md
│   ├── templates/                    # Code templates
│   │   ├── plugin-template.cs
│   │   ├── plugin-unittest-template.cs
│   │   ├── cloud-flow-template.json
│   │   ├── connector-openapi-template.json
│   │   ├── custom-action-template.xml
│   │   └── typescript-action-template.ts
│   ├── .mcp.json                     # MCP servers config
│   └── settings.json                 # Project settings
├── docs/                             # Documentation
│   ├── README.md                     # This file
│   ├── 01-getting-started.md
│   ├── 02-plugin-development.md
│   ├── 03-available-mcp-servers.md
│   ├── 04-bot-mcp-integrations.md
│   ├── 05-security-guidelines.md
│   └── 06-power-apps-code-apps.md
└── CLAUDE.md                         # Project context

```

## Key Workflows

### Build a Plugin

1. `/ plugin-scaffold MyPlugin` - Create project structure
2. Implement business logic
3. `/test-setup unit` - Create tests
4. Ask **plugin-developer** agent for review
5. `/ security-scan` - Run security audit
6. Ask **code-optimizer** agent for performance review
7. `/solution-package MySolution 1.0.0` - Package for deployment
8. `/deploy-solution` - Deploy to target environment

### Create a Cloud Flow

1. `/flow-template cloud-flow EntityName` - Get template
2. Configure in Power Automate
3. Ask **cloud-architect** agent for design review
4. Test with various scenarios
5. Package with `/solution-package`
6. Deploy with `/deploy-solution`

### Build a Custom Connector

1. `/connector-stub ConnectorName` - Get OpenAPI skeleton
2. Define API operations
3. Configure authentication
4. Ask **connector-specialist** agent for review
5. Test in Power Automate
6. Deploy to Power Platform

## Tips for Success

### 1. Start with Templates
Don't start from scratch - use provided templates to save time and follow best practices.

### 2. Leverage Agents
- Stuck on a problem? Ask the relevant specialist agent
- Before deployment? Get a security review from security-reviewer
- Performance issues? Ask code-optimizer for optimization tips

### 3. Follow Security Guidelines
- Review [05-security-guidelines.md](05-security-guidelines.md) before development
- Run `/security-scan` before deployment
- Audit sensitive operations

### 4. Test Early and Often
- Use test templates to write tests from the start
- Test error scenarios, not just happy path
- Performance test under realistic load

### 5. Document Your Work
- Keep documentation up to date
- Comment complex logic
- Document assumptions and constraints

### 6. Monitor Post-Deployment
- Watch for errors in traces
- Monitor performance metrics
- Address issues quickly

## Best Practices Checklist

- ✅ Use templates for consistency
- ✅ Validate all inputs
- ✅ Implement error handling
- ✅ Write tests for critical logic
- ✅ Run security audits
- ✅ Optimize performance
- ✅ Document code and decisions
- ✅ Test in staging first
- ✅ Have rollback plan
- ✅ Monitor post-deployment

## Getting Help

### Ask a Specialist
```
I need help with [topic]. Can you delegate to the [agent-name] agent?
```

### Run a Scan
```
/security-scan ./
```

### Access Documentation
```
/api-reference [topic]
```

## Development Standards

### Code Quality
- Use TypeScript for all JavaScript
- Follow Microsoft naming conventions
- Write XML documentation
- Keep functions focused
- Aim for test coverage > 80%

### Security
- No hardcoded secrets
- Validate all inputs
- Check permissions
- Encrypt sensitive data
- Secure error messages

### Performance
- Optimize queries
- Implement caching
- Use batch operations
- Monitor execution time
- Profile before optimization

### Deployment
- Test in staging
- Document changes
- Plan rollbacks
- Communicate updates
- Monitor results

## Resources

- [Dynamics 365 Developer Docs](https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/overview)
- [Power Platform Documentation](https://learn.microsoft.com/en-us/power-platform/)
- [OpenAPI Specification](https://www.openapis.org/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [OWASP Security](https://owasp.org/)

## Questions?

1. Check the relevant guide (01-05)
2. Ask a specialist agent
3. Run `/security-scan` for security issues
4. Use `/api-reference` for API questions
5. Request `/test-setup` for testing help

---

**Happy coding!** 🚀

Last updated: November 2025
