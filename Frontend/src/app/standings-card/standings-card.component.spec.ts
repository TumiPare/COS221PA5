import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { StandingsCardComponent } from './standings-card.component';

describe('StandingsCardComponent', () => {
  let component: StandingsCardComponent;
  let fixture: ComponentFixture<StandingsCardComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ StandingsCardComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(StandingsCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
