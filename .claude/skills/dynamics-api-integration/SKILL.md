---
name: dynamics-api-integration
description: Comprehensive guidance for integrating with Dynamics 365 APIs including Web API, Organization Service, and Plug-in Service endpoints
---

# Dynamics 365 API Integration Expertise

## Web API Fundamentals

### RESTful Operations
- Base URL construction
- API version management
- Environment URLs
- Security headers
- Request formatting

### CRUD Operations
- Create (POST) records
- Retrieve (GET) single records
- Update (PATCH) records
- Delete (DELETE) records
- Upsert operations

### Query Operations
- OData query syntax
- Filter expressions
- Select columns
- Order by sorting
- Expand related records
- Batch requests

## Authentication Methods

### OAuth 2.0
- Service principals for server-to-server
- User authentication flows
- Token acquisition and caching
- Refresh token handling
- Scope definitions

### Connection Strings
- Integrated authentication
- Client credentials
- User impersonation
- Multi-tenant scenarios

## Advanced Query Patterns

### FetchXML
- FetchXML syntax and structure
- Filter conditions and operators
- Join operations
- Aggregation functions
- Performance optimization

### OData Queries
- Filter expressions with operators
- Comparison and logical operators
- String functions
- Date functions
- Aggregate functions

## Error Handling & Retry

### HTTP Status Codes
- 200-299 success codes
- 400 bad request handling
- 401 authentication errors
- 403 authorization errors
- 429 rate limiting
- 500+ server errors

### Retry Strategies
- Exponential backoff
- Idempotent operations
- Circuit breaker pattern
- Timeout configuration
- Failure notification

## Performance Optimization

### Query Optimization
- Column selection
- Filtering at source
- Pagination implementation
- Batch operations
- Concurrent requests

### Caching Strategies
- Client-side caching
- Cache invalidation
- TTL configuration
- Cache warming
- Distributed caching

## Integration Patterns

### Data Synchronization
- Bi-directional sync
- Conflict resolution
- Timestamp tracking
- Change tracking
- Webhook integration

### Bulk Operations
- Batch job submissions
- Bulk import/export
- Progress monitoring
- Error aggregation
- Result processing

## Organization Service

### Entity Operations
- Early binding classes
- Late binding with Entity
- CRUD operations
- QueryExpression usage
- Related records retrieval

### Advanced Operations
- Workflow triggers
- Custom actions
- Organization service properties
- Plugin context usage
- Impersonation

## Rate Limiting & Throttling

### Power Platform Limits
- API throttle limits
- Request patterns
- Concurrent request management
- Backoff strategies
- Capacity planning

### Monitoring Usage
- API calls tracking
- Storage consumption
- Performance metrics
- Cost optimization
- Threshold alerts

## Security Considerations

- HTTPS requirement
- Token security
- Credential storage
- Data validation
- Input sanitization
- CORS handling

## Testing & Debugging

- Postman collections
- Fiddler for request inspection
- Request/response logging
- Error message analysis
- Performance profiling

## SDK & Tools

- Dynamics 365 SDK for .NET
- XrmToolBox
- Plugin registration tool
- Rest client tools
- Monitoring utilities
