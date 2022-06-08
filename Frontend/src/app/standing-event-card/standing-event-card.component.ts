import { Component, Input, OnInit } from '@angular/core';
import {Event} from 'src/app/tournement/event'
@Component({
  selector: 'app-standing-event-card',
  templateUrl: './standing-event-card.component.html',
  styleUrls: ['./standing-event-card.component.css']
})
export class StandingEventCardComponent implements OnInit {
  @Input('event') event: Event;
  
  constructor() { }

  ngOnInit(): void {
  }

}
