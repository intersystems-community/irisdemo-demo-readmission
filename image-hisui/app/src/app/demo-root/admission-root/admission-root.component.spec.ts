import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AdmissionRootComponent } from './admission-root.component';

describe('AdmissionRootComponent', () => {
  let component: AdmissionRootComponent;
  let fixture: ComponentFixture<AdmissionRootComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AdmissionRootComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AdmissionRootComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
