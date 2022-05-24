import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  constructor() { }

  Print(jan):void
  {
     document.getElementById("mess").style.visibility = 'visible';
     document.getElementById("mess").innerHTML = "<p>"+jan+"</p>";
   }

   Validate() :void  // Validate that give input is valid
  {
    let  Regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;


    let mailD = document.getElementById("email") as HTMLInputElement;
    let mail = mailD.value;   //because typescript doesnt recognize getelementbyid.value
    if (mail.match(Regex)) {
    // Good job :)
      }
    else {
        document.getElementById("email").focus();
        mailD.value="";
        this.Print("Please check that your email is valid");
        return;
      }

    //   Email validated


     Regex = /^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[!@#$%^&*-]).{9,}$/;   // longer than 8, upper and lower case. 


    let passwordD = document.getElementById("Password") as HTMLInputElement;
    let password = passwordD.value;  

    if (password.match(Regex)) {
      // Good job :)
        }
      else {
        passwordD.value="";

          document.getElementById("Password").focus();
          this.Print("Please check that your Password is valid");
          return;
        }
    // Password validated.
  }

 

  ngOnInit(): void {
  }

}
