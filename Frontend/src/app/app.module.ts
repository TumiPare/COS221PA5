import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FlexLayoutModule } from '@angular/flex-layout';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { EventsComponent } from './events/events.component';
import { MaterialModule } from './material/material.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { TeamCardComponent } from './team-card/team-card.component';
import { TeamComponent } from './team/team.component';
import { EditMemberDialog, TeamMemberComponent } from './team-member/team-member.component';
import { LoginComponent } from './login/login.component';
import { UserService } from './user.service';
import { RegisterComponent } from './register/register.component';
import { PlayerComponent } from './player/player.component';

@NgModule({
  declarations: [
    AppComponent,
    EventsComponent,
    TeamCardComponent,
    TeamComponent,
    TeamMemberComponent,
    LoginComponent,
    EditMemberDialog,
    RegisterComponent,
    PlayerComponent,   
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
  providers: [UserService],
  bootstrap: [AppComponent]
})
export class AppModule { }
