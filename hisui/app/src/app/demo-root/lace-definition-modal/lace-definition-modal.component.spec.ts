import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LaceDefinitionModalComponent } from './lace-definition-modal.component';

describe('LaceDefinitionModalComponent', () => {
  let component: LaceDefinitionModalComponent;
  let fixture: ComponentFixture<LaceDefinitionModalComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LaceDefinitionModalComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LaceDefinitionModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
