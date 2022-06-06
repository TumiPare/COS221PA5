import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { FormControl } from '@angular/forms';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { map, startWith } from 'rxjs/operators';
import { APIService } from '../api.service';
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
    private userService: UserService,
    private api: APIService,
    public dialog: MatDialog,
  ) { }

  ngOnInit(): void {
    if (this.userService.userSignedIn())
      document.getElementById('addTourneyBtn').style.display = "block";
    this.api.getTournaments().subscribe((res) => {
      console.log(res);
    });
  }

  navigateToTeamPage(teamID: number, teamName: string) {
    this.router.navigate([`team/${teamID}/${teamName}`]);
  }

  addTourney(): void {
    const dialogRef = this.dialog.open(AddTournaDialog, {});

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      console.log("Recieved: ", result);
    });
  }
}


@Component({
  selector: 'add-tournament-dialog',
  templateUrl: 'add-tournament-dialog.html',
  styleUrls: ['add-tournament-dialog.css']
})
export class AddTournaDialog implements OnInit {
  @ViewChild('playerName') name;
  lineups: Array<{ teamA: string, teamB: string }>;

  myControl = new FormControl();
  teams: { teamID: number, teamName: string, teamLogo: string }[];
  options: string[] = ['team1', 'team2', 'team3'];
  filteredOptions: Observable<string[]>;

  constructor(
    public dialogRef: MatDialogRef<AddTournaDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    this.lineups = [];
    for (let i = 0; i < 8; i++) {
      this.lineups.push({
        teamA: '',
        teamB: '',
      });
    }
  }

  ngOnInit() {
    this.api.getAllTeams().subscribe((res) => {
      if (res.status == "success") {
        console.log(res);
        this.teams = res.teams;
        this.teams.forEach(team => {
          this.options.push(team.teamName);
        });
      } else {
        //Error
        console.log(res);
      }
    });
    this.filteredOptions = this.myControl.valueChanges.pipe(
      startWith(''),
      map(value => this._filter(value))
    );
  }

  private _filter(value: string): string[] {
    const filterValue = value.toLowerCase();

    return this.options.filter(option => option.toLowerCase().indexOf(filterValue) === 0);
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  addTournament() {
    let actualLineups = [];
    this.lineups.forEach(match => {
      let tempLineup = { teamA: 0, teamB: 0 };

      for (let i = 0; i < this.teams.length; i++) {
        if (this.teams[i].teamName == match.teamA)
          tempLineup.teamA = this.teams[i].teamID;
        if (this.teams[i].teamName == match.teamB)
          tempLineup.teamB = this.teams[i].teamID;
      }

      actualLineups.push(tempLineup);
    });

    console.log(this.lineups);
    this.dialogRef.close(this.data);
  }

}