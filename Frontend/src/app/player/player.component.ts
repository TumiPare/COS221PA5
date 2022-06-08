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
        console.log("Error fetching player");
      }
    });
  }

}
