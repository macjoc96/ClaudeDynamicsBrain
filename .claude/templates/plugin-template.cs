using Microsoft.Xrm.Sdk;
using System;

namespace [YourCompany].Dynamics365.Plugins
{
    /// <summary>
    /// [Plugin Description]
    ///
    /// Registered on: [Entity Name]
    /// Event: [Pre/Post] [Create/Update/Delete/Retrieve]
    /// Synchronous: [Yes/No]
    /// </summary>
    public class [PluginName] : IPlugin
    {
        /// <summary>
        /// Executes the plugin logic
        /// </summary>
        /// <param name="serviceProvider">The service provider</param>
        public void Execute(IServiceProvider serviceProvider)
        {
            if (serviceProvider == null)
                throw new ArgumentNullException(nameof(serviceProvider));

            try
            {
                // Extract the tracing service for use in debugging
                var tracingService = (ITracingService)serviceProvider.GetService(typeof(ITracingService));
                tracingService.Trace("[PluginName] - Plugin execution started");

                // Extract the execution context
                var context = (IPluginExecutionContext)serviceProvider.GetService(typeof(IPluginExecutionContext));

                // Extract the organization service
                var serviceFactory = (IOrganizationServiceFactory)serviceProvider.GetService(typeof(IOrganizationServiceFactory));
                var service = serviceFactory.CreateOrganizationService(context.UserId);

                // Plugin logic starts here
                ExecutePluginLogic(context, service, tracingService);

                tracingService.Trace("[PluginName] - Plugin execution completed successfully");
            }
            catch (Exception ex)
            {
                throw new InvalidPluginExecutionException(
                    $"[PluginName] - An error occurred: {ex.Message}",
                    ex);
            }
        }

        /// <summary>
        /// Main plugin logic
        /// </summary>
        private void ExecutePluginLogic(IPluginExecutionContext context, IOrganizationService service, ITracingService tracing)
        {
            try
            {
                // Get the target entity from the context
                if (context.InputParameters.Contains("Target") && context.InputParameters["Target"] is Entity target)
                {
                    tracing.Trace($"Processing entity: {target.LogicalName}");

                    // TODO: Add your plugin logic here
                    // Example:
                    // if (target.LogicalName == "account")
                    // {
                    //     // Perform operations on the account entity
                    // }
                }

                // Check for pre-image if this is a post operation
                if (context.MessageName == "Update" && context.PostEntityImages.Contains("PreImage"))
                {
                    var preImage = context.PostEntityImages["PreImage"];
                    tracing.Trace($"Pre-image retrieved: {preImage.LogicalName}");
                }

                // Check for post-image
                if (context.PostEntityImages.Contains("PostImage"))
                {
                    var postImage = context.PostEntityImages["PostImage"];
                    tracing.Trace($"Post-image retrieved: {postImage.LogicalName}");
                }
            }
            catch (Exception ex)
            {
                throw new InvalidPluginExecutionException(
                    $"Error in ExecutePluginLogic: {ex.Message}",
                    ex);
            }
        }
    }
}
