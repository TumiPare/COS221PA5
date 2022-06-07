import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { APIService } from '../api.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor(
    private api: APIService,
    private router: Router,
  ) { }

  ngOnInit(): void { }

  print(jan: string): void {
    document.getElementById("mess").style.visibility = 'visible';
    document.getElementById("mess").innerHTML = "<p>" + jan + "</p>";
  }

  validate(): void {  // Validate that give input is valid
    let userEmail = (<HTMLInputElement>document.getElementById("email")).value;
    let userPassword = (<HTMLInputElement>document.getElementById("password")).value;

    console.log("here");
    if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(userEmail)) {
      // Bad email
      document.getElementById("email").focus();
      this.print("Please check that your email is valid");
    } else if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/gm.test(userPassword)) {
      // Bad Password
      document.getElementById("password").focus();
      this.print("Please ensure that your Password is valid and correct");
    } else {
      // All validations passed
      // TODO do the login here
      this.api.ValidateUser(userEmail, userPassword).subscribe((res) => {
        console.log(res);
        if (res.status == "success") { // Login succesfull
          sessionStorage.setItem('username', res.data[0].username);
          sessionStorage.setItem('email', res.data[0].email);
          sessionStorage.setItem('apiKey', res.data[0].apiKey);
          this.api.setAPIKey(res.data[0].apiKey);
          //Transistion to home page
          this.router.navigate([``]);
        } else { // FAILED
          if (res.error.code == "invalid_email") { // email
            this.print("Please ensure that your email is valid ")
            document.getElementById("email").focus();
          }
          else if (res.error.code == "invalid_password") {  // password
            this.print("Please ensure that your password is correct")
            document.getElementById("password").focus();
          }
          else
            this.print("Something went wrong, please try again");
        }
      });
    }
  }

  displayTooltip(): void {
    document.getElementsByClassName("bar")[0].innerHTML = "<br><p>Please enter your email and password. Ensure your password has a digit and special character and has at least 8 chars</p>"
    let jan = document.getElementsByClassName("bar") as HTMLCollectionOf<HTMLElement>;
    jan[0].style.visibility = "visible";
  }

}
