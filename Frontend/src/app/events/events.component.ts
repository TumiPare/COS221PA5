import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-events',
  templateUrl: './events.component.html',
  styleUrls: ['./events.component.css']
})
export class EventsComponent implements OnInit {
  events: any;
  tournements = [{
    tournementName: "Clash of mandems",
  }, {
    tournementName: "Arabella vs Mitski",
  }, {
    tournementName: "Radloff's underlings vs World",
  }, {
    tournementName: "Me vs Radloff",
  }];

  constructor(
    private router: Router
  ) { }

  ngOnInit(): void { }

  navigateToEventPage(url: string) {
    url = url.replace(/ /g, '-');
    console.log(url);
    this.router.navigate([`${url}`]);
  }

}
