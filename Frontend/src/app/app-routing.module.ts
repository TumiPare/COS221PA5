import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { EventsComponent } from './events/events.component';
import { TeamComponent } from './team/team.component';

const routes: Routes = [
  { path: '', component: EventsComponent },
  { path: 'team/:teamID/:teamName', component: TeamComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes, {
    initialNavigation: 'enabled'
  })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
