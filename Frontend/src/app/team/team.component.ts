import { Component, Inject, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { APIService } from '../api.service';
import { TeamMemberComponent } from '../team-member/team-member.component';

@Component({
  selector: 'app-team',
  templateUrl: './team.component.html',
  styleUrls: ['./team.component.css']
})
export class TeamComponent implements OnInit {
  teamName: string;
  teamID: number;
  matchID: number;
  TeamP: string;
  players: Array<any>;
  TeamLogo: string;
  constructor(
    private route: ActivatedRoute,
    public dialog: MatDialog,
    private api: APIService
  ) {
    this.teamName = this.route.snapshot.paramMap.get('teamName');
    this.teamID = Number(this.route.snapshot.paramMap.get('teamID'));    // Add this later
    // this.matchID = Number(this.route.snapshot.paramMap.get('matchID'));
    // this.TeamP = Number(this.route.snapshot.paramMap.get('TeamP'));



  }

  ngOnInit(): void {
    this.api.getMatch(this.matchID).subscribe((res) => {
      console.log(res);


      // let players = [{
      //   playerID: 12930293,
      //   firstName: "Peter",
      //   lastName: "Parker",
      //   image: "HFJWIwiocWOHNWJIWJwiubwjiwunW",
      // }, {
      //   playerID: 4,
      //   firstName: "not ",
      //   lastName: "Hulk",
      //   image: "HFJWIwiocWOHNWJIWJwiubwjiwunW",
      // }];

      if (res.status == "success") {
        if (this.TeamP == "A")
          this.players = res.match.teamA.players;
        else
          this.players = res.match.teamB.players;
      }
      else
        console.log("Something went wrong with get Match api");
    });

    this.api.getTeam(this.teamID).subscribe((res) => {
      console.log(res);
      
      this.TeamLogo = res.teams[0].teamLogo;


    });


  }

  addPlayer(): void {
    const dialogRef = this.dialog.open(AddMemberDialog, {
      width: '300px',
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
    });
  }

}

@Component({
  selector: 'add-team-member-dialog',
  templateUrl: 'add-team-member-dialog.html',
})
export class AddMemberDialog implements OnInit {
  @ViewChild('playerName') name;
  @ViewChild('playerSurname') surname;
  @ViewChild('DOB') DOB;
  @ViewChild('csvInput') upload;
  playerPic: string;



  constructor(
    public dialogRef: MatDialogRef<AddMemberDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    console.log(data);
  }

  ngOnInit(): void {
  }

  csvInputChange(fileInputEvent: any) {
    this.readFile(fileInputEvent.target.files[0]);
  }

  readFile(file: any) {
    // https://jsfiddle.net/Abeeee/0wxeugrt/9/ reference
    this.processfile(file);
    this.upload.nativeElement.value = '';
  }

  processfile(file) {
    // read the files
    var reader = new FileReader();
    reader.readAsArrayBuffer(file);
    let thissy = this;

    reader.onload = function (event) {
      // blob stuff
      var blob = new Blob([event.target.result]); // create blob...
      window.URL = window.URL || window.webkitURL;
      var blobURL = window.URL.createObjectURL(blob); // and get it's URL

      // helper Image object
      var image = new Image();
      image.src = blobURL;
      //preview.appendChild(image); // preview commented out, I am using the canvas instead
      image.onload = () => {
        // have to wait till it's loaded
        let resized = thissy.resizeMe(image); // send it to canvas
        thissy.playerPic = resized;
        let newinput = document.createElement("input");
        newinput.type = 'hidden';
        newinput.name = 'images[]';
        newinput.value = resized; // put result from canvas into new hidden input
        document.getElementById('dialogContent').appendChild(newinput);
      }
    };
  }

  resizeMe(img) {
    let max_width = 250;
    let max_height = 250;
    var canvas = document.createElement('canvas');

    var width = img.width;
    var height = img.height;

    // calculate the width and height, constraining the proportions
    if (width > height) {
      if (width > max_width) {
        //height *= max_width / width;
        height = Math.round(height *= max_width / width);
        width = max_width;
      }
    } else {
      if (height > max_height) {
        //width *= max_height / height;
        width = Math.round(width *= max_height / height);
        height = max_height;
      }
    }

    // resize the canvas and draw the image data into it
    canvas.width = width;
    canvas.height = height;
    var ctx = canvas.getContext("2d");
    ctx.drawImage(img, 0, 0, width, height);

    document.getElementById('dialogContent').appendChild(canvas); // do the actual resized preview
    return canvas.toDataURL("image/jpeg", 0.7); // get the data from canvas as 70% JPG (can be also PNG, etc.)
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  editMember() {
    // Set the appropriate data variables to whatever changes i guess
    this.api.editPlayer(this.data.memberID, this.name.nativeElement.value, this.surname.nativeElement.value, this.DOB.nativeElement.value, this.playerPic).subscribe((res) => {
      if (res.status == "success") {
        this.dialogRef.close(this.data);
      } else {
        // Error
        console.log(res);
      }
    });
  }

}