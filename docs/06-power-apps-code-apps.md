# Power Apps Code Apps Development Guide

Complete guide for building modern React-based applications in Power Apps.

## What are Power Apps Code Apps?

Power Apps Code Apps are cloud-native applications that combine:
- **React 18+** for modern UI development
- **TypeScript** for type-safe code
- **Vite** for fast development and optimized builds
- **Fluent UI v9** for Microsoft design consistency
- **Power Platform SDK** for native Power Apps integration

## Prerequisites

Before getting started, ensure you have:

1. **Node.js 18+** - [Download here](https://nodejs.org/)
2. **Power Platform CLI (pac)** - Required for local development and deployment
3. **npm 9+** - Included with Node.js

### Install Power Platform CLI

```bash
# Windows
dotnet tool install --global Microsoft.PowerApps.CLI.Tool

# macOS/Linux
dotnet tool install --global Microsoft.PowerApps.CLI.Tool
```

### Authenticate with Power Platform

```bash
pac auth create --username your@tenant.onmicrosoft.com
```

Verify installation:
```bash
pac --version
```

---

## Quick Start

### 1. Create New Code App Project

```bash
npm create vite@latest my-code-app -- --template react-ts
cd my-code-app
npm install
npm i --save-dev @types/node
```

### 2. Configure for Power Apps

Update `vite.config.ts`:
```typescript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import * as path from 'path'

export default defineConfig({
  base: "./",
  server: {
    host: "::",
    port: 3000,  // CRITICAL: Power Apps requires port 3000
  },
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
```

Update `tsconfig.app.json`:
```json
{
  "compilerOptions": {
    "verbatimModuleSyntax": false
  }
}
```

### 3. Install Power Platform SDK

```bash
npm install --save-dev "@pa-client/power-code-sdk@https://github.com/microsoft/PowerAppsCodeApps/releases/download/v0.0.2/6-18-pa-client-power-code-sdk-0.0.1.tgz"
```

### 4. Install Fluent UI

```bash
npm install @fluentui/react-components @fluentui/react-icons
```

### 5. Create PowerProvider

Create `src/PowerProvider.tsx`:
```typescript
import React from 'react';
import { PowerProvider as Provider } from '@pa-client/power-code-sdk';

interface PowerProviderProps {
  children: React.ReactNode;
}

const PowerProvider: React.FC<PowerProviderProps> = ({ children }) => {
  return (
    <Provider>
      {children}
    </Provider>
  );
};

export default PowerProvider;
```

### 6. Update main.tsx

```typescript
import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import PowerProvider from './PowerProvider'
import App from './App'

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <PowerProvider>
      <App />
    </PowerProvider>
  </StrictMode>,
)
```

### 7. Setup Fluent UI in App.tsx

```typescript
import {
  FluentProvider,
  webLightTheme,
  Heading,
  Body1
} from '@fluentui/react-components'
import './App.css'

function App() {
  return (
    <FluentProvider theme={webLightTheme}>
      <div className="app">
        <Heading level={1}>Welcome to Power Apps Code App</Heading>
        <Body1>Your app is ready!</Body1>
      </div>
    </FluentProvider>
  )
}

export default App
```

### 8. Install Process Manager

Install `concurrently` to run both dev servers simultaneously:

```bash
npm install --save-dev concurrently
```

### 9. Update package.json Scripts

```json
{
  "scripts": {
    "dev": "concurrently \"vite\" \"pac code run\"",
    "build": "tsc -b && vite build",
    "preview": "vite preview"
  }
}
```

### 10. Start Development

```bash
npm run dev
```

This starts both Vite dev server and Power Apps Code App runtime concurrently on port 3000.

**Note**: `pac code run` and Vite will run in the same terminal. Press Ctrl+C to stop both processes.

---

## Architecture: Data Services

### Service Interface (Contract)

Define what operations your app needs:

```typescript
// src/services/types.ts
export interface Item {
  id: string;
  name: string;
  description: string;
  createdDate: Date;
  status: 'active' | 'inactive';
}

export interface GetItemsParams {
  skip?: number;
  top?: number;
  sortBy?: keyof Item;
  sortDescending?: boolean;
  filter?: string;
}

export interface GetItemsResponse {
  items: Item[];
  totalCount: number;
}

export interface IDataService {
  // Query operations
  getItems(params: GetItemsParams): Promise<GetItemsResponse>;
  getItem(id: string): Promise<Item>;

  // Mutation operations
  createItem(item: Omit<Item, 'id' | 'createdDate'>): Promise<Item>;
  updateItem(id: string, item: Partial<Item>): Promise<Item>;
  deleteItem(id: string): Promise<void>;
}
```

### Mock Service (Start Here)

Implement for local development:

```typescript
// src/services/MockDataService.ts
import {
  IDataService,
  Item,
  GetItemsParams,
  GetItemsResponse
} from './types'

export class MockDataService implements IDataService {
  private items: Item[] = [
    {
      id: '1',
      name: 'Sample Item 1',
      description: 'A sample item for testing',
      createdDate: new Date('2024-01-01'),
      status: 'active'
    },
    {
      id: '2',
      name: 'Sample Item 2',
      description: 'Another sample item',
      createdDate: new Date('2024-01-02'),
      status: 'active'
    }
  ];

  async getItems(params: GetItemsParams): Promise<GetItemsResponse> {
    // Simulate server-side sorting and pagination
    let filtered = [...this.items];

    // Apply filter
    if (params.filter) {
      const lowerFilter = params.filter.toLowerCase();
      filtered = filtered.filter(item =>
        item.name.toLowerCase().includes(lowerFilter) ||
        item.description.toLowerCase().includes(lowerFilter)
      );
    }

    // Apply sorting
    if (params.sortBy) {
      filtered.sort((a, b) => {
        const aVal = a[params.sortBy!];
        const bVal = b[params.sortBy!];

        if (aVal < bVal) return params.sortDescending ? 1 : -1;
        if (aVal > bVal) return params.sortDescending ? -1 : 1;
        return 0;
      });
    }

    // Apply pagination
    const skip = params.skip || 0;
    const top = params.top || 10;
    const paged = filtered.slice(skip, skip + top);

    // Simulate network delay
    await new Promise(resolve => setTimeout(resolve, 300));

    return {
      items: paged,
      totalCount: filtered.length
    };
  }

  async getItem(id: string): Promise<Item> {
    const item = this.items.find(i => i.id === id);
    if (!item) throw new Error(`Item ${id} not found`);
    await new Promise(resolve => setTimeout(resolve, 200));
    return item;
  }

  async createItem(item: Omit<Item, 'id' | 'createdDate'>): Promise<Item> {
    const newItem: Item = {
      ...item,
      id: `${Date.now()}`,
      createdDate: new Date()
    };
    this.items.push(newItem);
    await new Promise(resolve => setTimeout(resolve, 300));
    return newItem;
  }

  async updateItem(id: string, updates: Partial<Item>): Promise<Item> {
    const item = this.items.find(i => i.id === id);
    if (!item) throw new Error(`Item ${id} not found`);
    Object.assign(item, updates);
    await new Promise(resolve => setTimeout(resolve, 300));
    return item;
  }

  async deleteItem(id: string): Promise<void> {
    this.items = this.items.filter(i => i.id !== id);
    await new Promise(resolve => setTimeout(resolve, 300));
  }
}
```

### Real Service (Implement Later)

```typescript
// src/services/RealDataService.ts
import {
  IDataService,
  Item,
  GetItemsParams,
  GetItemsResponse
} from './types'

export class RealDataService implements IDataService {
  // Will be implemented after mock service works
  // Uses Power Apps SDK and generated service classes

  async getItems(params: GetItemsParams): Promise<GetItemsResponse> {
    // TODO: Call actual data source
    throw new Error('Not implemented');
  }

  async getItem(id: string): Promise<Item> {
    // TODO: Call actual data source
    throw new Error('Not implemented');
  }

  async createItem(item: Omit<Item, 'id' | 'createdDate'>): Promise<Item> {
    // TODO: Call actual data source
    throw new Error('Not implemented');
  }

  async updateItem(id: string, updates: Partial<Item>): Promise<Item> {
    // TODO: Call actual data source
    throw new Error('Not implemented');
  }

  async deleteItem(id: string): Promise<void> {
    // TODO: Call actual data source
    throw new Error('Not implemented');
  }
}
```

### Service Factory (Runtime Selection)

```typescript
// src/services/ServiceFactory.ts
import { IDataService } from './types'
import { MockDataService } from './MockDataService'
import { RealDataService } from './RealDataService'

export class ServiceFactory {
  private static instances: Map<boolean, IDataService> = new Map();

  static create(useMock: boolean = true): IDataService {
    // Check if instance already exists for this configuration
    if (this.instances.has(useMock)) {
      return this.instances.get(useMock)!;
    }

    // Create appropriate service based on useMock flag
    const instance = useMock
      ? new MockDataService()
      : new RealDataService();

    // Cache the instance
    this.instances.set(useMock, instance);
    return instance;
  }

  static reset(): void {
    this.instances.clear();
  }

  static resetMock(): void {
    this.instances.delete(true);
  }

  static resetReal(): void {
    this.instances.delete(false);
  }
}
```

---

## Components: DataGrid with Server-Side Operations

### ItemsGrid Component

```typescript
// src/components/ItemsGrid.tsx
import {
  DataGridBody,
  DataGridRow,
  DataGrid,
  DataGridHeader,
  DataGridHeaderCell,
  DataGridCell,
  Button,
  Skeleton,
} from '@fluentui/react-components'
import { useEffect, useState, useMemo } from 'react'
import { IDataService, Item, GetItemsResponse } from '../services/types'
import './ItemsGrid.css'

interface ItemsGridProps {
  service: IDataService;
}

export const ItemsGrid = ({ service }: ItemsGridProps) => {
  const [data, setData] = useState<GetItemsResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [sortBy, setSortBy] = useState<keyof Item>('createdDate');
  const [sortDescending, setSortDescending] = useState(true);
  const [skip, setSkip] = useState(0);
  const [filter, setFilter] = useState('');

  // Fetch data when parameters change
  useEffect(() => {
    const fetchItems = async () => {
      setLoading(true);
      try {
        const response = await service.getItems({
          skip,
          top: 10,
          sortBy,
          sortDescending,
          filter: filter || undefined
        });
        setData(response);
      } catch (error) {
        console.error('Error loading items:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchItems();
  }, [service, skip, sortBy, sortDescending, filter]);

  // Column definitions
  const columns = useMemo(() => [
    { columnId: 'name', label: 'Name' },
    { columnId: 'description', label: 'Description' },
    { columnId: 'status', label: 'Status' },
    { columnId: 'createdDate', label: 'Created' },
    { columnId: 'actions', label: 'Actions' },
  ], []);

  const handleSort = (columnId: string) => {
    if (sortBy === columnId) {
      setSortDescending(!sortDescending);
    } else {
      setSortBy(columnId as keyof Item);
      setSortDescending(true);
    }
    // Reset to page 1 on sort change
    setSkip(0);
  };

  if (loading && !data) {
    return <Skeleton height={200} />;
  }

  return (
    <div className="items-grid">
      <DataGrid items={data?.items || []} columns={columns}>
        <DataGridHeader>
          <DataGridRow>
            {columns.map(col => (
              <DataGridHeaderCell
                key={col.columnId}
                onClick={() => col.columnId !== 'actions' && handleSort(col.columnId)}
                aria-sort={
                  sortBy === col.columnId
                    ? sortDescending ? 'descending' : 'ascending'
                    : 'none'
                }
              >
                {col.label}
              </DataGridHeaderCell>
            ))}
          </DataGridRow>
        </DataGridHeader>
        <DataGridBody>
          {(data?.items || []).map((item, idx) => (
            <DataGridRow key={idx} data-testid={`row-${item.id}`}>
              <DataGridCell>{item.name}</DataGridCell>
              <DataGridCell>{item.description}</DataGridCell>
              <DataGridCell>{item.status}</DataGridCell>
              <DataGridCell>
                {new Date(item.createdDate).toLocaleDateString()}
              </DataGridCell>
              <DataGridCell>
                <Button size="small" appearance="subtle">
                  Edit
                </Button>
              </DataGridCell>
            </DataGridRow>
          ))}
        </DataGridBody>
      </DataGrid>

      {/* Pagination */}
      <div className="pagination">
        <Button
          disabled={skip === 0}
          onClick={() => setSkip(Math.max(0, skip - 10))}
        >
          Previous
        </Button>
        <span>Page {Math.floor(skip / 10) + 1} of {Math.ceil((data?.totalCount || 0) / 10)}</span>
        <Button
          disabled={!data || skip + 10 >= data.totalCount}
          onClick={() => setSkip(skip + 10)}
        >
          Next
        </Button>
      </div>
    </div>
  );
};
```

### ItemsGrid Styling

```css
/* src/components/ItemsGrid.css */
.items-grid {
  padding: 16px;
}

.pagination {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-top: 16px;
  justify-content: center;
}
```

---

## Best Practices Checklist

### Development Phase
- ✅ Use mock data exclusively during development
- ✅ Define all data service interfaces before implementation
- ✅ Test all features with mocked responses
- ✅ Verify responsive design on mobile devices
- ✅ Check accessibility with screen reader
- ✅ Profile performance before optimization

### Code Quality
- ✅ Strict TypeScript mode enabled
- ✅ No hardcoded environment values
- ✅ Proper error handling in all async operations
- ✅ ARIA labels on interactive elements
- ✅ Keyboard navigation support
- ✅ Loading states for all data operations

### Testing
- ✅ Unit tests for services and utilities
- ✅ Integration tests with mock data
- ✅ E2E tests after Power Apps integration
- ✅ Responsive design testing
- ✅ Accessibility audit (WCAG 2.1 AA)

### Deployment
- ✅ Build succeeds with no errors
- ✅ All features tested with mock data
- ✅ Environment variables configured
- ✅ Power Platform environment ready
- ✅ Data sources and connections ready
- ✅ Initial deployment verified

---

## Troubleshooting

### Port 3000 Already in Use
```bash
# Kill process using port 3000
npx kill-port 3000
# Or specify different port in vite.config.ts
```

### PowerProvider Issues
- Ensure PowerProvider wraps the entire app
- Check that @pa-client/power-code-sdk is installed
- Verify tsconfig.app.json has `verbatimModuleSyntax: false`

### Build Errors
- Run `npm run build` locally before deploying
- Check TypeScript compilation errors
- Ensure all imports are correct
- Verify Fluent UI components are imported correctly

### Data Not Loading
- Check that service implementation is complete
- Verify mock data is returned correctly
- Check browser console for errors
- Verify async/await syntax

---

## Advanced Topics

### Custom Hooks

```typescript
// src/hooks/useItems.ts
import { useState, useEffect } from 'react'
import { IDataService, Item, GetItemsResponse } from '../services/types'

export const useItems = (service: IDataService) => {
  const [data, setData] = useState<GetItemsResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  const refresh = async (params = {}) => {
    setLoading(true);
    setError(null);
    try {
      const response = await service.getItems(params);
      setData(response);
    } catch (err) {
      setError(err as Error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    refresh();
  }, [service]);

  return { data, loading, error, refresh };
};
```

### Theme Management

```typescript
// src/hooks/useTheme.ts
import { useState } from 'react'
import { webLightTheme, webDarkTheme } from '@fluentui/react-components'

export const useTheme = () => {
  const [isDark, setIsDark] = useState(false);

  return {
    theme: isDark ? webDarkTheme : webLightTheme,
    isDark,
    toggle: () => setIsDark(!isDark)
  };
};
```

---

## Resources

- [Power Apps Code Apps Docs](https://learn.microsoft.com/en-us/power-apps/developer/component-framework/code-app-tutorial)
- [React 18 Docs](https://react.dev)
- [Fluent UI v9 Docs](https://react.fluentui.dev/)
- [Vite Docs](https://vitejs.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [WCAG Accessibility](https://www.w3.org/WAI/WCAG21/quickref/)

---

**Last Updated**: November 2025
**Status**: Comprehensive guide for Power Apps Code Apps development
