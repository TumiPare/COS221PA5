import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-team',
  templateUrl: './team.component.html',
  styleUrls: ['./team.component.css']
})
export class TeamComponent implements OnInit {
  teamName: string;
  teamID: number;

  constructor(private route: ActivatedRoute,) {
    this.teamName = this.route.snapshot.paramMap.get('teamName');
    this.teamID = Number(this.route.snapshot.paramMap.get('teamID'));
  }

  ngOnInit(): void {
  }

}
