---
description: Generate a complete C# plugin project structure with boilerplate code, namespaces, and configuration files ready for Dynamics 365 development
argument-hint: [PluginName]
allowed-tools: Write, Bash
---

Generate a new Dynamics 365 C# plugin project scaffold with the following structure:

## Task
Create a new C# plugin project for Dynamics 365 with:
- Project file (.csproj) configured for Dynamics SDK
- Main plugin class implementing IPlugin
- Helper classes for organization service operations
- NuGet package references (Microsoft.CrmSdk.CoreAssemblies)
- Plugin registration configuration
- Unit test project setup
- Documentation comments
- Error handling boilerplate

## Details to Include
- Plugin name: $ARGUMENTS (or default: "MyDynamicsPlugin")
- Target .NET Framework: 4.6.2 or higher
- Namespace organization
- Standard CRUD operation methods
- Exception handling patterns
- Plugin trace logging
- Organization service initialization

## Output
Provide complete ready-to-use plugin project structure with all configuration files and boilerplate code that can be immediately opened in Visual Studio for development.
