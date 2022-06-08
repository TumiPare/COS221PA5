import { Component, Input, OnInit } from '@angular/core';
import {Event} from 'src/app/tournement/event'
import {Standing} from 'src/app/standings-table/standings-table.component'

@Component({
  selector: 'app-standings-card',
  templateUrl: './standings-card.component.html',
  styleUrls: ['./standings-card.component.css']
})
export class StandingsCardComponent implements OnInit {
  @Input('standings') standings: Standing;
  @Input('events') events: Array<Event>[6];
  constructor() { }

  ngOnInit(): void {
  }

}
