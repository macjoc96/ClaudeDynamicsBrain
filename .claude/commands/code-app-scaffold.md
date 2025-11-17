---
description: Scaffold a new Power Apps Code App project with React, Vite, TypeScript, Fluent UI, and Power Platform SDK pre-configured
argument-hint: [AppName]
allowed-tools: Bash, Write, Read
---

Create a complete Power Apps Code App project scaffold with all necessary configurations:

## Task
Generate a new Power Apps Code App with:
- Vite + React 18 + TypeScript setup
- Power Platform SDK integration
- Fluent UI v9 components and theming
- PowerProvider configuration
- Mock data service architecture
- Sample DataGrid component
- Responsive design setup
- Accessibility defaults
- Development scripts for Windows and macOS
- Environment configuration

## App Details
- App Name: $ARGUMENTS (e.g., "MyDynamicsCodeApp")
- Default Port: 3000 (required for Power Apps)
- Build Tool: Vite
- UI Framework: Fluent UI v9
- Type Safety: TypeScript strict mode
- Target: Power Apps native environment

## Generated Structure
```
my-code-app/
├── src/
│   ├── components/
│   │   ├── ItemsGrid.tsx
│   │   └── ItemsGrid.css
│   ├── services/
│   │   ├── types.ts
│   │   ├── MockDataService.ts
│   │   ├── RealDataService.ts
│   │   └── ServiceFactory.ts
│   ├── hooks/
│   │   └── useItems.ts
│   ├── PowerProvider.tsx
│   ├── App.tsx
│   ├── App.css
│   ├── main.tsx
│   └── index.css
├── vite.config.ts
├── tsconfig.json
├── tsconfig.app.json
├── package.json
├── .env.example
└── README.md
```

## Configuration Includes
1. **Vite Config**
   - Base path set to "./"
   - Host set to "::"
   - Port 3000 (required)
   - Path alias @ for src/

2. **TypeScript**
   - React 18 support
   - Strict mode enabled
   - verbatimModuleSyntax: false (for Power SDK)
   - Full type safety

3. **Power Platform SDK**
   - PowerProvider setup
   - Power Apps context integration
   - Ready for connections

4. **Fluent UI v9**
   - FluentProvider with themes
   - Design tokens
   - DataGrid component example
   - Light/dark theme support

5. **Data Architecture**
   - Service interface pattern
   - Mock service implementation
   - Real service stub
   - Service factory for runtime selection
   - Type-safe parameters and responses

6. **Accessibility**
   - ARIA labels on interactive elements
   - Keyboard navigation support
   - Semantic HTML structure
   - WCAG 2.1 AA compliance

## Output
Complete, ready-to-develop Power Apps Code App with:
- All dependencies configured
- Development server scripts (Windows & macOS)
- Mock data pre-populated
- Sample components with DataGrid
- Professional folder structure
- Comprehensive README with next steps

## Next Steps
1. `cd my-code-app`
2. `npm install`
3. `npm run dev`
4. Open http://localhost:3000
5. Modify mock data in `src/services/MockDataService.ts`
6. Build components in `src/components/`
7. When ready: configure Power Platform environment
