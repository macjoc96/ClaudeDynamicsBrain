# Contributing to Claude Dynamics Brain

Welcome! This guide explains how to contribute to Claude Dynamics Brain in a way that maintains quality, security, and team standards.

## Code of Conduct

- **Respect** team members and their time
- **Share** knowledge openly and generously
- **Communicate** clearly and proactively
- **Focus** on quality and long-term sustainability
- **Report** issues constructively

---

## Getting Started

### 1. Setup Your Development Environment

Before contributing, ensure your setup is complete:

```bash
# Windows (PowerShell)
.\setup\validate-setup.ps1

# Linux/macOS (Bash)
./setup/validate-setup.sh
```

**Expected output**: ✅ Setup Status: READY

If you see warnings or errors, follow the remediation steps in `SETUP_INSTRUCTIONS.md`.

### 2. Review Relevant Documentation

- **General**: `CLAUDE.md` - Project overview
- **Setup**: `SETUP_INSTRUCTIONS.md` - Detailed setup guide
- **Configuration**: `docs/08-configuration-guide.md` - How to configure your environment
- **Security**: `docs/05-security-guidelines.md` - Security requirements
- **Your area**: Relevant development guide for your focus (plugins, flows, etc.)

### 3. Choose Your Task

- Browse **GitHub Issues** for available work
- **Discuss** complex or architectural changes with the team first
- **Create a branch** for your work (see [Branch Naming](#branch-naming) below)

---

## Development Standards

### C# Plugins

**Code Quality**:
- Follow [Microsoft C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- Use meaningful variable and method names
- Keep methods focused and under 100 lines
- Write XML documentation for public methods

**Documentation**:
```csharp
/// <summary>
/// Validates the account record for required fields.
/// </summary>
/// <param name="account">The account entity to validate</param>
/// <returns>True if valid, false otherwise</returns>
public bool ValidateAccount(Entity account)
{
    // Implementation
}
```

**Testing**:
- Minimum 80% code coverage
- Test happy path + error cases
- Use MSTest framework
- Mock external dependencies

**Security**:
- Validate all inputs in plugin context
- Never trust user data
- Use organization service via execution context
- Never hardcode credentials
- Check permissions before operations

**Performance**:
- Load plugins in < 100ms normally
- Handle 1000+ records efficiently
- Use batch operations when processing multiple records
- Cache reference data

**Before PR**:
- Run `/security-scan`
- Verify tests pass
- Check for hardcoded values

---

### TypeScript/JavaScript

**Code Quality**:
- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use strict mode
- No `any` types (use proper types)
- Use `const` by default, `let` when needed, never `var`

**Type Safety**:
```typescript
// ✓ GOOD - Types are explicit
const getUser = (id: number): Promise<User> => {
  return fetch(`/api/users/${id}`).then(r => r.json());
};

// ✗ BAD - Using any
const getUser = (id: any): any => {
  return fetch(`/api/users/${id}`);
};
```

**Comments**:
- Add JSDoc comments to functions
- Explain WHY, not WHAT (code shows what)
- Keep comments accurate as code changes

```typescript
/**
 * Transforms raw API response into application format.
 * @param response - Raw response from Dynamics API
 * @returns Formatted user object
 */
const transformUser = (response: any): User => {
  // Implementation
};
```

**Testing**:
- Jest framework
- Minimum 80% coverage
- Test happy path + error cases
- Mock API calls and external services

**Security**:
- Validate all user inputs
- Prevent XSS attacks (sanitize HTML)
- Prevent injection attacks
- Never log sensitive data
- Use HTTPS for API calls

**Before PR**:
- Run `npm test`
- Run `npm run lint`
- Verify tests pass
- Build successfully: `npm run build`

---

### Power Automate Flows

**Design**:
- Document all actions with descriptive names
- Use meaningful variable names (avoid generic names like "var1")
- Include comments for complex logic
- Use compose actions for complex transformations

**Error Handling**:
- Implement try-catch-finally patterns
- Log errors for debugging
- Return helpful error messages
- Don't fail silently

**Performance**:
- Minimize API calls
- Use batch operations for multiple records
- Cache lookups when possible
- Set appropriate timeouts

**Testing**:
- Test with sample data
- Verify error paths
- Test with large datasets
- Document test steps

**Before Submission**:
- Export flow as `.json`
- Include test data examples
- Document trigger conditions
- List required permissions/connections

---

### Documentation

**Principles**:
- Use clear, simple language
- Write for someone unfamiliar with the topic
- Include examples and screenshots
- Link to related documentation
- Keep documentation current with code

**Formatting**:
- Use headers for hierarchy
- Use bullet points for lists
- Use code blocks for technical content
- Use tables for comparisons
- Include table of contents for long docs

**Example Documentation**:
```markdown
## How to Create a Plugin

### Prerequisites
- .NET SDK installed
- Dynamics SDK downloaded

### Steps
1. Create a new class library project
2. Add reference to Dynamics SDK
3. Implement IPlugin interface
4. [See 02-plugin-development.md for details]
```

---

## Workflow

### Branch Naming

Format: `[type]/[description]`

```bash
# New feature
git checkout -b feature/add-user-validation

# Bug fix
git checkout -b fix/duplicate-record-issue

# Documentation
git checkout -b docs/update-setup-guide

# Code refactoring
git checkout -b refactor/optimize-queries

# Testing
git checkout -b test/add-plugin-tests

# Performance
git checkout -b perf/implement-caching
```

### Commit Messages

**Format**: `[TYPE] Brief description`

**Types**:
- `[FEAT]` - New feature
- `[FIX]` - Bug fix
- `[DOCS]` - Documentation
- `[REFACTOR]` - Code improvement without feature change
- `[TEST]` - Test additions/improvements
- `[PERF]` - Performance optimization

**Rules**:
- Use imperative mood: "Add" not "Added"
- First line < 50 characters
- Add detailed explanation in body if needed
- Reference issue: "Fixes #123"

**Examples**:
```bash
# Good
git commit -m "[FEAT] Add account validation plugin

This plugin validates required fields on account records.
Includes unit tests for validation logic.
Fixes #42"

# Good
git commit -m "[FIX] Resolve duplicate record creation

Prevent race condition in async record creation.
Add mutex lock to serialization."

# Avoid
git commit -m "Update code"  # Too vague
git commit -m "Added new validation"  # Past tense
```

### Pull Requests

#### Before Creating PR

**Code Quality Checklist**:
- [ ] Code follows style guide
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Security scan passes (`/security-scan`)
- [ ] Code builds successfully
- [ ] No console errors
- [ ] No hardcoded values

**Test Checklist**:
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Tested with sample data
- [ ] Tested error scenarios

**Documentation Checklist**:
- [ ] Code comments added
- [ ] Related docs updated
- [ ] README updated if needed
- [ ] Examples included

#### PR Description Template

```markdown
## What does this PR do?
Brief description of changes.

## Why?
Why is this change needed? What problem does it solve?

## How to test?
Step-by-step instructions:
1. Create test account with X
2. Run Y action
3. Verify Z happens

## Related Issues
Fixes #123
Related to #456

## Screenshots (if applicable)
[Add before/after screenshots]

## Checklist
- [ ] Code review ready
- [ ] Tests pass (at least 80% coverage)
- [ ] Docs updated
- [ ] Security verified
- [ ] No breaking changes
```

#### Review Process

1. **Automated Checks**:
   - Build passes
   - Tests pass
   - Linting passes
   - Security scan passes

2. **Code Review**:
   - At least 1 approval required
   - Security-sensitive changes: 2 approvals
   - All feedback must be addressed
   - Reviewer validates final code

3. **Review SLA**:
   - Standard PRs: 24 hours
   - Urgent/Hot-fix: 4 hours
   - Security reviews: 48 hours

4. **Merging**:
   - Squash commits for clean history
   - Delete branch after merge
   - Verify deployment if applicable

---

## Code Review Guidelines

### As Reviewer

**Check**:
- Code quality and standards compliance
- Tests are adequate (80%+ coverage)
- Security issues or vulnerabilities
- Documentation is updated
- No breaking changes without discussion

**Provide Feedback**:
- Be constructive and respectful
- Suggest improvements
- Ask questions if unclear
- Approve when satisfied

**Remember**:
- Reviews complete within SLA
- Assume good intent
- Focus on code, not person
- Celebrate good solutions

### As Author

**Receive Feedback**:
- Don't take criticism personally
- Ask clarifying questions
- Implement suggestions or discuss alternatives
- Thank reviewers for their time

---

## Testing Requirements

### Unit Tests

- Minimum 80% coverage
- Test happy path
- Test error cases
- Test boundary conditions
- Mock external dependencies

**Example**:
```typescript
describe('validateAccount', () => {
  it('returns true for valid account', () => {
    const account = { name: 'ACME', accountNumber: '12345' };
    expect(validateAccount(account)).toBe(true);
  });

  it('returns false when name is missing', () => {
    const account = { accountNumber: '12345' };
    expect(validateAccount(account)).toBe(false);
  });
});
```

### Integration Tests

- Test against test environment
- Verify Dynamics connectivity
- Test data operations (create, read, update, delete)
- Test error handling

### Security Tests

- Run `/security-scan`
- Check for input validation
- Verify error messages don't leak info
- Test permission checks

---

## Documentation Requirements

### Code Comments

**DO**:
- Explain complex logic
- Document edge cases
- Add WHY, not WHAT
- Keep comments accurate
- Remove obsolete comments

**DON'T**:
- Comment obvious code
- Leave outdated comments
- Over-comment simple logic
- Comment bad code (refactor instead)

### External Documentation

**Update when**:
- Behavior changes
- New features added
- API changes
- Architecture changes

**Include**:
- Examples for new features
- Architecture diagrams if relevant
- Troubleshooting guides
- Links to related topics

---

## Performance Standards

### Plugins

- Load < 100ms normally
- Handle 1000+ records efficiently
- Use batch operations
- Cache reference data
- Profile code before optimizing

### Cloud Flows

- Complete within timeout limits
- Minimize API calls
- Handle errors gracefully
- Log issues for debugging
- Monitor execution time

### Web Components

- Initial load < 2 seconds
- Render responsively
- Minimize re-renders
- Optimize image sizes
- Cache when appropriate

---

## Security Standards

### No Hardcoded Secrets

❌ **WRONG**:
```csharp
string password = "myPassword123";
var client = new OrganizationServiceClient(uri, cred);
```

✅ **RIGHT**:
```csharp
string password = Environment.GetEnvironmentVariable("DYNAMICS_PASSWORD");
var client = new OrganizationServiceClient(uri, cred);
```

### Input Validation

❌ **WRONG**:
```typescript
const user = getUserInput();
database.insert(user);  // No validation!
```

✅ **RIGHT**:
```typescript
const user = getUserInput();
if (!isValidUser(user)) {
  throw new Error('Invalid user data');
}
database.insert(user);
```

### Error Handling

❌ **WRONG**:
```csharp
catch (Exception ex) {
    throw new Exception($"Database error: {ex.Message}");
    // Exposing internal details!
}
```

✅ **RIGHT**:
```csharp
catch (Exception ex) {
    Logger.Error($"Database error: {ex.Message}");
    throw new Exception("An error occurred processing your request");
    // Generic message, internal details logged
}
```

### More Security Info

See `docs/05-security-guidelines.md` for comprehensive security requirements.

---

## Getting Help

### Questions?
- Check relevant documentation
- Search past issues/PRs
- Ask in team chat
- Create discussion issue

### Reporting Bugs

1. **Describe** the issue clearly
2. **Include** reproduction steps
3. **Show** expected vs actual behavior
4. **Provide** environment details
5. **Attach** related code/logs

**Example**:
```markdown
## Bug: Validation plugin fails with large datasets

### Steps to Reproduce
1. Create account with 500+ contacts
2. Run bulk validation
3. Plugin times out

### Expected
Validation completes in < 5 seconds

### Actual
Plugin times out after 30 seconds

### Environment
- Dynamics SDK v9.2
- Plugin isolation: Sandbox
- Records: 2000+

### Logs
[Paste error from trace]
```

---

## Versioning

Follow **Semantic Versioning**: `MAJOR.MINOR.PATCH`

- **Major**: Breaking changes (1.0.0 → 2.0.0)
- **Minor**: New features, backward compatible (1.0.0 → 1.1.0)
- **Patch**: Bug fixes (1.0.0 → 1.0.1)

**Release Tags**:
```bash
git tag v1.0.0
git push --tags
```

---

## Release Process

1. Update version numbers
2. Update `CHANGELOG.md`
3. Create release notes
4. Tag release: `git tag v1.0.0`
5. Push to repository
6. Verify deployment
7. Communicate changes to team

---

## Team Workflow

### Daily Standup
- 10:00 AM (your timezone)
- 15 minutes
- Share: Done, Doing, Blocked

### Code Review SLA
- Standard PRs: 24 hours
- Urgent/Hot-fix: 4 hours
- Security reviews: 48 hours

### Release Schedule
- Weekly releases: Friday 2 PM
- Monthly major releases: First Friday
- Hot fixes: As needed

---

## Recognition & Celebration

We celebrate contributions! When you:
- Submit your first PR ✨
- Complete a complex feature 🎉
- Help multiple team members 🌟
- Improve documentation 📚
- Fix a critical bug 🐛

We recognize your effort publicly and appreciate your work!

---

## Next Steps

1. **Setup**: Run validation scripts
2. **Review**: Read relevant documentation
3. **Connect**: Ask questions in team chat
4. **Contribute**: Pick an issue and create a branch
5. **Submit**: Create PR with clear description
6. **Iterate**: Respond to feedback
7. **Celebrate**: Your PR is merged!

---

## Resources

- **Getting Started**: `SETUP_INSTRUCTIONS.md`
- **Configuration**: `docs/08-configuration-guide.md`
- **Security**: `docs/05-security-guidelines.md`
- **Plugin Dev**: `docs/02-plugin-development.md`
- **All Docs**: `docs/` directory

---

## Questions?

If anything is unclear:
1. Check this document again
2. Review relevant documentation
3. Ask team lead or mentor
4. Create discussion in GitHub Issues

**Thank you for contributing to Claude Dynamics Brain!** 🚀

---

**Last Updated**: November 16, 2025
**Version**: 1.0
**Maintained By**: Claude Dynamics Brain Team
