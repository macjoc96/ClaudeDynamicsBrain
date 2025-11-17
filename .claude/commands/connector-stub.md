---
description: Generate a custom connector skeleton with OpenAPI specification, authentication configuration, and sample operations ready for customization
argument-hint: [ConnectorName]
allowed-tools: Write, Bash
---

Generate a custom connector skeleton with the following structure:

## Task
Create a new custom connector project with:
- OpenAPI 3.0 specification file
- Authentication configuration (OAuth 2.0, API Key, or Bearer token)
- Sample operations with request/response schemas
- Security schemes definition
- Server configuration
- Parameter definitions
- Error response definitions
- Policy templates
- README with setup instructions

## Connector Details
- Connector Name: $ARGUMENTS (e.g., "MyCustomConnector")
- Base URL: Will prompt for API endpoint
- Authentication Type: Will default to OAuth 2.0 (customizable)
- Initial Operations: 3 sample CRUD operations

## Output
Provide:
1. OpenAPI specification (openapi.json)
2. Connector metadata (apiProperties.json)
3. Policy XML template
4. Setup and deployment guide
5. Authentication configuration example
6. Example operations with complete schemas

All files ready for Power Platform import.
