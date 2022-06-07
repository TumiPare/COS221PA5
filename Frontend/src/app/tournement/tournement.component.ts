import { Component, OnInit } from '@angular/core';
import {Tournament} from './tournament'
import { ActivatedRoute } from '@angular/router';
import { APIService } from '../api.service';

@Component({
  selector: 'app-tournement',
  templateUrl: './tournement.component.html',
  // templateUrl: '<tournament-card></tournament-card>',
  styleUrls: ['./tournement.component.css']
})
export class TournementComponent implements OnInit {
  tournament: Tournament;
  tournamentName: string;
  tournamentID: number;
  constructor(private route: ActivatedRoute,
    private api: APIService
  ) { 
    this.tournamentName = this.route.snapshot.paramMap.get('tournementName');
    this.tournamentID = Number(this.route.snapshot.paramMap.get('tournementID'));
  }

  ngOnInit(): void {
  }

}
