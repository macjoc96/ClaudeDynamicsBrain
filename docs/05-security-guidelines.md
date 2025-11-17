# Security Guidelines for Dynamics 365 Development

This guide provides security best practices for developing Dynamics 365 solutions, plugins, and integrations.

## Security Principles

### 1. Principle of Least Privilege

Grant minimum permissions required:

```csharp
// Instead of admin context
var context = factory.CreateOrganizationService(null); // Admin

// Use specific user context
var context = factory.CreateOrganizationService(specificUserId);
```

### 2. Defense in Depth

Implement multiple security layers:
- Input validation
- Output encoding
- Authorization checks
- Encryption
- Logging

### 3. Secure by Default

- Default to deny access
- Whitelist allowed values
- Validate all inputs
- Sanitize all outputs

## Input Validation

### Always Validate User Input

```csharp
// ❌ BAD: No validation
var userName = context.InputParameters["name"].ToString();
service.Update(new Entity("contact") { ["name"] = userName });

// ✅ GOOD: Validate and sanitize
var userName = context.InputParameters["name"]?.ToString();

if (string.IsNullOrWhiteSpace(userName))
    throw new InvalidPluginExecutionException("Name is required");

if (userName.Length > 100)
    throw new InvalidPluginExecutionException("Name too long");

// Remove dangerous characters
userName = System.Text.RegularExpressions.Regex.Replace(
    userName, @"[^a-zA-Z0-9\s-]", "");

service.Update(new Entity("contact") { ["name"] = userName });
```

### Validate Entity References

```csharp
// ❌ BAD: No validation
var reference = (EntityReference)context.InputParameters["target"];
var entity = service.Retrieve(reference.LogicalName, reference.Id, new ColumnSet(true));

// ✅ GOOD: Validate reference
var reference = context.InputParameters["target"] as EntityReference;

if (reference == null)
    throw new InvalidPluginExecutionException("Target is required");

var allowedEntities = new[] { "account", "contact" };
if (!allowedEntities.Contains(reference.LogicalName))
    throw new InvalidPluginExecutionException("Invalid entity type");

if (reference.Id == Guid.Empty)
    throw new InvalidPluginExecutionException("Invalid record ID");

var entity = service.Retrieve(reference.LogicalName, reference.Id,
    new ColumnSet("name", "email")); // Specific columns only
```

## Authentication & Authorization

### Never Hardcode Credentials

```csharp
// ❌ BAD: Hardcoded password
var crmConnection = new CrmServiceClient(
    "AuthType=Office365;Url=https://org.crm.dynamics.com;Username=user@org.onmicrosoft.com;Password=P@ssword");

// ✅ GOOD: Use service principal or managed identity
var crmConnection = new CrmServiceClient(
    "AuthType=ClientSecret;Url=https://org.crm.dynamics.com;ClientId=xxx;ClientSecret=yyy");
```

### Implement Role-Based Access Control

```csharp
// Check user role
var userRoles = GetUserRoles(service, context.UserId);

if (!userRoles.Contains("Manager"))
    throw new InvalidPluginExecutionException(
        "Only managers can perform this action");

// Query only accessible records
var query = new QueryExpression("account")
{
    ColumnSet = new ColumnSet("name")
};

// Add business unit filter
var businessUnit = service.Retrieve("systemuser", context.UserId,
    new ColumnSet("businessunitid"));

query.Criteria.AddCondition("businessunitid",
    ConditionOperator.Equal, businessUnit.Id);
```

## Data Protection

### Encrypt Sensitive Data

```csharp
// Use configuration for sensitive values
var config = GetSecureConfig(service, "APIKey");

// Never store in plain text
// ❌ BAD
entity["api_key"] = "secret-key-here";

// ✅ GOOD - Use Azure Key Vault or secure storage
var encryptedKey = EncryptUsingKeyVault("secret-key-here");
entity["api_key_encrypted"] = encryptedKey;
```

### Handle Sensitive Information

```csharp
// Don't log sensitive data
// ❌ BAD
tracing.Trace($"User password: {password}");

// ✅ GOOD
tracing.Trace($"User authentication attempt");
tracing.Trace($"Password length: {password?.Length ?? 0}");

// Filter PII from error messages
var errorMessage = ex.Message
    .Replace(email, "***")
    .Replace(phoneNumber, "***");

throw new InvalidPluginExecutionException(errorMessage);
```

## SQL Injection Prevention

### Always Use Parameterized Queries

```csharp
// ❌ BAD: Vulnerable to SQL injection
var fetchXml = $@"
    <fetch>
        <entity name='contact'>
            <filter>
                <condition attribute='firstname' operator='eq' value='{firstName}' />
            </filter>
        </entity>
    </fetch>";

// ✅ GOOD: Use FetchXML directly without string concatenation
var query = new QueryExpression("contact")
{
    ColumnSet = new ColumnSet("firstname")
};
query.Criteria.AddCondition("firstname", ConditionOperator.Equal, firstName);
```

## Cross-Site Scripting (XSS) Prevention

### Encode Output in Web Resources

```javascript
// ❌ BAD: Vulnerable to XSS
document.getElementById("name").innerHTML = userName;

// ✅ GOOD: Escape HTML
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, m => map[m]);
}

document.getElementById("name").textContent = escapeHtml(userName);
```

## API Security

### Validate API Calls

```csharp
// Validate API request
var request = JsonConvert.DeserializeObject<ApiRequest>(body);

if (request == null || string.IsNullOrEmpty(request.EntityName))
    return BadRequest("Invalid request");

// Whitelist entities
var allowedEntities = new[] { "account", "contact", "lead" };
if (!allowedEntities.Contains(request.EntityName))
    return Forbidden("Entity not allowed");

// Validate user has access
if (!UserCanAccess(context.UserId, request.EntityName))
    return Unauthorized("No access to this entity");
```

### CORS Configuration

```csharp
// ✅ GOOD: Restrict CORS to specific origins
app.UseCors(builder =>
    builder
        .WithOrigins("https://yourdomain.com")
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials());

// ❌ BAD: Allow all origins
app.UseCors(builder => builder.AllowAnyOrigin().AllowAnyMethod());
```

## Secrets Management

### Never Commit Secrets

Create `.gitignore` file:

```
# Secrets
*.secrets.json
*.local.json
appsettings.local.json
.env
.env.local

# API Keys
api-keys/
credentials/
```

### Use Configuration Management

```csharp
// ✅ GOOD: Use Azure Key Vault
var keyVaultUrl = "https://vault.azure.net/";
var credential = new DefaultAzureCredential();
var client = new SecretClient(new Uri(keyVaultUrl), credential);

var secret = await client.GetSecretAsync("ApiKey");
var apiKey = secret.Value.Value;
```

## Logging & Monitoring

### Log Security Events

```csharp
// Log authentication attempts
tracing.Trace($"[SECURITY] Authentication attempt for user: {userId}");

// Log authorization failures
tracing.Trace($"[SECURITY] Authorization denied - User: {userId}, Resource: {resource}");

// Log sensitive operations
tracing.Trace($"[SECURITY] Sensitive operation - Update user roles - User: {userId}");

// Never log sensitive data
// ❌ BAD
tracing.Trace($"API Key: {apiKey}");

// ✅ GOOD
tracing.Trace($"API Key: {apiKey?.Substring(0, 5)}...");
```

### Monitor Suspicious Activity

```csharp
// Detect brute force attempts
var failedAttempts = GetFailedLoginAttempts(userId, timeframe: TimeSpan.FromMinutes(15));

if (failedAttempts > 5)
{
    // Lock account or require additional verification
    tracing.Trace("[SECURITY] Multiple failed login attempts detected");
    throw new InvalidPluginExecutionException("Account locked due to suspicious activity");
}
```

## Compliance & Auditing

### Data Access Auditing

```csharp
// Log data access for compliance
var auditEntity = new Entity("cr9e5_auditlog")
{
    ["cr9e5_user"] = context.UserId,
    ["cr9e5_entity"] = target.LogicalName,
    ["cr9e5_action"] = "Read",
    ["cr9e5_timestamp"] = DateTime.UtcNow
};

service.Create(auditEntity);
```

### Retention Policies

```csharp
// Implement data retention
var query = new QueryExpression("cr9e5_auditlog")
{
    ColumnSet = new ColumnSet("cr9e5_auditlogid")
};

// Delete logs older than retention period
var retentionDate = DateTime.UtcNow.AddYears(-1);
query.Criteria.AddCondition("cr9e5_timestamp",
    ConditionOperator.LessThan, retentionDate);

var results = service.RetrieveMultiple(query);
foreach (var log in results.Entities)
{
    service.Delete(query.EntityName, log.Id);
}
```

## Security Testing

### Run Security Audit

```bash
/security-scan ./
```

This checks for:
- OWASP Top 10 vulnerabilities
- Hardcoded credentials
- Input validation gaps
- Authentication weaknesses
- Data protection issues

### Penetration Testing

Include security testing in development:
- Code review for vulnerabilities
- Dependency scanning
- Security integration tests
- Threat modeling

## Security Checklist

Before deployment, verify:

- ✅ All inputs validated
- ✅ No hardcoded secrets
- ✅ Authorization checks in place
- ✅ Sensitive data encrypted
- ✅ Error messages safe
- ✅ Logging secure
- ✅ Dependencies updated
- ✅ CORS configured
- ✅ Security audit passed
- ✅ Compliance requirements met

## Common Vulnerabilities

### Problem: SQL Injection

**Solution**: Use parameterized queries with QueryExpression/FetchXML

### Problem: Hardcoded Credentials

**Solution**: Use Azure Key Vault or configuration management

### Problem: Sensitive Data in Logs

**Solution**: Filter PII before logging, use structured logging

### Problem: Missing Authorization

**Solution**: Always check user permissions before operations

### Problem: XSS in Web Resources

**Solution**: Use textContent instead of innerHTML, escape HTML

## Get Security Help

```bash
Ask the security-reviewer agent for a detailed security audit
```

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Microsoft Security Best Practices](https://learn.microsoft.com/en-us/azure/security/)
- [Dynamics Security Guide](https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/security-dev)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)

Stay secure! 🔒
