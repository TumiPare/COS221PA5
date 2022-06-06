import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { APIService } from '../api.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {


  constructor(
    private api: APIService,
    private router: Router,
  ) { }

  ngOnInit(): void {
  }

  print(jan): void {
    document.getElementById("mess").style.visibility = 'visible';
    document.getElementById("mess").innerHTML = "<p>" + jan + "</p>";
  }

  validate(): void {  // Validate that give input is valid
    let userEmail = (<HTMLInputElement>document.getElementById("email")).value;
    let username = (<HTMLInputElement>document.getElementById("username")).value;
    let userPassword = (<HTMLInputElement>document.getElementById("password")).value;

    if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(userEmail)) {
      // Bad email
      document.getElementById("email").focus();
      this.print("Please check that your email is valid");
    } else if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$!%*?&])[A-Za-z\d@#$!%*?&]{8,}$/gm.test(userPassword)) {
      // Bad Password
      document.getElementById("password").focus();
      this.print("Please ensure that your Password is valid and correct");
    } else {
      // All validations passed
      this.api.signUpUser(username, userEmail, userPassword).subscribe((res) => {
        if (res.status == "success") {
          this.api.setAPIKey(res.data.apiKey);
          this.router.navigate([``]);
        } else {
          // Bad Email
          document.getElementById("email").focus();
          this.print(res.data.message);
        }
      });
    }
  }

  displayTooltip(): void {
    document.getElementsByClassName("bar")[0].innerHTML = "<br><p>Please enter your email and password. Ensure your password has a digit and special character</p>"
    let jan = document.getElementsByClassName("bar") as HTMLCollectionOf<HTMLElement>;
    jan[0].style.visibility = "visible";
  }

}
