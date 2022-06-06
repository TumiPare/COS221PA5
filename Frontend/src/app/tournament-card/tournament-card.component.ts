import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'tournament-card',
  templateUrl: './tournament-card.component.html',
  styleUrls: ['./tournament-card.component.css']
  
})
export class TournamentCardComponent implements OnInit {
  @Input('teama')teamA: string;
  @Input('teamb')teamB: string;
  @Input('scorea')scoreA: number;
  @Input('scoreb')scoreB: number;
  @Input('eventnumber')eventNumber: number;
  @Input('pica')picA: string;
  @Input('picb')picB: string;
  constructor() { }

  ngOnInit(): void {
  }

}
