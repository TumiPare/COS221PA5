import { Component, OnInit } from '@angular/core';
import { Tournament } from './tournament'
import { ActivatedRoute } from '@angular/router';
import { APIService } from '../api.service';


@Component({
  selector: 'app-tournement',
  templateUrl: './tournement.component.html',
  // templateUrl: '<tournament-card></tournament-card>',
  styleUrls: ['./tournement.component.css']
})
export class TournementComponent implements OnInit {
  tournament: Tournament;
  tournamentName: string;
  tournamentID: number;

  constructor(
    private route: ActivatedRoute,
    private api: APIService
  ) {
    this.tournamentName = this.route.snapshot.paramMap.get('tournementName');
    this.tournamentID = Number(this.route.snapshot.paramMap.get('tournementID'));
  }

  ngOnInit(): void {
    this.setTournament();
  }

  setTournament() {
    

    this.api.getTournament(this.tournamentID).subscribe((res) => {
      console.log(res);
      
      for (let i = 0; i < 8; i++) {
        let Team1 = res.data.tournament.rounds[0].matches[i].teamA.teamID;
        let Team2 = res.data.tournament.rounds[0].matches[i].teamB.teamID;

        this.api.get2Teams(Team1, Team2).subscribe((req) => {  // Get the teams
          console.log(req);

          if (req.status == "success") {
            
            Team1 = req.teams[0].name;
            let Team1pic = req.teams[0].teamLogo;

            Team2 = req.teams[1].name;
            let Team2pic = req.teams[1].teamLogo;

            this.tournament.roundof16[i].teamA = Team1;
            this.tournament.roundof16[i].picA = Team1pic;

            this.tournament.roundof16[i].scoreA = res.data.rounds[0].matches[i].teamA.points;


            this.tournament.roundof16[i].teamB = Team2;
            this.tournament.roundof16[i].picB = Team2pic;

            this.tournament.roundof16[i].scoreB = res.data.rounds[0].matches[i].teamB.points;
          }
          else
            console.log("Something went wrong with getTeam");
        });
      }
      for (let i = 0; i < 4; i++) {
        let Team1 = res.data.tournament.rounds[1].matches[i].teamA.teamID;
        let Team2 = res.data.tournament.rounds[1].matches[i].teamB.teamID;

        this.api.get2Teams(Team1, Team2).subscribe((req) => { // Get the teams
          console.log(req);

          if (req.status == "success") {
            Team1 = req.teams[0].name;
            let Team1pic = req.teams[0].teamLogo;

            Team2 = req.teams[1].name;
            let Team2pic = req.teams[1].teamLogo;

            this.tournament.quarterFinals[i].teamA = Team1;
            this.tournament.quarterFinals[i].picA = Team1pic;

            this.tournament.quarterFinals[i].scoreA = res.data.rounds[1].matches[i].teamA.points;


            this.tournament.quarterFinals[i].teamB = Team2;
            this.tournament.quarterFinals[i].picB = Team2pic;

            this.tournament.quarterFinals[i].scoreB = res.data.rounds[1].matches[i].teamB.points;
          }
          else
            console.log("Something went wrong with getTeam");

        });

      }

      for (let i = 0; i < 2; i++) {

        let Team1 = res.data.tournament.rounds[2].matches[i].teamA.teamID;
        let Team2 = res.data.tournament.rounds[2].matches[i].teamB.teamID;


        this.api.get2Teams(Team1, Team2).subscribe((req) => {                 //Get the teams
          console.log(req);

          if (req.status == "success") {
            Team1 = req.teams[0].name;
            let Team1pic = req.teams[0].teamLogo;

            Team2 = req.teams[1].name;
            let Team2pic = req.teams[1].teamLogo;

            this.tournament.semiFinals[i].teamA = Team1;
            this.tournament.semiFinals[i].picA = Team1pic;

            this.tournament.semiFinals[i].scoreA = res.data.rounds[2].matches[i].teamA.points;


            this.tournament.semiFinals[i].teamB = Team2;
            this.tournament.semiFinals[i].picB = Team2pic;

            this.tournament.semiFinals[i].scoreB = res.data.rounds[2].matches[i].teamB.points;
          }
          else
            console.log("Something went wrong with getTeam");

        });

      }


      {

        let Team1 = res.data.tournament.rounds[3].matches[0].teamA.teamID;
        let Team2 = res.data.tournament.rounds[3].matches[0].teamB.teamID;


        this.api.get2Teams(Team1, Team2).subscribe((req) => {                 //Get the teams
          console.log(req);

          if (res.status == "success") {
            Team1 = req.teams[0].name;
            let Team1pic = req.teams[0].teamLogo;

            Team2 = req.teams[1].name;
            let Team2pic = req.teams[1].teamLogo;

            this.tournament.final.teamA = Team1;
            this.tournament.final.picA = Team1pic;

            this.tournament.final.scoreA = res.data.rounds[3].matches[0].teamA.points


            this.tournament.final.teamB = Team2;
            this.tournament.final.picB = Team2pic;

            this.tournament.final.scoreB = res.data.rounds[3].matches[0].teamB.points;
          }
          else
            console.log("Something went wrong with getTeam");

        });

      }


      //  

    });

  }
}
