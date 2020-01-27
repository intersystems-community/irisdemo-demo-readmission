import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AdmissionSearchTableComponent } from './admission-search-table.component';

describe('AdmissionSearchTableComponent', () => {
  let component: AdmissionSearchTableComponent;
  let fixture: ComponentFixture<AdmissionSearchTableComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AdmissionSearchTableComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AdmissionSearchTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
