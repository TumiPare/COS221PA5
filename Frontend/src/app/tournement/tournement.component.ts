import { Component, OnInit } from '@angular/core';
import {Tournament} from './tournament'
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
  constructor(private route: ActivatedRoute,
    private api: APIService
  ) { 
    this.tournamentName = this.route.snapshot.paramMap.get('tournementName');
    this.tournamentID = Number(this.route.snapshot.paramMap.get('tournementID'));
  }

  ngOnInit(): void {
  }

  setTournament(tournament: Tournament){
    this.tournament = tournament;


    this.api.getTournament(this.tournamentID).subscribe((res) => {
      console.log(res);

     

      for(let i = 0; i<8;i++)
      {
         let Team1  =  res.data[0].tournament.rounds[0].matches[i].teamA.teamID;
         let Team2  =  res.data[0].tournament.rounds[0].matches[i].teamB.teamID;


         this.api.get2Teams(Team1,Team2).subscribe((res) => {                 //Get the teams
          console.log(res);

          if(res.status=="success")
          {
            Team1 = res.teams[0].name;
            let Team1pic = res.teams[0].teamLogo;

            Team2 = res.teams[1].name;
            let Team2pic = res.teams[1].teamLogo;

            tournament.roundof16[i].teamA  =  Team1;
            tournament.roundof16[i].picA  =  Team1pic;

            tournament.roundof16[i].scoreA  =  res.data[0].rounds[0].matches[i].teamA.points;

   
            tournament.roundof16[i].teamB  =  Team2;
            tournament.roundof16[i].picB  =  Team2pic;

            tournament.roundof16[i].scoreB  =  res.data[0].rounds[0].matches[i].teamB.points;
          }
          else
          console.log("Something went wrong with getTeam");
        
         });
      }


      for(let i = 0; i<4;i++)
      {

        let Team1  =  res.data[0].tournament.rounds[1].matches[i].teamA.teamID;
        let Team2  =  res.data[0].tournament.rounds[1].matches[i].teamB.teamID;


        this.api.get2Teams(Team1,Team2).subscribe((res) => {                 //Get the teams
         console.log(res);

         if(res.status=="success")
         {
           Team1 = res.teams[0].name;
           let Team1pic = res.teams[0].teamLogo;

           Team2 = res.teams[1].name;
           let Team2pic = res.teams[1].teamLogo;

           tournament.roundof16[i].teamA  =  Team1;
           tournament.roundof16[i].picA  =  Team1pic;

           tournament.roundof16[i].scoreA  =  res.data[0].rounds[1].matches[i].teamA.points;

  
           tournament.roundof16[i].teamB  =  Team2;
           tournament.roundof16[i].picB  =  Team2pic;

           tournament.roundof16[i].scoreB  =  res.data[0].rounds[1].matches[i].teamB.points;
         }
         else
         console.log("Something went wrong with getTeam");
       
        });

      }

      for(let i = 0; i<2;i++)
      {

        let Team1  =  res.data[0].tournament.rounds[2].matches[i].teamA.teamID;
        let Team2  =  res.data[0].tournament.rounds[2].matches[i].teamB.teamID;


        this.api.get2Teams(Team1,Team2).subscribe((res) => {                 //Get the teams
         console.log(res);

         if(res.status=="success")
         {
           Team1 = res.teams[0].name;
           let Team1pic = res.teams[0].teamLogo;

           Team2 = res.teams[1].name;
           let Team2pic = res.teams[1].teamLogo;

           tournament.roundof16[i].teamA  =  Team1;
           tournament.roundof16[i].picA  =  Team1pic;

           tournament.roundof16[i].scoreA  =  res.data[0].rounds[2].matches[i].teamA.points;

  
           tournament.roundof16[i].teamB  =  Team2;
           tournament.roundof16[i].picB  =  Team2pic;

           tournament.roundof16[i].scoreB  =  res.data[0].rounds[2].matches[i].teamB.points;
         }
         else
         console.log("Something went wrong with getTeam");
       
        });

      }


      {

        let Team1  =  res.data[0].tournament.rounds[3].matches[0].teamA.teamID;
        let Team2  =  res.data[0].tournament.rounds[3].matches[0].teamB.teamID;


        this.api.get2Teams(Team1,Team2).subscribe((res) => {                 //Get the teams
         console.log(res);

         if(res.status=="success")
         {
           Team1 = res.teams[0].name;
           let Team1pic = res.teams[0].teamLogo;

           Team2 = res.teams[1].name;
           let Team2pic = res.teams[1].teamLogo;

           tournament.roundof16[0].teamA  =  Team1;
           tournament.roundof16[0].picA  =  Team1pic;

           tournament.roundof16[0].scoreA  =  res.data[0].rounds[3].matches[0].teamA.points

  
           tournament.roundof16[0].teamB  =  Team2;
           tournament.roundof16[0].picB  =  Team2pic;

           tournament.roundof16[0].scoreB  =  res.data[0].rounds[3].matches[0].teamB.points;
         }
         else
         console.log("Something went wrong with getTeam");
       
        });

      }




    });


    
    
  }
}
