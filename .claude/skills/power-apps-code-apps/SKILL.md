---
name: power-apps-code-apps
description: Expert guidance for building Power Apps Code Apps using React, TypeScript, Vite, and Fluent UI with Power Platform integration
---

# Power Apps Code Apps Development Expertise

## Overview

Power Apps Code Apps are modern React-based applications that run natively in Power Apps. They combine the flexibility of React development with Power Platform capabilities.

## Core Technologies

### React & TypeScript
- Modern React 18+ development with hooks
- Strong TypeScript typing for type safety
- Component composition and reusability
- Performance optimization (useMemo, useCallback)

### Vite Build Tool
- Lightning-fast development server
- Optimized production builds
- Hot module replacement (HMR)
- Port 3000 requirement for Power Apps
- Base path configuration for deployment

### Fluent UI v9
- Microsoft's design system
- Accessible components (WCAG compliant)
- Design tokens for consistent theming
- DataGrid, Tables, Forms, Navigation
- Light/Dark theme support

### Power Platform SDK
- @pa-client/power-code-sdk integration
- PowerProvider for context management
- Runtime Power Apps context access
- Generated service classes

## Development Workflow

### 1. Project Setup
- Create Vite + React + TypeScript project
- Configure for Power Apps (port 3000, base path)
- Install Power Platform SDK
- Set up Fluent UI with FluentProvider
- Create PowerProvider wrapper

### 2. Data Service Architecture
- Define TypeScript interfaces for all data operations
- Create singleton service factory pattern
- Implement mock services first (no real data initially)
- Support runtime switching between mock/real services
- Maintain same interface for both implementations

### 3. Component Development
- Use Fluent UI components for consistency
- Implement responsive design (mobile-first)
- Add proper accessibility (ARIA, keyboard nav)
- Create loading skeletons for data states
- Handle error states gracefully

### 4. Local Development & Testing
- Run with mock data first
- Test all features locally
- Verify responsive design
- Test accessibility
- Performance profiling

### 5. Power Apps Configuration
- Initialize with `pac code init`
- Configure environment and connections
- Add data sources (SQL, Office 365, etc.)
- Set up stored procedures references

### 6. Deployment
- Build with `npm run build`
- Deploy with `pac code push`
- Test in Power Apps environment
- Monitor runtime performance

## Key Architecture Patterns

### Data Service Interface Pattern
```typescript
// Service interface - contract for both mock and real
interface IDataService {
  getItems(params: GetItemsParams): Promise<GetItemsResponse>;
  createItem(item: ItemInput): Promise<Item>;
  updateItem(id: string, item: ItemInput): Promise<Item>;
  deleteItem(id: string): Promise<void>;
}

// Mock implementation - for local development
class MockDataService implements IDataService { ... }

// Real implementation - for production
class RealDataService implements IDataService { ... }

// Service factory - runtime selection
class ServiceFactory {
  static create(useMock: boolean = true): IDataService { ... }
}
```

### Component Patterns
- Container vs. Presentational components
- Custom hooks for data fetching
- Compound components for complex UI
- Context for global state (theme, user, etc.)

## Code Quality Standards

### TypeScript
- Strict mode enabled
- No `any` types except justified cases
- Proper interface definitions for all data shapes
- Generic types for reusable components

### Accessibility (WCAG 2.1 AA)
- ARIA labels on interactive elements
- Keyboard navigation support
- Color contrast ratios (4.5:1 normal, 3:1 large)
- Focus management
- Semantic HTML

### Performance
- Code splitting with dynamic imports
- Proper React.memo usage
- Dependency array management
- Bundle size optimization
- Server-side pagination for large datasets

### Responsive Design
- Mobile-first approach
- CSS Grid/Flexbox layouts
- Touch-friendly targets (44px minimum)
- Proper viewport configuration
- Test on multiple devices

## Common Implementation Patterns

### DataGrid with Server-Side Sorting
- Use Fluent UI DataGrid component
- Server-side sort/filter/pagination
- Resizable columns with proper constraints
- Loading skeletons during data fetch
- Proper accessibility attributes

### Forms
- Controlled inputs with React state
- Validation on blur and submit
- Error message display
- Loading state during submission
- Success/failure feedback

### Authentication & Authorization
- Use Power Apps user context
- Check permissions before operations
- Handle unauthorized access
- Implement role-based UI

### Error Handling
- Try-catch blocks with proper error logging
- User-friendly error messages
- Error boundaries for component crashes
- Retry mechanisms for failed requests
- Graceful degradation

## Development Tips

### Local Testing
- Start with mock data only
- Build features with mocked responses
- Test error scenarios manually
- Verify responsive behavior
- Check accessibility with screen reader

### Debugging
- Use React Developer Tools
- Browser DevTools for network inspection
- Console logging for debugging
- Source maps for TypeScript debugging
- Power Apps studio's developer tools

### Performance
- Monitor bundle size with Vite analysis
- Profile React components
- Check for unnecessary re-renders
- Optimize images and assets
- Use production builds for testing

## Common Pitfalls to Avoid

1. **Client-side sorting on large datasets** - Always use server-side sorting
2. **Missing accessibility features** - Include ARIA labels and keyboard nav
3. **Not handling loading states** - Always show skeleton or spinner
4. **Hardcoding environment values** - Use configuration/environment variables
5. **Building without mocks first** - Always start with mocked data
6. **Ignoring responsive design** - Test on mobile devices
7. **Not implementing error handling** - Handle all async operations
8. **Verbose npm scripts** - Keep build scripts simple and clear

## Testing Strategy

### Unit Tests
- Test components with React Testing Library
- Test hooks with custom test utilities
- Test utility functions independently
- Mock external dependencies

### Integration Tests
- Test data flow end-to-end
- Test with both mock and real services
- Test form submissions
- Test navigation

### E2E Tests
- Test in Power Apps environment
- Test with real data
- Test user workflows
- Test on different devices

## Deployment Checklist

- ✅ All features tested with mock data
- ✅ Responsive design verified
- ✅ Accessibility audit completed
- ✅ Performance optimized
- ✅ Environment variables configured
- ✅ Power Platform environment ready
- ✅ Connections and data sources configured
- ✅ Build succeeds without errors
- ✅ Initial deployment tested
- ✅ Monitoring configured

## Resources

- [Power Apps Code Apps Documentation](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-app-tutorial)
- [React 18 Documentation](https://react.dev)
- [Fluent UI v9 Documentation](https://react.fluentui.dev/)
- [Vite Documentation](https://vitejs.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Web Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/WCAG21/quickref/)
