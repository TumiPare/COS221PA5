import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { StandingEventCardComponent } from './standing-event-card.component';

describe('StandingEventCardComponent', () => {
  let component: StandingEventCardComponent;
  let fixture: ComponentFixture<StandingEventCardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ StandingEventCardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(StandingEventCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
