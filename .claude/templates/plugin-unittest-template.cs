using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Sdk;
using Moq;
using System;
using [YourCompany].Dynamics365.Plugins;

namespace [YourCompany].Dynamics365.Tests
{
    /// <summary>
    /// Unit tests for [PluginName] plugin
    /// </summary>
    [TestClass]
    public class [PluginName]Tests
    {
        private Mock<IServiceProvider> _mockServiceProvider;
        private Mock<IPluginExecutionContext> _mockContext;
        private Mock<ITracingService> _mockTracingService;
        private Mock<IOrganizationServiceFactory> _mockServiceFactory;
        private Mock<IOrganizationService> _mockOrgService;

        [TestInitialize]
        public void Setup()
        {
            // Initialize mocks
            _mockServiceProvider = new Mock<IServiceProvider>();
            _mockContext = new Mock<IPluginExecutionContext>();
            _mockTracingService = new Mock<ITracingService>();
            _mockServiceFactory = new Mock<IOrganizationServiceFactory>();
            _mockOrgService = new Mock<IOrganizationService>();

            // Configure mocks
            _mockServiceProvider
                .Setup(x => x.GetService(typeof(IPluginExecutionContext)))
                .Returns(_mockContext.Object);

            _mockServiceProvider
                .Setup(x => x.GetService(typeof(ITracingService)))
                .Returns(_mockTracingService.Object);

            _mockServiceProvider
                .Setup(x => x.GetService(typeof(IOrganizationServiceFactory)))
                .Returns(_mockServiceFactory.Object);

            _mockServiceFactory
                .Setup(x => x.CreateOrganizationService(It.IsAny<Guid?>()))
                .Returns(_mockOrgService.Object);
        }

        [TestMethod]
        [ExpectedException(typeof(ArgumentNullException))]
        public void Execute_WithNullServiceProvider_ThrowsArgumentNullException()
        {
            // Arrange
            var plugin = new [PluginName]();

            // Act
            plugin.Execute(null);

            // Assert - handled by ExpectedException attribute
        }

        [TestMethod]
        public void Execute_WithValidContext_ExecutesSuccessfully()
        {
            // Arrange
            var plugin = new [PluginName]();
            var entity = new Entity("account") { Id = Guid.NewGuid() };
            entity["name"] = "Test Account";

            _mockContext.Setup(x => x.InputParameters).Returns(
                new ParameterCollection { { "Target", entity } });

            _mockContext.Setup(x => x.PostEntityImages).Returns(
                new EntityImageCollection());

            _mockContext.Setup(x => x.MessageName).Returns("Create");
            _mockContext.Setup(x => x.UserId).Returns(Guid.NewGuid());

            // Act
            plugin.Execute(_mockServiceProvider.Object);

            // Assert
            _mockTracingService.Verify(
                x => x.Trace(It.IsAny<string>()),
                Times.AtLeastOnce);
        }

        [TestMethod]
        public void Execute_WithPreImage_ProcessesPreImageSuccessfully()
        {
            // Arrange
            var plugin = new [PluginName]();
            var preImage = new Entity("account") { Id = Guid.NewGuid() };
            preImage["name"] = "Old Name";

            var postImage = new Entity("account") { Id = preImage.Id };
            postImage["name"] = "New Name";

            var images = new EntityImageCollection
            {
                { "PreImage", preImage },
                { "PostImage", postImage }
            };

            _mockContext.Setup(x => x.InputParameters).Returns(
                new ParameterCollection { { "Target", postImage } });

            _mockContext.Setup(x => x.PostEntityImages).Returns(images);
            _mockContext.Setup(x => x.MessageName).Returns("Update");
            _mockContext.Setup(x => x.UserId).Returns(Guid.NewGuid());

            // Act
            plugin.Execute(_mockServiceProvider.Object);

            // Assert
            _mockTracingService.Verify(
                x => x.Trace(It.Is<string>(s => s.Contains("Pre-image"))),
                Times.AtLeastOnce);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidPluginExecutionException))]
        public void Execute_WhenServiceThrowsException_ThrowsInvalidPluginExecutionException()
        {
            // Arrange
            var plugin = new [PluginName]();
            var entity = new Entity("account");

            _mockContext.Setup(x => x.InputParameters).Returns(
                new ParameterCollection { { "Target", entity } });

            _mockContext.Setup(x => x.PostEntityImages).Returns(
                new EntityImageCollection());

            _mockContext.Setup(x => x.MessageName).Returns("Create");
            _mockContext.Setup(x => x.UserId).Returns(Guid.NewGuid());

            _mockOrgService
                .Setup(x => x.Execute(It.IsAny<OrganizationRequest>()))
                .Throws(new Exception("Test exception"));

            // Act
            plugin.Execute(_mockServiceProvider.Object);

            // Assert - handled by ExpectedException attribute
        }

        [TestCleanup]
        public void Cleanup()
        {
            _mockServiceProvider = null;
            _mockContext = null;
            _mockTracingService = null;
            _mockServiceFactory = null;
            _mockOrgService = null;
        }
    }
}
