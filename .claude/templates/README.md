# Dynamics 365 Development Templates

This directory contains templates for common Dynamics 365 development scenarios. Use these as starting points for your projects.

## Available Templates

### Plugin Development

#### `plugin-template.cs`
Complete C# plugin template with:
- IPlugin interface implementation
- Plugin context extraction
- Pre/post image handling
- Entity validation
- Error handling with plugin trace
- XML documentation comments

**Usage**: Copy this template when creating a new Dynamics 365 plugin

**Example**:
```bash
/plugin-scaffold MyCustomPlugin
```

#### `plugin-unittest-template.cs`
MSTest unit test template for plugins with:
- Mock IOrganizationService setup
- Mock IPluginExecutionContext
- Pre-image and post-image test data
- Multiple test scenarios (Create, Update, Delete)
- Assert patterns for plugin validation

**Usage**: Use when setting up unit tests for your plugins

### Cloud Flows

#### `cloud-flow-template.json`
Power Automate cloud flow template with:
- Dataverse triggers (record created/updated)
- Condition blocks
- Approval workflows
- Email notifications
- Error handling scopes
- Retry policies

**Usage**: Import into Power Automate or use as reference for flow structure

**Key patterns**:
- Event-driven triggers
- Approval routing
- Error handling with scopes
- Retry logic

### Custom Connectors

#### `connector-openapi-template.json`
OpenAPI 3.0 specification template for custom connectors with:
- REST API endpoint definitions
- OAuth 2.0 authentication
- Request/response schemas
- Parameter definitions
- Example payloads

**Usage**: Use when building custom connectors for Power Platform

**Configuration steps**:
1. Update the API base URL
2. Configure authentication (OAuth, API Key, or Basic)
3. Define operations (GET, POST, PUT, DELETE)
4. Add request/response schemas
5. Test with Power Platform connector designer

### TypeScript/JavaScript Actions

#### `typescript-action-template.ts`
TypeScript action template for Dynamics operations with:
- Dataverse Web API integration
- Type-safe entity operations
- Error handling
- Async/await patterns
- Environment configuration

**Usage**: Use for client-side TypeScript actions in canvas apps or cloud flows

**Features**:
- Strongly typed entity interfaces
- Web API helper functions
- Error boundary handling
- Environment-aware configuration

### Custom Actions (Workflows)

#### `custom-action-template.xml`
Dynamics 365 custom action XML definition with:
- Input/output parameters
- Workflow steps
- Entity associations
- Conditional logic

**Usage**: Import into Dynamics 365 solution for custom workflow actions

### Power Apps Code Apps

#### `code-app-package-json`
Package.json template for Power Apps Code Apps with:
- React 18 + TypeScript
- Vite build configuration
- Fluent UI v9 dependencies
- Power Platform SDK
- Development scripts

#### `code-app-tsconfig.json`
TypeScript configuration for Code Apps with:
- React JSX support
- Strict type checking
- Module resolution
- Path aliases

#### `code-app-tsconfig-app.json`
App-specific TypeScript configuration extending base config

#### `code-app-vite-config.ts`
Vite configuration for Power Apps with:
- Port 3000 (required for Power Apps)
- Base path configuration
- React plugin
- Path alias resolution

**Usage**: Use `/code-app-scaffold` command to generate a complete Code App project

## Template Usage Patterns

### Quick Start Workflows

1. **Creating a Plugin**:
   ```bash
   /plugin-scaffold MyPluginName
   # Uses: plugin-template.cs, plugin-unittest-template.cs
   ```

2. **Building a Custom Connector**:
   ```bash
   /connector-stub MyConnectorName
   # Uses: connector-openapi-template.json
   ```

3. **Creating a Cloud Flow**:
   ```bash
   /flow-template approval-workflow
   # Uses: cloud-flow-template.json
   ```

4. **Scaffolding a Code App**:
   ```bash
   /code-app-scaffold MyCodeApp
   # Uses: code-app-*.json/ts files
   ```

### Best Practices

1. **Always customize templates** - Don't use templates as-is; adapt to your specific requirements
2. **Follow naming conventions** - Use consistent naming across your project
3. **Update XML documentation** - Keep comments and documentation current
4. **Test thoroughly** - Use unit test templates and add integration tests
5. **Version control** - Track changes to customized templates in your repository

### Template Customization

To create project-specific templates:

1. Copy template to your project
2. Customize for your scenario
3. Save as a new template in your `.claude/templates/` directory
4. Reference in custom slash commands

### Additional Resources

- **Plugin Development**: See `.claude/skills/dynamics-plugin-dev/SKILL.md`
- **Cloud Flows**: See `.claude/skills/power-automate-flows/SKILL.md`
- **Custom Connectors**: See `.claude/skills/custom-connector-builder/SKILL.md`
- **TypeScript Actions**: See `.claude/skills/typescript-actions/SKILL.md`

## Template Maintenance

Templates are updated periodically to reflect:
- Latest SDK versions
- New API patterns
- Security best practices
- Performance optimizations

Check the Claude Dynamics Brain repository for template updates.

## Contributing

To suggest template improvements:
1. Create an issue describing the enhancement
2. Submit a pull request with updated template
3. Include usage documentation
4. Add test cases if applicable

---

**Last Updated**: 2025-01-17
**Template Version**: 1.0.0
