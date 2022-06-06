import { Component, Inject, Input, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { APIService } from '../api.service';
import { UserService } from '../user.service';

@Component({
  selector: 'app-team-member',
  templateUrl: './team-member.component.html',
  styleUrls: ['./team-member.component.css']
})
export class TeamMemberComponent implements OnInit {
  @Input('memberID') memberID: number;
  @ViewChild('editButton') editButton;

  constructor(private userService: UserService,
    public dialog: MatDialog) { }

  ngOnInit(): void {
    // after all the data is fetched from the api
    // use userService to see if one can edit the team logo/name
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
    const dialogRef = this.dialog.open(EditMemberDialog, {
      width: '250px',
      data: { memberID: this.memberID }
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

  constructor(
    public dialogRef: MatDialogRef<EditMemberDialog>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private api: APIService,
  ) {
    console.log(data);
  }

  onNoClick(): void {
    this.dialogRef.close();
  }

  editMember() {
    // Set the appropriate data variables to whatever changes i guess
    console.log(this.name.nativeElement.value);
    this.dialogRef.close(this.data);
  }

}