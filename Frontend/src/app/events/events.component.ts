import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { FormControl } from '@angular/forms';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
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
  seasonID: number;

  selectedSubSeason: any;// will be a season
  subseasons: Array<any> = [];
  events: any;
  tournements = [];

  constructor(
    private router: Router,
    private api: APIService,
    public dialog: MatDialog,
    private route: ActivatedRoute,
  ) { }

  ngOnInit(): void {
    this.seasonID = Number(this.route.snapshot.paramMap.get('seasonID'));

    this.api.getSubSeasons(this.seasonID).subscribe((res) => {
      if (res.status == "success") {
        for (let season of res.data) {
          for (let subSeason of season.subseasons) {
            this.subseasons.push(subSeason);
          }
        }
        // console.log(this.subseasons);
      }
    });
  }

  selectSubSeason(selectedSubSeason: any) {
    this.selectedSubSeason = selectedSubSeason;
    this.api.getTournaments(this.selectedSubSeason.subseasonID).subscribe((res) => {
      if (res.status == "success") {
        res.data.tournament.teams = [];
        for (let match of res.data.tournament.rounds[0].matches) {
          res.data.tournament.teams.push(match.teamA.teamID);
        }
        this.tournements.push(res.data.tournament);
      }
    });
  }

  addTourney(): void {
    const dialogRef = this.dialog.open(AddTournaDialog, { data: { seasonID: this.selectedSubSeason.subseasonID }, });

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
  seasonID: number;

  myControl = new FormControl();
  teams: Array<{ id: number, team_key: string, full_name: string }> = [];
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
    this.seasonID = this.data.seasonID;
  }

  ngOnInit() {
    this.api.getAllTeams().subscribe((res) => {
      if (res.status == "success") {
        console.log(res);
        this.teams = res.data;
        this.teams.forEach(team => {
          this.options.push(team.team_key);
        });
        this.filteredOptions = this.myControl.valueChanges.pipe(
          startWith(''),
          map(value => this._filter(value))
        );
      } else {
        //Error
        console.log(res);
      }
    });
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
        if (this.teams[i].team_key == match.teamA)
          tempLineup.teamA = this.teams[i].id;
        if (this.teams[i].team_key == match.teamB)
          tempLineup.teamB = this.teams[i].id;
      }

      actualLineups.push(tempLineup);
    });

    let tourneyName = (<HTMLInputElement>document.getElementById("tournaName")).value;

    this.api.addTournament(this.seasonID, tourneyName, actualLineups).subscribe((res) => {
      console.log(res);
    });
    console.log(actualLineups);
    this.dialogRef.close(this.data);
  }

}