import { Component, OnInit } from '@angular/core';
import {Tournament} from './tournament'
@Component({
  selector: 'app-tournement',
  templateUrl: './tournement.component.html',
  // templateUrl: '<tournament-card></tournament-card>',
  styleUrls: ['./tournement.component.css']
})
export class TournementComponent implements OnInit {
  tournament: Tournament;
  constructor() { }

  ngOnInit(): void {
  }

  setTournament(tournament: Tournament){
    this.tournament = tournament;
  }
}
