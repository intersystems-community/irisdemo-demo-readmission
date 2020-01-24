import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { WaitingListTableComponent } from './waiting-list-table.component';

describe('WaitingListTableComponent', () => {
  let component: WaitingListTableComponent;
  let fixture: ComponentFixture<WaitingListTableComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ WaitingListTableComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(WaitingListTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
