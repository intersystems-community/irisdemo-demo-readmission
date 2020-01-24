import { TestBed } from '@angular/core/testing';

import { IrisMlService } from './iris-ml.service';

describe('IrisMlService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: IrisMlService = TestBed.get(IrisMlService);
    expect(service).toBeTruthy();
  });
});
