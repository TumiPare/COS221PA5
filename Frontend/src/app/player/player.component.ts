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

        console.log(res.data[0].stats.offensive);
        let thissy = this;



          // thissy.offenseStats = result;
        console.log( Object.keys(res.data[0].stats.offensive));

        // Replace this.player with this.player.stats.appropriateStat
        Object.keys(res.data[0].stats.offensive).map(function (key,index) {
          
          let jan = Object.keys(res.data[0].stats.offensive);
          let san = Object.values(res.data[0].stats.offensive)
          thissy.offenseStats.push({ statistic: jan[index] , value : san[index] as any});
        });
        console.log(thissy.offenseStats);

        Object.keys(res.data[0].stats.defensive).map(function (key, index) {
          let jan = Object.keys(res.data[0].stats.defensive);
          let san = Object.values(res.data[0].stats.defensive)
          thissy.defenceStats.push({ statistic: jan[index] , value : san[index] as any});
        });
        Object.keys(res.data[0].stats.fouls).map(function (key, index) {
          let jan = Object.keys(res.data[0].stats.fouls);
          let san = Object.values(res.data[0].stats.fouls)
          thissy.foulStats.push({ statistic: jan[index] , value : san[index] as any});
        });

        // console.log(res.data[0].statistic);

      } else {
        console.log("Error fetching player");
      }
    });
  }

  displayEdit1() {
    console.log("hvered pver");
    // if(event.)
  }

  displayEdit2() {
    console.log("hvered pver");
    // if(event.)
  }

  displayEdit3() {
    console.log("hvered pver");
    // if(event.)
  }
}
