import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FlexLayoutModule } from '@angular/flex-layout';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AddTournaDialog, EventsComponent } from './events/events.component';
import { MaterialModule } from './material/material.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { TeamCardComponent } from './team-card/team-card.component';
import { AddMemberDialog, TeamComponent } from './team/team.component';
import { EditMemberDialog, TeamMemberComponent } from './team-member/team-member.component';
import { LoginComponent } from './login/login.component';
import { RegisterComponent } from './register/register.component';
import { PlayerComponent } from './player/player.component';
import { TournementComponent } from './tournement/tournement.component';

import { TournamentCardComponent } from './tournament-card/tournament-card.component';

import { ManageComponent } from './manage/manage.component';

import { UserService } from './user.service';
import { APIService } from './api.service';
import { LocationsComponent } from './locations/locations.component';
import { TournamentGroupsComponent } from './tournament-groups/tournament-groups.component';
import { LeaguesComponent } from './leagues/leagues.component';
import { StandingsCardComponent } from './standings-card/standings-card.component';
import { StandingsTableComponent } from './standings-table/standings-table.component';
import { StandingEventCardComponent } from './standing-event-card/standing-event-card.component';
import { SiteComponent } from './site/site.component';
import { SiteCardComponent } from './site-card/site-card.component';


@NgModule({
  declarations: [
    AppComponent,
    EventsComponent,
    TeamCardComponent,
    TeamComponent,
    TeamMemberComponent,
    LoginComponent,
    EditMemberDialog,
    AddTournaDialog,
    RegisterComponent,
    PlayerComponent,
    TournementComponent,
    ManageComponent,
    TournamentCardComponent,   
    LocationsComponent,
    TournamentGroupsComponent,
    AddMemberDialog,
    LeaguesComponent,
    StandingsCardComponent,
    StandingsTableComponent,
    StandingEventCardComponent,
    SiteComponent,
    SiteCardComponent,
  ],
  imports: [
    BrowserModule.withServerTransition({ appId: 'serverApp' }),
    AppRoutingModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MaterialModule,
    FlexLayoutModule,
    ReactiveFormsModule,
    FormsModule,
  ],
  providers: [UserService, APIService],
  bootstrap: [AppComponent]
})
export class AppModule { }
