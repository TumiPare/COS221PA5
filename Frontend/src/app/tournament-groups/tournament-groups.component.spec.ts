import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { TournamentGroupsComponent } from './tournament-groups.component';

describe('TournamentGroupsComponent', () => {
  let component: TournamentGroupsComponent;
  let fixture: ComponentFixture<TournamentGroupsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ TournamentGroupsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(TournamentGroupsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
