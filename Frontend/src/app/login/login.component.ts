import { Component, OnInit } from '@angular/core';
import { APIService } from '../api.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(
    private api: APIService
  ) { }

  ngOnInit(): void { }

  print(jan: string): void {
    document.getElementById("mess").style.visibility = 'visible';
    document.getElementById("mess").innerHTML = "<p>" + jan + "</p>";
  }

  validate(): void {  // Validate that give input is valid
    let userEmail = (<HTMLInputElement>document.getElementById("email")).value;
    let username = userEmail; //change this
    let userPassword = (<HTMLInputElement>document.getElementById("password")).value;

    console.log("here");
    if (!/^\S+@\S+\.\S+$/.test(userEmail)) {
      // Bad email
      document.getElementById("email").focus();
      this.print("Please check that your email is valid");
    } else if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#@$!%*?&])[A-Za-z\d#@$!%*?&]{8,}$/gm.test(userPassword)) {
      // Bad Password
      document.getElementById("password").focus();
      this.print("Please ensure that your Password is valid and correct");
    } else {
      // All validations passed
      // TODO do the login here
      this.api.ValidateUser(username, userEmail, userPassword).subscribe((res) => {
        console.log(res);

        
      });
    }
  }

  displayTooltip(): void {
    document.getElementsByClassName("bar")[0].innerHTML = "<br><p>Please enter your email and password. Ensure your password has a digit and special character</p>"
    let jan = document.getElementsByClassName("bar") as HTMLCollectionOf<HTMLElement>;
    jan[0].style.visibility = "visible";
  }

}
