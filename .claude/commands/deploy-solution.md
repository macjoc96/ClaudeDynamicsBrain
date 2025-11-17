---
description: Guide and execute Dynamics solution deployment with pre-deployment checks, staged rollout, and post-deployment validation
argument-hint: [SolutionFile] [TargetEnvironment]
allowed-tools: Bash, Read, Write
---

Guide through solution deployment with the following process:

## Task
Execute solution deployment with:
- Pre-deployment validation
- Environment readiness check
- Backup creation guidance
- Staged deployment process
- Installation tracking
- Post-deployment verification
- Rollback readiness confirmation
- Health check execution
- User communication

## Parameters
- Solution File: $1 (path to solution file)
- Target Environment: $2 (dev, test, staging, production)
- Deployment Type: $3 (new, upgrade, patch - default: auto-detect)

## Pre-Deployment Checks
1. Solution integrity validation
2. Target environment health check
3. Dependency availability
4. Required customizations present
5. Security permissions verified
6. Rollback plan documented

## Deployment Process
1. Create backup
2. Stage solution
3. Execute installation
4. Monitor progress
5. Verify installation
6. Test functionality
7. Confirm success or rollback

## Post-Deployment Steps
1. Run health checks
2. Verify all components
3. Test critical workflows
4. Check user access
5. Monitor performance
6. Document results
7. Communicate to users

## Output
Provide:
1. Pre-deployment checklist
2. Deployment plan
3. Step-by-step instructions
4. Troubleshooting guide
5. Rollback procedures
6. Post-deployment validation plan
7. Communication templates
8. Success/failure criteria

Ready for deployment execution.
