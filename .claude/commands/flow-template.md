---
description: Generate cloud flow templates and examples for common automation scenarios like record creation, approval workflows, and notifications
argument-hint: [FlowType] - cloud-flow, approval-workflow, notification-flow
allowed-tools: Write, Bash
---

Generate a cloud flow template for Power Automate with the following options:

## Flow Types Available
- **cloud-flow**: Basic automated cloud flow triggered by record changes
- **approval-workflow**: Multi-level approval process with notifications
- **notification-flow**: Email/Teams notification flow with dynamic content
- **sync-flow**: Data synchronization between systems
- **bulk-operation**: Bulk record processing flow

## Task
Create a complete cloud flow template with:
- Trigger configuration
- Action sequences
- Error handling scope
- Variable declarations
- Connector actions
- Condition logic
- Comments explaining flow logic
- Export-ready JSON format

## Parameters
- Flow Type: $1 (default: cloud-flow)
- Target Entity: $2 (default: Account)
- Additional Options: $3 (optional parameters)

## Output
Provide a complete, copy-paste-ready cloud flow definition that can be imported into Power Automate, including all necessary connectors and configurations.
