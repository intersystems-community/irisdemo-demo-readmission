import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { WorkflowRootComponent } from './workflow-root.component';

describe('WorkflowRootComponent', () => {
  let component: WorkflowRootComponent;
  let fixture: ComponentFixture<WorkflowRootComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ WorkflowRootComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(WorkflowRootComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
