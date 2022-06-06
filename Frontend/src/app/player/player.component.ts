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

  constructor(private route: ActivatedRoute,
    private api: APIService) {
    this.playerName = this.route.snapshot.paramMap.get('playerName');
    this.playerID = Number(this.route.snapshot.paramMap.get('playerID'));
  }

  ngOnInit(): void {

    let Key = sessionStorage.getItem("apiKey");
    this.api.GetPlayer(Key,this.playerID).subscribe((res) => {
      console.log(res);
  

    });
  }

}
