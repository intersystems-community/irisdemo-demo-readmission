import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UserDischargeModalComponent } from './user-discharge-modal.component';

describe('UserDischargeModalComponent', () => {
  let component: UserDischargeModalComponent;
  let fixture: ComponentFixture<UserDischargeModalComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UserDischargeModalComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UserDischargeModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
