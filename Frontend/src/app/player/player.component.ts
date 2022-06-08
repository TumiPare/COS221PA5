import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { Router } from '@angular/router';

import { APIService } from '../api.service';

@Component({
  selector: 'app-player',
  templateUrl: './player.component.html',
  styleUrls: ['./player.component.css']
})
export class PlayerComponent implements OnInit {
  playerName: string;
  playerID: number;
  player: {
    "playerID": 3453545,
    fullName: string,
    gender: string,
    DOB: string,
    country: string,
    countryCode: string,
    image: string,
    stats: Array<{}>,
  };
  offenseStats: Array<{
    statistic: string,
    value: number | string
  }> = [];
  defenceStats: Array<{
    statistic: string,
    value: number | string
  }> = [];
  foulStats: Array<{
    statistic: string,
    value: number | string
  }> = [];

  constructor(private route: ActivatedRoute,
    private api: APIService, private router: Router,
    public dialog: MatDialog,) {
    this.playerName = this.route.snapshot.paramMap.get('playerName');
    this.playerID = Number(this.route.snapshot.paramMap.get('playerID'));
  }

  ngOnInit(): void {
    this.api.getPlayer(this.playerID).subscribe((res) => {
      console.log(res);
      if (res.status == "success") {
        console.log(res.data[0]);
        this.player = res.data[0];

        console.log(res.data[0].stats.offensive);
        let thissy = this;

        // thissy.offenseStats = result;
        console.log(Object.keys(res.data[0].stats.offensive));

        // Replace this.player with this.player.stats.appropriateStat
        Object.keys(res.data[0].stats.offensive).map(function (key, index) {

          let jan = Object.keys(res.data[0].stats.offensive);
          let san = Object.values(res.data[0].stats.offensive)
          thissy.offenseStats.push({ statistic: jan[index], value: san[index] as any });
        });
        console.log(thissy.offenseStats);

        Object.keys(res.data[0].stats.defensive).map(function (key, index) {
          let jan = Object.keys(res.data[0].stats.defensive);
          let san = Object.values(res.data[0].stats.defensive)
          thissy.defenceStats.push({ statistic: jan[index], value: san[index] as any });
        });
        Object.keys(res.data[0].stats.fouls).map(function (key, index) {
          let jan = Object.keys(res.data[0].stats.fouls);
          let san = Object.values(res.data[0].stats.fouls)
          thissy.foulStats.push({ statistic: jan[index], value: san[index] as any });
        });

        // console.log(res.data[0].statistic);

      } else {
        console.log("Error fetching player");
      }
    });
  }

  displayEdit1() {
    if (document.getElementById('OffenceHover').style.display == "none")
      document.getElementById('OffenceHover').style.display = "block";
    else
      document.getElementById('OffenceHover').style.display = "none";
  }
  open1() {
    const dialogRef = this.dialog.open(EditOffenceDialog, { width: '300px' });
  }

  displayEdit2() {
    console.log("hvered pver");
    if (document.getElementById('DefenceHover').style.display == "none")
      document.getElementById('DefenceHover').style.display = "block";
    else
      document.getElementById('DefenceHover').style.display = "none";
    // if(event.)
  }

  open2() {
    const dialogRef = this.dialog.open(EditDefenceDialog, { width: '300px' });
  }
  displayEdit3() {
    console.log("hvered pver");
    if (document.getElementById('FoulHover').style.display == "none")
      document.getElementById('FoulHover').style.display = "block";
    else
      document.getElementById('FoulHover').style.display = "none";
    // if(event.)
  }

  open3() {
    const dialogRef = this.dialog.open(EditFoulDialog, { width: '300px' });
  }
  KillPlayer() {
    this.api.DeletePlayer(this.playerID).subscribe((res) => {
      if (res.status == "success") {
        console.log(res);
        alert("Player succesfully deleted");
        this.router.navigate([``]);
      }
      else {
        alert("Delete failed");
      }

    });
  }

  UpdateStats() {
    this.api.DeletePlayer(this.playerID).subscribe((res) => {
      if (res.status == "success") {
        console.log(res);
        alert("Player stats updated");
      }
      else {
        alert(res.error.message);
      }

    });
  }
}

@Component({
  selector: 'edit-offence-dialog',
  templateUrl: 'edit-offence-dialog.html',
  styleUrls: ['./player.component.css']
})
export class EditOffenceDialog implements OnInit {
  @ViewChild('playerName') name;
  @ViewChild('playerSurname') surname;
  @ViewChild('DOB') DOB;
  @ViewChild('csvInput') upload;
  playerPic: string;

  constructor(
    public dialogRef: MatDialogRef<EditOffenceDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    console.log(data);
  }

  ngOnInit(): void {
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  editStat() {
    // Set the appropriate data variables to whatever changes i guess
    this.dialogRef.close(this.data);
  }

}

@Component({
  selector: 'edit-defence-dialog',
  templateUrl: 'edit-defence-dialog.html',
  styleUrls: ['./player.component.css']
})
export class EditDefenceDialog implements OnInit {
  @ViewChild('playerName') name;
  @ViewChild('playerSurname') surname;
  @ViewChild('DOB') DOB;
  @ViewChild('csvInput') upload;
  playerPic: string;

  constructor(
    public dialogRef: MatDialogRef<EditDefenceDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    console.log(data);
  }

  ngOnInit(): void {
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  editStat() {
    // Set the appropriate data variables to whatever changes i guess
    this.dialogRef.close(this.data);
  }

}

@Component({
  selector: 'edit-foul-dialog',
  templateUrl: 'edit-foul-dialog.html',
  styleUrls: ['./player.component.css']
})
export class EditFoulDialog implements OnInit {
  @ViewChild('playerName') name;
  @ViewChild('playerSurname') surname;
  @ViewChild('DOB') DOB;
  @ViewChild('csvInput') upload;
  playerPic: string;

  constructor(
    public dialogRef: MatDialogRef<EditFoulDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    console.log(data);
  }

  ngOnInit(): void {
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  editStat() {
    // Set the appropriate data variables to whatever changes i guess
    this.dialogRef.close(this.data);
  }

}