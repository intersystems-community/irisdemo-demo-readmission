import { TestBed } from '@angular/core/testing';

import { IrisPatientService } from './iris-patient.service';

describe('IrisPatientService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: IrisPatientService = TestBed.get(IrisPatientService);
    expect(service).toBeTruthy();
  });
});
