import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { APIService } from '../api.service';


@Component({
  selector: 'app-player',
  templateUrl: './player.component.html',
  styleUrls: ['./player.component.css']
})
export class PlayerComponent implements OnInit {
  playerName: string;
  playerID: number;
  player: {
    "playerID": 3453545,
    fullName: string,
    gender: string,
    DOB: string,
    country: string,
    countryCode: string,
    image: string,
    stats: Array<{}>,
  };
  offenseStats: Array<{
    statistic: string,
    value: number | string
  }> = [];
  defenceStats: Array<{
    statistic: string,
    value: number | string
  }> = [];
  foulStats: Array<{
    statistic: string,
    value: number | string
  }> = [];

  constructor(private route: ActivatedRoute,
    private api: APIService) {
    this.playerName = this.route.snapshot.paramMap.get('playerName');
    this.playerID = Number(this.route.snapshot.paramMap.get('playerID'));
  }

  ngOnInit(): void {
    this.api.getPlayer(this.playerID).subscribe((res) => {
      if (res.status == "success") {
         console.log(res.data[0]);
        this.player = res.data[0];

        let thissy = this;
        // Replace this.player with this.player.stats.appropriateStat
        Object.keys(res.data[0].stats.offensive).map(function (key, index) {
          thissy.offenseStats.push({ statistic: key, value: index });
        });
        Object.keys(res.data[0].stats.defensive).map(function (key, index) {
          thissy.defenceStats.push({ statistic: key, value: index });
        });
        Object.keys(res.data[0].stats.fouls).map(function (key, index) {
          thissy.foulStats.push({ statistic: key, value: index });
        });
      } else {
        console.log("Error fetching player")
      }



      // let Name = res.data[0].fullName;
      // let Gender = res.data[0].gender;
      // let Birth = res.data[0].DOB;
      // let Country = res.data[0].country;
      // let Image = res.data[0].image;   //B64 encoded

      // let Assists = res.data[0].stats.offensive.assists;
      // let SprintsWon = res.data[0].stats.offensive.sprintsWon;
      // let Goals = res.data[0].stats.offensive.goals;
      // let PassesMade = res.data[0].stats.offensive.passesMade;

      // let Steals = res.data[0].stats.defensive.steals;
      // let Saves = res.data[0].stats.defensive.saves;
      // let FailedBlocks = res.data[0].stats.defensive.failedBlocks;
      // let SuccessfulPasses = res.data[0].stats.defensive.successfulPasses;

      // let Turnovers = res.data[0].stats.fouls.turnovers;
      // let Exclusions = res.data[0].stats.fouls.exclusions;
      // let PenaltyShotsTaken = res.data[0].stats.fouls.penaltyShotsTaken;
      // let PenaltyShotsGiven = res.data[0].stats.fouls.penaltyShotsGiven;

      // (<HTMLInputElement>document.getElementById("FN")).value = Name;
      // (<HTMLInputElement>document.getElementById("birth")).value = Birth;
      // (<HTMLInputElement>document.getElementById("gender")).value = Gender;
      // (<HTMLInputElement>document.getElementById("Nationality")).value = Country;

      // (<HTMLInputElement>document.getElementById("turnovers")).value = Turnovers;
      // (<HTMLInputElement>document.getElementById("exclusions")).value = Exclusions;
      // (<HTMLInputElement>document.getElementById("penaltyShotsT")).value = PenaltyShotsTaken;
      // (<HTMLInputElement>document.getElementById("penaltyShotsG")).value = PenaltyShotsGiven;

      // (<HTMLInputElement>document.getElementById("assists")).value = Assists;
      // (<HTMLInputElement>document.getElementById("sprintsWon")).value = SprintsWon;
      // (<HTMLInputElement>document.getElementById("goals")).value = Goals;
      // (<HTMLInputElement>document.getElementById("passesMade")).value = PassesMade;

      // (<HTMLInputElement>document.getElementById("steals")).value = Steals;
      // (<HTMLInputElement>document.getElementById("saves")).value = Saves;
      // (<HTMLInputElement>document.getElementById("failedBlocks")).value = FailedBlocks;
      // (<HTMLInputElement>document.getElementById("successfulPasses")).value = SuccessfulPasses;


      // (<HTMLInputElement>document.getElementById("playerPic outline")[0]).value = SuccessfulPasses;


      // // let Name = (<HTMLInputElement>document.getElementById("email")).value;


    });
  }

}
