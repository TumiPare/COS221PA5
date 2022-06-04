import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-player',
  templateUrl: './player.component.html',
  styleUrls: ['./player.component.css']
})
export class PlayerComponent implements OnInit {
  playerName: string;
  playerID: number;

  constructor(private route: ActivatedRoute,) {
    this.playerName = this.route.snapshot.paramMap.get('playerName');
    this.playerID = Number(this.route.snapshot.paramMap.get('playerID'));
  }

  ngOnInit(): void {
  }

}
