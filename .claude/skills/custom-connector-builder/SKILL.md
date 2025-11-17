---
name: custom-connector-builder
description: Expert guidance for building and deploying custom connectors using OpenAPI specifications, authentication methods, and Power Platform connector standards
---

# Custom Connector Development Expertise

## OpenAPI Specification

### Structure
- Base URL and server configurations
- Endpoint paths and operations
- Request/response schemas
- Parameter definitions
- Header specifications

### Schema Definition
- Request body schemas with validation
- Response schemas for different HTTP status codes
- Object types and references
- Required vs optional fields
- Data type specifications

## Authentication Methods

### OAuth 2.0
- Authorization Code flow
- Client Credentials flow
- Implicit flow for SPA
- Token refresh strategies
- Scope definitions

### API Key Authentication
- Header-based API keys
- Query parameter keys
- Custom key formats
- Key validation

### Basic Authentication
- Username/password encoding
- HTTPS requirement
- Bearer token patterns

## Connector Development Workflow

### 1. API Analysis
- Understand API documentation
- Identify authentication method
- Map endpoints to operations
- Document request/response formats
- Note rate limits and quotas

### 2. OpenAPI Creation
- Define base URL and servers
- Create operation definitions
- Define schemas for requests/responses
- Configure authentication
- Add error responses

### 3. Connector Creation
- Create connector from OpenAPI
- Configure operations with dynamic values
- Map authentication
- Test each operation
- Validate response handling

### 4. Publishing
- Test in Power Automate
- Document operation descriptions
- Configure icons and branding
- Submit for certification (if required)
- Manage versions

## Advanced Features

### Dynamic Values
- Dropdown lists from API responses
- Dependent parameters
- Formula-based values
- Custom transformations

### Error Handling
- Error code mapping
- User-friendly error messages
- Retry logic
- Timeout configurations

### Rate Limiting
- Throttling awareness
- Batch operation strategies
- Exponential backoff
- Queue management

## Best Practices

- Follow Microsoft naming conventions
- Provide clear operation descriptions
- Include example values and documentation
- Test with various data scenarios
- Implement proper error responses
- Secure sensitive data
- Version API updates
- Monitor connector usage

## Testing & Validation

- Unit test API endpoints
- Integration tests with Power Automate
- Performance testing under load
- Security testing (OWASP top 10)
- Accessibility compliance

## Deployment

### To Power Platform
- Manual upload to environment
- Team distribution
- Sharing in organizations
- Version management

### Certification
- Microsoft Connector Certification
- Compliance requirements
- Testing standards
- Documentation standards
