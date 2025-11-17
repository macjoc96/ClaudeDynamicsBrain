# Plugin Development Guide

This guide covers best practices and patterns for developing C# plugins for Dynamics 365 using Claude.

## Plugin Fundamentals

### What is a Plugin?

A plugin is custom business logic that extends Dynamics 365 functionality. Plugins:
- Respond to specific events (create, update, delete, retrieve)
- Execute server-side code with full access to the data model
- Provide synchronous and asynchronous execution options
- Can access the organization service and entity data

### Plugin Lifecycle

```
Event Occurs (e.g., Create Record)
↓
Pre-Operation Plugin Executes (if registered)
↓
Dynamics Processes the Record
↓
Post-Operation Plugin Executes (if registered)
```

## Getting Started

### 1. Create a Plugin Project

```bash
/plugin-scaffold MyBusinessLogic
```

This generates a project with:
- IPlugin interface implementation
- Organization service initialization
- Proper exception handling
- Plugin tracing for debugging
- Pre-configured NuGet packages

### 2. Implement Plugin Logic

Replace the template logic in the plugin class:

```csharp
private void ExecutePluginLogic(IPluginExecutionContext context,
                                IOrganizationService service,
                                ITracingService tracing)
{
    // Your business logic here
}
```

### 3. Add Entity References

Use early binding for type safety:

```csharp
// Using typed entity class
var account = context.GetTarget<Account>();
account.Name = "Updated Name";
```

## Common Plugin Patterns

### Pre-Create Plugin

Execute before a record is created:

```csharp
// Validate input
if (target.GetAttributeValue<string>("name") == null)
{
    throw new InvalidPluginExecutionException("Name is required");
}

// Set defaults
if (!target.Contains("cr9e5_category"))
{
    target["cr9e5_category"] = new OptionSetValue(1);
}
```

### Pre-Update Plugin

Execute before a record is updated:

```csharp
// Compare old value (from PreImage) with new value (from InputParameters)
var target = context.InputParameters["Target"] as Entity;
var preImage = context.PreEntityImages["PreImage"];

var oldName = preImage.GetAttributeValue<string>("name");
var newName = target?.GetAttributeValue<string>("name");

if (oldName != newName)
{
    tracing.Trace($"Name changed from {oldName} to {newName}");
}
```

### Post-Create Plugin

Execute after a record is created:

```csharp
// Create related records
var newTask = new Task
{
    Subject = "Follow up on new account",
    RegardingObjectId = target.ToEntityReference(),
    DueDate = DateTime.Now.AddDays(7)
};

var taskId = service.Create(newTask);
tracing.Trace($"Created task: {taskId}");
```

### Post-Delete Plugin

Execute after a record is deleted:

```csharp
// Archive related records
var query = new QueryExpression("annotation")
{
    ColumnSet = new ColumnSet("annotationid")
};

query.Criteria.AddCondition("objectid", ConditionOperator.Equal, target.Id);

var results = service.RetrieveMultiple(query);
foreach (var note in results.Entities)
{
    service.Delete("annotation", note.Id);
}
```

## Working with Entities

### Early Binding

Use generated entity classes for type safety:

```csharp
var account = context.GetTarget<Account>();
account.Name = "ACME Corp";
account.CreditLimit = new Money(10000);
account.Industry = new OptionSetValue(1); // Manufacturing

service.Update(account);
```

### Late Binding

Use Entity class for flexibility:

```csharp
var entity = context.GetTarget<Entity>();
entity["name"] = "ACME Corp";
entity["creditlimit"] = new Money(10000);

service.Update(entity);
```

## Query Patterns

### Using FetchXML

Efficient querying with FetchXML:

```csharp
string fetchXml = @"
    <fetch>
        <entity name='account'>
            <attribute name='accountid' />
            <attribute name='name' />
            <filter>
                <condition attribute='statecode' operator='eq' value='0' />
                <condition attribute='industrycode' operator='eq' value='1' />
            </filter>
            <order attribute='name' descending='false' />
        </entity>
    </fetch>";

var result = service.RetrieveMultiple(new FetchExpression(fetchXml));
```

### Using QueryExpression

Build queries programmatically:

```csharp
var query = new QueryExpression("account")
{
    ColumnSet = new ColumnSet("name", "revenue"),
    PageInfo = new PagingInfo { PageNumber = 1, Count = 100 }
};

query.Criteria.AddCondition("statecode", ConditionOperator.Equal, 0);

var filter = new FilterExpression(LogicalOperator.And);
filter.AddCondition("industrycode", ConditionOperator.In, 1, 2, 3);
query.Criteria.AddFilter(filter);

var results = service.RetrieveMultiple(query);
```

## Security & Permissions

### Check User Permissions

```csharp
var principalEntity = service.Retrieve("systemuser", context.UserId,
    new ColumnSet("businessunitid"));

tracing.Trace($"User Business Unit: {principalEntity.Id}");

// Check role
var roleQuery = new QueryExpression("role")
{
    ColumnSet = new ColumnSet("name")
};

var principalRoles = service.RetrieveMultiple(
    new QueryExpression("systemuserroles")
    {
        Filters = new FilterExpression()
        {
            Conditions =
            {
                new ConditionExpression("systemuserid", ConditionOperator.Equal, context.UserId)
            }
        }
    });
```

### Input Validation

Always validate user input:

```csharp
// Validate string length
var name = target.GetAttributeValue<string>("name");
if (string.IsNullOrWhiteSpace(name) || name.Length > 100)
{
    throw new InvalidPluginExecutionException("Name must be 1-100 characters");
}

// Validate numeric range
var quantity = target.GetAttributeValue<int>("quantity");
if (quantity < 0 || quantity > 1000)
{
    throw new InvalidPluginExecutionException("Quantity must be between 0-1000");
}
```

## Error Handling

### Proper Exception Handling

```csharp
try
{
    // Plugin logic
}
catch (FaultException<OrganizationServiceFault> ex)
{
    // Dynamics-specific error
    tracing.Trace($"Dynamics Error: {ex.Detail.Message}");
    throw new InvalidPluginExecutionException($"Error: {ex.Detail.Message}", ex);
}
catch (Exception ex)
{
    // General error
    tracing.Trace($"Error: {ex.Message}\nStack Trace: {ex.StackTrace}");
    throw new InvalidPluginExecutionException("An error occurred in the plugin", ex);
}
```

## Performance Optimization

### Batch Operations

Process multiple records efficiently:

```csharp
// Create multiple records
var createRequests = new List<CreateRequest>();
for (int i = 0; i < 100; i++)
{
    var request = new CreateRequest
    {
        Target = new Entity("contact") { ["firstname"] = $"Contact {i}" }
    };
    createRequests.Add(request);
}

var executeMultipleRequest = new ExecuteMultipleRequest
{
    Requests = new OrganizationRequestCollection(createRequests),
    Settings = new ExecuteMultipleSettings
    {
        ContinueOnError = false,
        ReturnResponses = true
    }
};

var response = (ExecuteMultipleResponse)service.Execute(executeMultipleRequest);
```

### Caching Reference Data

```csharp
// Store reference data in execution context
var contextVariables = context.SharedVariables;

if (!contextVariables.Contains("statuses"))
{
    var statusQuery = new QueryExpression("statuscode")
    {
        ColumnSet = new ColumnSet("statuscodeid", "statuscodename")
    };

    var statuses = service.RetrieveMultiple(statusQuery);
    contextVariables["statuses"] = statuses;
}

var cachedStatuses = (EntityCollection)contextVariables["statuses"];
```

## Testing Plugins

### Unit Testing Template

```csharp
/test-setup unit MyPlugin
```

This creates:
- MSTest project
- Mock setup for organization service
- Test helper utilities
- Sample test cases

### Test Patterns

```csharp
[TestMethod]
public void PluginShouldSetDefaultValueOnCreate()
{
    // Arrange
    var plugin = new MyPlugin();
    var entity = new Entity("account") { Id = Guid.NewGuid() };

    _mockContext.Setup(x => x.InputParameters)
        .Returns(new ParameterCollection { { "Target", entity } });

    // Act
    plugin.Execute(_mockServiceProvider.Object);

    // Assert
    _mockOrgService.Verify(
        x => x.Update(It.Is<Entity>(e =>
            e["cr9e5_category"].ToString() == "1")),
        Times.Once);
}
```

## Debugging Plugins

### Enable Plugin Tracing

1. In Plugin Registration Tool: Set trace level
2. Execute the plugin
3. Download and review trace logs

### Review Trace Logs

```csharp
tracing.Trace("About to execute query");
var result = service.RetrieveMultiple(query);
tracing.Trace($"Query returned {result.Entities.Count} records");
```

## Common Issues

### Problem: Plugin Not Executing
- Check plugin registration (event, entity, stage)
- Verify plugin assembly is deployed
- Review trace logs for errors
- Check security roles have Execute permission

### Problem: Performance Issues
- Optimize queries to return only needed columns
- Use batch operations for multiple records
- Implement caching for reference data
- Avoid nested loops with service calls

### Problem: Data Inconsistency
- Use transactions carefully
- Validate data before updates
- Check for race conditions
- Use optimistic concurrency control

## Best Practices Checklist

- ✅ Validate all input data
- ✅ Use early binding where possible
- ✅ Implement comprehensive error handling
- ✅ Use plugin tracing for debugging
- ✅ Keep plugins focused and single-purpose
- ✅ Avoid long-running operations in sync plugins
- ✅ Cache frequently accessed data
- ✅ Use batch operations for bulk changes
- ✅ Test thoroughly before deployment
- ✅ Document plugin purpose and logic
- ✅ Run security audit before deployment
- ✅ Monitor performance post-deployment

## Next Steps

1. Create a plugin: `/plugin-scaffold MyPlugin`
2. Set up tests: `/test-setup unit`
3. Review security: `/security-scan`
4. Get expert help: Ask the plugin-developer agent
5. Deploy: `/solution-package`

## Resources

- [Plugin Development Documentation](https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/write-plugins)
- [SDK Messages Reference](https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/event-framework)
- [Best Practices Guide](https://learn.microsoft.com/en-us/dynamics365/customerengagement/on-premises/developer/best-practices-sdk)
