import { Component, Input, OnInit } from '@angular/core';
import { Event } from 'src/app/tournement/event'
@Component({
  selector: 'tournament-card',
  templateUrl: './tournament-card.component.html',
  styleUrls: ['./tournament-card.component.css']

})
export class TournamentCardComponent implements OnInit {
  @Input('event') event: any;

  constructor() { }

  ngOnInit(): void {
    console.log(this.event);
  }

}
