import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UserDischargeFormComponent } from './user-discharge-form.component';

describe('UserDischargeFormComponent', () => {
  let component: UserDischargeFormComponent;
  let fixture: ComponentFixture<UserDischargeFormComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UserDischargeFormComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UserDischargeFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
