import { TestBed } from '@angular/core/testing';

import { PatientCensusUtilityService } from './patient-census-utility.service';

describe('PatientCensusUtilityService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: PatientCensusUtilityService = TestBed.get(PatientCensusUtilityService);
    expect(service).toBeTruthy();
  });
});
