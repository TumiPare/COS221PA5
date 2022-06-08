import { Component, OnInit } from '@angular/core';
import { APIService } from '../api.service';

@Component({
  selector: 'app-leagues',
  templateUrl: './leagues.component.html',
  styleUrls: ['./leagues.component.css']
})
export class LeaguesComponent implements OnInit {
  leagues: Array<any>;

  constructor(
    private api: APIService,
  ) { }

  ngOnInit(): void {
    this.api.getLeagues().subscribe((res) => {
      if(res.status == "success") {
        console.log(res);
        this.leagues = res.data;
      } else {
        console.log(res);
      }
    });
  }

}
