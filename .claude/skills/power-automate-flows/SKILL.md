---
name: power-automate-flows
description: Master cloud flow creation, optimization, and deployment including cloud flows, triggers, conditions, actions, connectors, error handling, and performance best practices
---

# Power Automate Cloud Flows Expertise

## Flow Types

### Cloud Flows
- **Automated Flows**: Triggered by events (Dynamics record changes, email received)
- **Instant Flows**: Triggered manually or from apps (button flows, custom actions)
- **Scheduled Flows**: Run on defined schedules (daily, weekly, monthly)

### Advanced Flows
- **Business Process Flows**: Guide users through business processes
- **Desktop Flows**: Robotic process automation (RPA)
- **Child Flows**: Reusable modular flow components

## Trigger & Action Patterns

### Common Triggers
- When a record is created/updated/deleted
- When a row is selected
- When a flow button is pressed
- On a schedule
- When an HTTP request is received
- Email received events

### Action Categories
- Dynamics 365 operations (CRUD)
- Connector actions (email, Teams, SharePoint)
- Control flow (condition, switch, loop)
- Data operations (compose, parse JSON)
- Scope for error handling

## Performance Optimization

### Flow Efficiency
- Minimize action count per flow step
- Use parallel branches for concurrent operations
- Avoid unnecessary loops and conditions
- Cache frequently used data
- Use filter conditions in queries
- Batch operations where possible

### Error Handling Strategies
- Configure run-after behavior
- Use scopes for grouped error handling
- Implement retry policies
- Send failure notifications
- Log errors for debugging

### Scalability Considerations
- Monitor action limits and licensing
- Design for bulk operations
- Implement throttling awareness
- Use asynchronous patterns
- Archive old flow runs

## Connector Integration

### Authentication
- Service principals for unattended flows
- User context for interactive flows
- Managed identities for cloud resources
- API key and OAuth 2.0 patterns

### Connector Selection
- Standard vs premium connectors
- Custom connectors for unique APIs
- Connector limits and throttling
- Timeout configurations

## YAML Configuration

For Infrastructure-as-Code flows:
- Define trigger conditions in YAML
- Configure action steps declaratively
- Version control flow definitions
- Environment-specific configurations

## Best Practices

- Keep flows simple and focused
- Use descriptive naming conventions
- Document flow purpose and logic
- Test with various data scenarios
- Monitor flow run history and failures
- Use connections securely
- Implement approval workflows
- Schedule maintenance and reviews

## Monitoring & Diagnostics

- Flow run history analysis
- Error pattern identification
- Performance metrics review
- Cloud flow analytics
- Failure notifications setup
