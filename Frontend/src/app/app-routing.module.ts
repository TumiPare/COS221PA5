import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { EventsComponent } from './events/events.component';
import { LoginComponent } from './login/login.component';
import { PlayerComponent } from './player/player.component';
import { RegisterComponent } from './register/register.component';
import { TeamComponent } from './team/team.component';
import { TournementComponent } from './tournement/tournement.component';
import { ManageComponent } from './manage/manage.component';
import { LeaguesComponent } from './leagues/leagues.component';

const routes: Routes = [
  { path: '', component: LeaguesComponent },
  { path: 'league/:leagueID/:leagueName', component: EventsComponent },
  { path: 'team/:teamID/:teamName', component: TeamComponent },
  { path: 'player/:playerID/:playerName', component: PlayerComponent },
  { path: 'tournament/:tournementID/:tournementName', component: TournementComponent },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'manage', component: ManageComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes, {
    initialNavigation: 'enabled'
  })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
