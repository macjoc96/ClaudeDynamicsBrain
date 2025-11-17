/**
 * Dynamics 365 TypeScript Action Template
 * This template provides a starting point for building TypeScript actions
 * for Dynamics 365 cloud flows and canvas apps
 */

import { IOrganizationService } from './types/organization-service';
import { Entity, EntityReference, OptionSetValue } from './types/dynamics-types';

/**
 * Action configuration
 */
export interface ActionInput {
  targetEntity: EntityReference;
  message: string;
  isActive?: boolean;
  count?: number;
}

export interface ActionOutput {
  result: string;
  status: number;
  errorMessage?: string;
}

/**
 * Main action handler class
 */
export class DynamicsAction {
  private organizationService: IOrganizationService;

  /**
   * Constructor
   * @param organizationService - Organization service instance
   */
  constructor(organizationService: IOrganizationService) {
    this.organizationService = organizationService;
  }

  /**
   * Execute the action
   * @param input - Action input parameters
   * @returns Action output
   */
  async execute(input: ActionInput): Promise<ActionOutput> {
    try {
      console.log('[ActionName] - Starting action execution');

      // Validate input
      this.validateInput(input);

      // Execute main logic
      const result = await this.executeActionLogic(input);

      console.log('[ActionName] - Action completed successfully');

      return {
        result: result,
        status: 1,
        errorMessage: undefined
      };
    } catch (error) {
      console.error('[ActionName] - Error:', error);

      return {
        result: 'Action failed',
        status: 0,
        errorMessage: this.extractErrorMessage(error)
      };
    }
  }

  /**
   * Validate input parameters
   * @param input - Input parameters to validate
   */
  private validateInput(input: ActionInput): void {
    if (!input) {
      throw new Error('Input cannot be null or undefined');
    }

    if (!input.targetEntity || !input.targetEntity.id) {
      throw new Error('Target entity is required');
    }

    if (!input.message || input.message.trim() === '') {
      throw new Error('Message is required and cannot be empty');
    }

    if (input.count !== undefined && input.count < 0) {
      throw new Error('Count must be a positive number');
    }
  }

  /**
   * Execute main action logic
   * @param input - Action input
   * @returns Result message
   */
  private async executeActionLogic(input: ActionInput): Promise<string> {
    try {
      // Step 1: Retrieve the target entity
      console.log(`Retrieving entity: ${input.targetEntity.logicalName}`);
      const entity = await this.organizationService.retrieve(
        input.targetEntity.logicalName,
        input.targetEntity.id,
        ['*']
      );

      console.log('Entity retrieved successfully');

      // Step 2: Perform business logic
      const updatedEntity = this.applyBusinessLogic(entity, input);

      // Step 3: Update the entity
      console.log('Updating entity with business logic results');
      await this.organizationService.update(
        input.targetEntity.logicalName,
        input.targetEntity.id,
        updatedEntity
      );

      console.log('Entity updated successfully');

      // Step 4: Execute additional operations if needed
      if (input.isActive) {
        await this.executeAdditionalOperations(input);
      }

      return 'Action executed successfully';
    } catch (error) {
      throw new Error(`Error in executeActionLogic: ${this.extractErrorMessage(error)}`);
    }
  }

  /**
   * Apply business logic to the entity
   * @param entity - Entity to process
   * @param input - Action input
   * @returns Updated entity
   */
  private applyBusinessLogic(entity: Entity, input: ActionInput): Partial<Entity> {
    const updates: Partial<Entity> = {};

    // Example: Update description
    if (input.message) {
      updates['description'] = input.message;
    }

    // Example: Update a custom field
    updates['cr9e5_customfield'] = input.count || 0;

    // Example: Set status based on condition
    if (input.isActive) {
      updates['statecode'] = new OptionSetValue(0); // Active
    } else {
      updates['statecode'] = new OptionSetValue(1); // Inactive
    }

    return updates;
  }

  /**
   * Execute additional operations
   * @param input - Action input
   */
  private async executeAdditionalOperations(input: ActionInput): Promise<void> {
    try {
      console.log('Executing additional operations');

      // Example: Create related records
      const relatedEntity: Entity = {
        logicalName: 'annotation',
        attributes: {
          objectid: input.targetEntity.id,
          notetext: `Created by action: ${input.message}`,
          subject: 'Action Execution Note'
        }
      };

      // Note: This is pseudocode - adjust based on actual service API
      console.log('Additional operations completed');
    } catch (error) {
      console.warn(`Warning during additional operations: ${this.extractErrorMessage(error)}`);
    }
  }

  /**
   * Extract error message from various error types
   * @param error - Error object
   * @returns Error message string
   */
  private extractErrorMessage(error: unknown): string {
    if (error instanceof Error) {
      return error.message;
    }

    if (typeof error === 'string') {
      return error;
    }

    if (typeof error === 'object' && error !== null) {
      const err = error as Record<string, unknown>;
      if ('message' in err && typeof err.message === 'string') {
        return err.message;
      }
    }

    return 'Unknown error occurred';
  }
}

/**
 * Factory function to create and execute action
 * @param organizationService - Organization service
 * @param input - Action input
 * @returns Action output promise
 */
export async function executeAction(
  organizationService: IOrganizationService,
  input: ActionInput
): Promise<ActionOutput> {
  const action = new DynamicsAction(organizationService);
  return await action.execute(input);
}

// Export types for external use
export { Entity, EntityReference, OptionSetValue };
