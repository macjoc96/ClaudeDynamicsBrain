# Getting Started with Claude Dynamics Brain

Welcome to the Claude Dynamics Brain environment! This guide will help you get started with Dynamics 365 development using Claude Code's specialized tools and agents.

## What is Claude Dynamics Brain?

Claude Dynamics Brain is a comprehensive Claude Code setup configured specifically for Microsoft Dynamics 365 development. It includes:

- **8 Custom Skills**: Domain-specific expertise in plugin development, cloud flows, connectors, and more
- **7 Specialized Agents**: Expert guidance for different development scenarios
- **8 Quick Commands**: One-step scaffolding and guides for common tasks
- **MCP Servers**: Integration with GitHub, file system, and web resources
- **Project Templates**: Ready-to-use code templates for plugins, flows, and connectors

## Quick Start

### 1. Start with a Plugin Project

To scaffold a new C# plugin project:

```
/plugin-scaffold MyPluginName
```

This creates a complete plugin project structure with:
- IPlugin implementation
- Proper exception handling
- Plugin tracing setup
- Unit test project
- NuGet references configured

### 2. Create a Cloud Flow

To generate a cloud flow template:

```
/flow-template cloud-flow Account
```

This provides a ready-to-import flow with:
- Trigger configuration
- Action sequences
- Error handling scopes
- Sample connector usage

### 3. Build a Custom Connector

To create a custom connector skeleton:

```
/connector-stub MyCustomConnector
```

This includes:
- OpenAPI 3.0 specification
- Authentication setup
- Sample operations
- Deployment instructions

### 4. Deploy a Solution

To prepare your solution for deployment:

```
/solution-package MySolution 1.0.0
```

This generates:
- Deployment checklist
- Version validation
- Rollback procedures
- Release notes

## Using Specialized Agents

When you need expert guidance, use the appropriate agent:

### Plugin Developer
For C# plugin development questions, complex plugin architecture, or SDK usage:

```
Ask the plugin-developer agent about plugin optimization
```

### Cloud Architect
For cloud flow design, integration patterns, or scalability:

```
Ask the cloud-architect agent about automation patterns
```

### Low-Code Expert
For canvas apps, model-driven apps, or Power Pages:

```
Ask the lowcode-expert agent about app design
```

### Connector Specialist
For custom connector development or connector issues:

```
Ask the connector-specialist agent about OpenAPI design
```

### Solution Manager
For solution packaging, deployment, or ALM:

```
Ask the solution-manager agent about deployment strategy
```

### Security Reviewer
For security audits or vulnerability assessment:

```
Ask the security-reviewer agent to scan my code
```

### Code Optimizer
For performance optimization:

```
Ask the code-optimizer agent to optimize queries
```

## Accessing Skills

Claude will automatically use relevant skills based on your request. Key skills include:

- **dynamics-plugin-dev**: C# plugin patterns and best practices
- **power-automate-flows**: Cloud flow optimization
- **custom-connector-builder**: Connector development
- **typescript-actions**: TypeScript/JavaScript development
- **lowcode-automation**: Canvas and model-driven apps
- **yaml-configurations**: Configuration management
- **dynamics-api-integration**: API usage patterns
- **solution-packaging**: Solution management

## Project Structure

```
.
├── .claude/                    # Claude configuration
│   ├── agents/                # Specialized agents
│   ├── commands/              # Slash commands
│   ├── skills/                # Custom skills
│   ├── templates/             # Code templates
│   ├── mcp.json               # MCP configuration
│   └── settings.json          # Project settings
├── docs/                       # Documentation
│   ├── 01-getting-started.md
│   ├── 02-plugin-development.md
│   ├── 03-available-mcp-servers.md
│   ├── 04-bot-mcp-integrations.md
│   ├── 05-security-guidelines.md
│   └── 06-power-apps-code-apps.md
└── CLAUDE.md                   # Project context
```

## Common Development Workflows

### Building a Plugin

1. Run `/plugin-scaffold PluginName` to create project
2. Implement plugin logic in the generated class
3. Add unit tests using the test template
4. Request `security-reviewer` agent to audit code
5. Request `code-optimizer` agent to optimize queries
6. Package with `/solution-package`

### Creating a Cloud Flow

1. Run `/flow-template cloud-flow EntityName` to get started
2. Configure triggers and actions in Power Automate
3. Test with various data scenarios
4. Use `cloud-architect` agent for pattern review
5. Package solution for deployment

### Developing a Custom Connector

1. Run `/connector-stub ConnectorName`
2. Define OpenAPI specification
3. Configure authentication
4. Test operations in Power Automate
5. Use `connector-specialist` agent for review
6. Deploy to Power Platform

## Best Practices

### Code Quality
- Always validate input data
- Implement proper error handling
- Use TypeScript for JavaScript projects
- Write comprehensive tests
- Document complex logic

### Security
- Never hardcode credentials
- Validate all inputs
- Sanitize error messages
- Use least-privilege access
- Run `/security-scan` before deployment

### Performance
- Optimize queries for large datasets
- Implement caching strategies
- Use batch operations
- Monitor execution time
- Request `code-optimizer` agent for optimization

### Deployment
- Test in staging environment first
- Document all changes
- Have rollback procedures
- Communicate with stakeholders
- Monitor post-deployment

## Getting Help

### Ask a Specific Agent

```
Delegate to [agent-name] for specialized advice
```

### Run a Security Audit

```
/security-scan /path/to/code
```

### Get API Reference

```
/api-reference web-api
```

### View Test Configuration

```
/test-setup unit
```

## Tips for Success

1. **Use Templates**: Start with provided templates to save time
2. **Leverage Agents**: Don't hesitate to delegate to specialists
3. **Document**: Keep documentation up to date as you build
4. **Test Early**: Write tests from the beginning
5. **Review Security**: Run security audits before deployment
6. **Monitor Performance**: Use the code-optimizer agent
7. **Version Everything**: Follow semantic versioning

## Next Steps

1. Read [02-plugin-development.md](02-plugin-development.md) for plugin development guide
2. Review [03-available-mcp-servers.md](03-available-mcp-servers.md) for MCP server integration
3. Study [06-power-apps-code-apps.md](06-power-apps-code-apps.md) for modern Power Apps development
4. Check [05-security-guidelines.md](05-security-guidelines.md) for security standards
5. Review [04-bot-mcp-integrations.md](04-bot-mcp-integrations.md) for AI agent integration patterns

## Resources

- [Dynamics 365 SDK Documentation](https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/overview)
- [Power Platform Documentation](https://learn.microsoft.com/en-us/power-platform/)
- [OpenAPI Specification](https://www.openapis.org/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

Happy coding! 🚀
