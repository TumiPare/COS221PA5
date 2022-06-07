import { Component, OnInit } from '@angular/core';
import {Component, Injectable} from '@angular/core';
export interface Standing {
   pos: number;
   team: string;
   Pld: number;
   W: number;
   D: number;
   L: number;
   GF: number;
   GA: number;
   GD: string;
   Pts: number;
}
@Component({
  selector: 'app-standings-table',
  templateUrl: './standings-table.component.html',
  styleUrls: ['./standings-table.component.css']
})
export class StandingsTableComponent implements OnInit {

  dataSource: Standing[] = [
    {pos: 3, team: "Germany", Pld: 3, W: 2, D: 0, L: 1, GF: 35, GA: 29, GD: "+6", Pts: 4},
    {pos: 3, team: "Hungary", Pld: 3, W: 2, D: 0, L: 1, GF: 38, GA: 29, GD: "+4", Pts: 4},
    {pos: 3, team: "Australia", Pld: 3, W: 2, D: 0, L: 1, GF: 32, GA: 29, GD: "+8", Pts: 4},
    {pos: 3, team: "Japan", Pld: 3, W: 0, D: 0, L: 3, GF: 35, GA: 47, GD: "18", Pts: 0},
  ];
  displayedColumns: string[] = ['pos', 'team', 'Pld', 'W','D','L','GF','GA','GD','Pts'];
  constructor() { }

  ngOnInit(): void {
  }

}
