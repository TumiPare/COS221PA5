import { Component, Inject, Input, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { APIService } from '../api.service';
import { UserService } from '../user.service';

@Component({
  selector: 'app-team-member',
  templateUrl: './team-member.component.html',
  styleUrls: ['./team-member.component.css']
})
export class TeamMemberComponent implements OnInit {
  @Input('player') player: {
    playerID: number,
    firstName: string,
    lastName: string,
    image: string
  };
  @ViewChild('editButton') editButton;

  constructor(
    private userService: UserService,
    public dialog: MatDialog,
    private router: Router,
  ) { }

  ngOnInit(): void {
    // after all the data is fetched from the api
    // use userService to see if one can edit the team logo/name
  }

  navigateToPlayerPage() {
    //replace player_Name with actual player_name
    console.log("navigate clicked");
    this.router.navigate([`player/${this.player.playerID}/Player_name`]);
  }

  displayEdit() {
    if (this.userService.userSignedIn()) {
      if (this.editButton.nativeElement.style.display == "none")
        this.editButton.nativeElement.style.display = "block";
      else
        this.editButton.nativeElement.style.display = "none";
    }
  }

  editMember() {
    console.log("edit clicked");
    const dialogRef = this.dialog.open(EditMemberDialog, {
      width: '300px',
      data: { memberID: this.player.playerID }
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      console.log("Reciebed: ", result);
    });
  }
}

@Component({
  selector: 'edit-team-member-dialog',
  templateUrl: 'edit-team-member-dialog.html',
})
export class EditMemberDialog {
  @ViewChild('playerName') name;
  @ViewChild('playerSurname') surname;
  @ViewChild('DOB') DOB;
  @ViewChild('csvInput') upload;
  playerPic: string;

  constructor(
    public dialogRef: MatDialogRef<EditMemberDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    console.log(data);
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