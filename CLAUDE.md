# Claude Dynamics Brain - Development Context

## Project Overview
This repository is configured as a Claude brain for comprehensive Microsoft Dynamics 365 development, covering cloud-native application development with support for C# plugins, TypeScript/JavaScript actions, low-code automation, cloud flows, custom connectors, and solution management.

## Core Development Areas

### 1. C# Plugin Development
- **SDK**: Dynamics 365 Plugin Development
- **Patterns**: Early binding, late binding, entity references
- **Security**: Permission context, organization service, synchronous plugins
- **Best Practices**: Plugin registration, plugin isolation, event pipeline handling

### 2. TypeScript/JavaScript Development
- **Environments**: Cloud flows, canvas apps, model-driven apps
- **Frameworks**: React, Angular, Vue for custom UI components
- **Libraries**: Dynamics Web API, Power Platform connectors
- **Build Tools**: npm, webpack, TypeScript compilation

### 3. Cloud Flows & Automation
- **Types**: Cloud flows, desktop flows, business process flows
- **Triggers**: Power Automate, Power Apps, Dynamics events
- **Connectors**: Standard, premium, and custom connectors
- **Configuration**: YAML-based flow definitions

### 4. Custom Connectors
- **Standards**: OpenAPI 3.0 specification
- **Authentication**: OAuth 2.0, API Key, Basic Auth
- **Deployment**: Custom connector packages
- **Documentation**: Swagger specifications

### 5. Low-Code Development
- **Canvas Apps**: Responsive, formula-based UI
- **Model-Driven Apps**: Entity-driven, form-based UI
- **Power Pages**: Customer-facing web portals
- **Power Automate**: Visual workflow designer

### 6. Solution Management
- **Packaging**: Managed and unmanaged solutions
- **Versioning**: Semantic versioning strategy
- **Deployment**: Staging, testing, production environments
- **CI/CD**: Automation and deployment pipelines

## Development Standards

### Code Quality
- **Type Safety**: Use TypeScript for all JavaScript projects
- **Testing**: Unit tests (MSTest, Jest), integration tests
- **Documentation**: XML documentation for C#, JSDoc for JavaScript
- **Security**: Input validation, CORS handling, least-privilege access

### Security Guidelines
- **Authentication**: OAuth 2.0 for connectors, service principals for automation
- **Data Protection**: Encryption at rest and in transit
- **Plugin Security**: Always validate in plugin context
- **API Security**: Rate limiting, input sanitization

### Performance Optimization
- **Query Optimization**: Use FetchXML efficiently, avoid N+1 queries
- **Caching**: Implement caching strategies for frequently accessed data
- **Async Operations**: Use batch operations for bulk processing
- **Flow Efficiency**: Minimize cloud flow execution steps

## MCP Servers Available
- `github` - Repository management and code search
- `git` - Local Git repository operations
- `filesystem` - File operations and code browsing
- `fetch` - Web content retrieval for documentation
- `sqlite` - Testing database operations
- `brave-search` - Web search capabilities
- `powerplatform` - Power Platform Dataverse operations (npm: powerplatform-mcp)

**Note**: For community Dynamics 365 MCP server setup, see `.claude/mcp/README.md`

## Custom Skills
1. `dynamics-plugin-dev` - C# plugin development expertise
2. `power-automate-flows` - Cloud flow optimization
3. `custom-connector-builder` - Connector development
4. `typescript-actions` - TypeScript/JavaScript actions
5. `lowcode-automation` - Low-code development
6. `yaml-configurations` - Configuration management
7. `dynamics-api-integration` - API integration patterns
8. `solution-packaging` - Solution management
9. `power-apps-code-apps` - Power Apps Code Apps development

## Specialized Agents
- `plugin-developer` - C# plugin expert
- `cloud-architect` - Cloud flow and architecture
- `lowcode-expert` - Canvas/model-driven apps
- `connector-specialist` - Custom connectors
- `solution-manager` - Solution packaging/deployment
- `security-reviewer` - Security audit
- `code-optimizer` - Performance optimization

## Quick Commands
- `/plugin-scaffold [PluginName]` - Create plugin structure
- `/flow-template [FlowType]` - Cloud flow template (cloud-flow, approval-workflow, notification-flow)
- `/connector-stub [ConnectorName]` - Custom connector skeleton
- `/code-app-scaffold [AppName]` - Scaffold Power Apps Code App project
- `/solution-package [SolutionName] [Version]` - Package solution
- `/security-scan [CodePath]` - Security audit
- `/api-reference [Topic]` - Dynamics API docs (web-api, org-service, fetch-xml, etc.)
- `/deploy-solution [SolutionFile] [TargetEnvironment]` - Deployment guide
- `/test-setup [TestType]` - Test configuration (unit, integration, e2e)

## Project Structure
```
.
├── .claude/                    # Claude configuration
│   ├── agents/                # Specialized agents (7 agents)
│   ├── commands/              # Custom slash commands (9 commands)
│   ├── skills/                # Custom skills (9 skills)
│   ├── templates/             # Project templates (16 templates)
│   ├── mcp/                   # MCP server documentation
│   ├── .mcp.json              # MCP server configuration
│   ├── settings.json          # Project settings
│   └── settings.local.json    # Local user overrides
├── docs/                       # Development documentation
├── plugins/                    # C# plugin projects (optional)
├── flows/                      # Cloud flow definitions (optional)
├── connectors/                 # Custom connector projects (optional)
└── CLAUDE.md                   # This file
```

## Getting Started
1. Run `/plugin-scaffold` to start a plugin project
2. Run `/flow-template` for cloud flow examples
3. Review security guidelines before development
4. Use `/security-scan` before publishing
5. Use `/solution-package` for deployment preparation

## Documentation Reference
- Dynamics 365 SDK: https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/overview
- Power Platform: https://learn.microsoft.com/en-us/power-platform/
- Custom Connectors: https://learn.microsoft.com/en-us/connectors/custom-connectors/
- TypeScript Best Practices: https://www.typescriptlang.org/docs/

## Versioning Strategy
- **Major**: Breaking changes or significant feature releases
- **Minor**: New features, backward compatible
- **Patch**: Bug fixes and security patches

Format: `major.minor.patch` (e.g., 1.2.3)

## Support Resources
Use the specialized agents for domain-specific questions:
- Plugin questions → `/agents` → select `plugin-developer`
- Flow architecture → `/agents` → select `cloud-architect`
- Custom connectors → `/agents` → select `connector-specialist`
- Deployment concerns → `/agents` → select `solution-manager`
