---
name: dynamics-plugin-dev
description: Expert guidance for C# plugin development targeting Dynamics 365 SDK, including plugin registration, entity operations, query patterns, security contexts, and best practices for synchronous and asynchronous plugins
---

# Dynamics 365 Plugin Development Expertise

## Core Competencies

### Plugin Architecture
- IPlugin interface implementation
- Plugin step registration and lifecycle
- Synchronous vs asynchronous execution context
- Plugin isolation and sandboxing concepts
- Multi-tenant architecture considerations

### Entity Operations
- Create, retrieve, update, delete (CRUD) operations
- Entity reference handling
- Related records navigation
- Attribute validation and type checking
- Organization service usage patterns

### Query Patterns
- FetchXML query construction and optimization
- QueryExpression with filter conditions
- Query performance considerations
- N+1 query prevention
- Batch operation strategies

### Security & Context
- Security context analysis (InitiatingUser, BusinessUnit)
- Permission validation
- Plugin execution context (PreImage, PostImage, Depth)
- Shared variables in execution context
- Principal object operations

### Error Handling
- InvalidPluginExecutionException usage
- Custom error messages
- Plugin trace logging
- Exception handling strategies
- Recovery mechanisms

## Development Workflow

When assisting with plugin development:

1. **Analysis Phase**: Review requirements and understand the Dynamics entity model
2. **Design Phase**: Design plugin architecture with security and performance in mind
3. **Implementation**: Write robust, well-documented C# code
4. **Testing**: Create unit tests with mocked services
5. **Registration**: Guide through plugin registration in Dynamics
6. **Troubleshooting**: Analyze plugin execution traces

## Common Patterns

### Pre-Create Plugin
- Validate input data
- Set default values
- Check for duplicates
- Enforce business rules

### Pre-Update Plugin
- Compare old and new values
- Prevent invalid state transitions
- Validate related data
- Log important changes

### Post-Create/Update Plugin
- Trigger downstream processes
- Update related records
- Send notifications
- Update audit trails

## Best Practices

- Always validate data before operations
- Use early binding for type safety
- Implement proper error handling
- Use plugin trace for debugging
- Keep plugins focused on single responsibility
- Avoid long-running operations in sync plugins
- Cache frequently accessed data
- Use organization service efficiently

## Tools & References

- Plugin Registration Tool
- Plugin Profiler
- Dynamics 365 SDK for .NET
- TraceViewer for analyzing execution logs
