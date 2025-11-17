// Jest setup file for Power Apps Code Apps and TypeScript projects
import '@testing-library/jest-dom';

// Mock Power Apps context if needed
global.PowerApps = {
  getContext: jest.fn(() => ({
    user: {
      id: 'test-user-id',
      name: 'Test User',
      email: 'test@example.com'
    },
    organization: {
      id: 'test-org-id',
      name: 'Test Organization',
      url: 'https://test.crm.dynamics.com'
    }
  }))
};

// Mock Dataverse Web API
global.Xrm = {
  WebApi: {
    createRecord: jest.fn(),
    retrieveRecord: jest.fn(),
    retrieveMultipleRecords: jest.fn(),
    updateRecord: jest.fn(),
    deleteRecord: jest.fn()
  },
  Navigation: {
    openForm: jest.fn(),
    openUrl: jest.fn()
  },
  Utility: {
    showProgressIndicator: jest.fn(),
    closeProgressIndicator: jest.fn(),
    alertDialog: jest.fn(),
    confirmDialog: jest.fn()
  }
};

// Suppress console warnings in tests (optional)
const originalConsoleError = console.error;
const originalConsoleWarn = console.warn;

beforeAll(() => {
  console.error = jest.fn((...args) => {
    // Only show errors that aren't React warnings
    if (!args[0]?.includes('Warning:')) {
      originalConsoleError(...args);
    }
  });

  console.warn = jest.fn((...args) => {
    // Filter out specific warnings if needed
    originalConsoleWarn(...args);
  });
});

afterAll(() => {
  console.error = originalConsoleError;
  console.warn = originalConsoleWarn;
});

// Clean up after each test
afterEach(() => {
  jest.clearAllMocks();
});

// Add custom matchers if needed
expect.extend({
  toBeValidGuid(received: string) {
    const guidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    const pass = guidRegex.test(received);

    return {
      pass,
      message: () => pass
        ? `Expected ${received} not to be a valid GUID`
        : `Expected ${received} to be a valid GUID`
    };
  }
});

// Declare custom matcher types
declare global {
  namespace jest {
    interface Matchers<R> {
      toBeValidGuid(): R;
    }
  }
}

export {};
