---
name: typescript-actions
description: TypeScript and JavaScript development for Dynamics actions, cloud flows, and Power Platform client-side operations with modern tooling and best practices
---

# TypeScript/JavaScript Actions Development

## TypeScript Best Practices

### Type Safety
- Interface definitions for entities
- Strict null checking
- Union types for specific values
- Generic types for reusable code
- Type guards and assertions

### Code Organization
- Module structure with exports/imports
- Namespace organization
- Barrel exports for clean imports
- Separation of concerns
- Single responsibility principle

### Async/Await Patterns
- Promise handling
- Error boundary establishment
- Concurrent operations management
- Timeout implementations
- Resource cleanup

## Power Platform Integration

### Dynamics Web API
- CRUD operations via Web API
- Query expressions and FetchXML
- Batch operations
- Request headers and authentication
- Error handling strategies

### Client-Side Scripts
- Form scripts (OnLoad, OnSave, OnChange)
- Command bar button scripts
- Ribbon commands
- Grid scripts
- Dialog handlers

### Business Rules
- Conditional field visibility
- Validation rules
- Dynamic calculations
- User role-based logic
- Field dependency management

## Testing Strategies

### Unit Testing
- Jest configuration for Node environments
- Mocking Dynamics Web API calls
- Testing async operations
- Code coverage requirements
- Test organization

### Integration Testing
- Testing with real Dynamics environment
- Data setup and teardown
- Transaction management
- Error scenario testing

## Build & Deployment

### Build Tools
- TypeScript compilation
- Webpack bundling
- Minification and optimization
- Source map generation
- Asset management

### Deployment Process
- Build artifact generation
- Environment-specific configurations
- Version management
- Rollback strategies
- Performance monitoring

## Common Patterns

### API Requests Pattern
- Request construction
- Header setup
- Error handling
- Retry logic
- Response parsing

### Data Transformation Pattern
- Input validation
- Mapping transformations
- Type conversion
- Output formatting
- Error handling

### Event Handling Pattern
- Event listener setup
- Event delegation
- Memory leak prevention
- Error propagation
- Cleanup logic

## Security Considerations

- Input validation and sanitization
- Output encoding to prevent XSS
- CSRF token handling
- Sensitive data protection
- Secure token storage
- Permission checks

## Performance Optimization

- Lazy loading modules
- Debouncing and throttling
- Caching strategies
- DOM manipulation optimization
- Network request optimization
- Memory management

## Tools & Libraries

- TypeScript compiler
- Jest for testing
- Webpack for bundling
- TSLint for code quality
- Prettier for formatting
- Dynamics Web API SDK
