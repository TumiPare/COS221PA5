import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-team-member',
  templateUrl: './team-member.component.html',
  styleUrls: ['./team-member.component.css']
})
export class TeamMemberComponent implements OnInit {
  @Input('memberID') memberID: number;

  constructor() { }

  ngOnInit(): void {
  }

}
