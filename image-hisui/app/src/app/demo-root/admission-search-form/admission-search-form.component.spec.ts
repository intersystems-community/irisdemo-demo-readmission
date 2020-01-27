import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AdmissionSearchFormComponent } from './admission-search-form.component';

describe('AdmissionSearchFormComponent', () => {
  let component: AdmissionSearchFormComponent;
  let fixture: ComponentFixture<AdmissionSearchFormComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AdmissionSearchFormComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AdmissionSearchFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
