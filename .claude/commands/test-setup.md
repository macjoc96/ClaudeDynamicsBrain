---
description: Configure testing environment with test data setup, unit test framework configuration, and integration test guidelines for Dynamics development
argument-hint: [TestType] - unit, integration, e2e
allowed-tools: Write, Bash
---

Setup testing infrastructure with the following components:

## Task
Configure comprehensive testing environment:
- Test framework setup (MSTest, Jest, Mocha)
- Test data generation
- Mock service configuration
- Test database setup
- Unit test project structure
- Integration test configuration
- E2E test automation
- Test runner configuration
- Coverage reporting setup
- CI/CD integration

## Test Types Available
- **unit**: Unit test framework and patterns
- **integration**: Integration test with Dynamics
- **e2e**: End-to-end testing automation
- **performance**: Performance and load testing

## Parameters
- Test Type: $1 (default: unit)
- Framework: $2 (MSTest, Jest, Mocha - framework-specific)
- Target Project: $3 (project name)

## Setup Components
1. Test project creation
2. Dependencies and NuGet packages
3. Mock frameworks configuration
4. Test data factories
5. Assertion libraries
6. Test runner setup
7. Code coverage tools
8. Reporting configuration
9. CI/CD pipeline integration
10. Test environment variables

## Test Patterns Included
- Arrange-Act-Assert pattern
- AAA testing methodology
- Data-driven tests
- Fixture setup/teardown
- Test isolation
- Mock organization service
- Mock entity operations
- Error scenario testing

## Output
Provide:
1. Project structure
2. NuGet/npm package list
3. Configuration files
4. Sample test cases
5. Mock setup examples
6. Test data factory patterns
7. CI/CD integration guide
8. Test execution instructions
9. Coverage goals
10. Best practices guide

Ready for test development and execution.
