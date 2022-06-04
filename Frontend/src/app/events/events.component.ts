import { Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../user.service';

@Component({
  selector: 'app-events',
  templateUrl: './events.component.html',
  styleUrls: ['./events.component.css']
})
export class EventsComponent implements OnInit {
  events: any;
  tournements = [{
    tournementName: "Clash of mandems",
  }, {
    tournementName: "Arabella vs Mitski",
  }, {
    tournementName: "Radloff's underlings vs World",
  }, {
    tournementName: "Me vs Radloff",
  }];

  constructor(
    private router: Router,
    private userService: UserService
  ) { }

  ngOnInit(): void {
    if (this.userService.userSignedIn)
      document.getElementById('addTourneyBtn').style.display = "block";
  }

  navigateToTeamPage(teamID: number, teamName: string) {
    this.router.navigate([`team/${teamID}/${teamName}`]);
  }

  addTourney(): void {
    alert("open Dialog");
  }
}
