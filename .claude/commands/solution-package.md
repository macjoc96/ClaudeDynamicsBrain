---
description: Prepare and package a Dynamics solution for deployment with version management, dependency validation, and release note generation
argument-hint: [SolutionName] [Version]
allowed-tools: Write, Bash, Read, Grep
---

Prepare a Dynamics solution for deployment with the following process:

## Task
Guide through solution packaging with:
- Solution validation
- Component inventory
- Dependency mapping and validation
- Version update
- Export preparation
- Managed solution generation
- Release notes generation
- Deployment checklist creation
- Rollback plan documentation

## Parameters
- Solution Name: $1 (e.g., "MySolution")
- Version: $2 (semantic versioning, e.g., "1.2.3")
- Include Managed Export: $3 (yes/no, default: yes)

## Validation Steps
1. All components present
2. All dependencies resolved
3. No circular dependencies
4. Version format correct
5. Change log updated
6. Release notes complete

## Output
Provide:
1. Solution validation report
2. Component inventory
3. Dependency graph
4. Version update guidance
5. Export instructions
6. Release notes template
7. Deployment checklist
8. Rollback procedures
9. Communication template

Ready for deployment to target environment.
