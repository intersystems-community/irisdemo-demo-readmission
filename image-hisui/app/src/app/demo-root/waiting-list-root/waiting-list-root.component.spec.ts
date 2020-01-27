import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { WaitingListRootComponent } from './waiting-list-root.component';

describe('WaitingListRootComponent', () => {
  let component: WaitingListRootComponent;
  let fixture: ComponentFixture<WaitingListRootComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ WaitingListRootComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(WaitingListRootComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
