import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { StatsFormsComponent } from './stats-forms.component';

describe('StatsFormsComponent', () => {
  let component: StatsFormsComponent;
  let fixture: ComponentFixture<StatsFormsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ StatsFormsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(StatsFormsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
