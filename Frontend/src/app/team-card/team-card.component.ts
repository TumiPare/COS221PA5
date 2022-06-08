import { Component, Input, OnInit } from '@angular/core';
import { APIService } from '../api.service';

@Component({
  selector: 'app-team-card',
  templateUrl: './team-card.component.html',
  styleUrls: ['./team-card.component.css']
})
export class TeamCardComponent implements OnInit {
  @Input('teamID') teamID: number;
  teamInfo: any;

  constructor(
    private api: APIService,
  ) { }

  ngOnInit(): void {
    this.api.getTeam(this.teamID).subscribe((res) => {
      console.log(res);
      this.teamInfo = res.data[0];
    });
  }

}
