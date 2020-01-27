import { TestBed } from '@angular/core/testing';

import { IrisWorkflowService } from './iris-workflow.service';

describe('IrisWorkflowService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: IrisWorkflowService = TestBed.get(IrisWorkflowService);
    expect(service).toBeTruthy();
  });
});
