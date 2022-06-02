import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

 
  constructor() { }

  Print(jan):void
  {
     document.getElementById("mess").style.visibility = 'visible';
     document.getElementById("mess").innerHTML = "<p>"+jan+"</p>";
   }

   Validate() :void  // Validate that give input is valid
  {
    let  Regex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;


    let mailD = (document.getElementById("email") as HTMLInputElement).value;
    if (mailD.match(Regex)) {
    // Good job :)
      }
    else {
        document.getElementById("email").focus();
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

          document.getElementById("Password").focus();
          this.Print("Please ensure that your Password is valid and correct");
          return;
        }
    // Password validated.

    //
  }

 

  ngOnInit(): void {

    document.getElementById("Helpimg").onclick = function()
    {
      document.getElementsByClassName("bar")[0].innerHTML= "<br><p>Please enter your email and password. Ensure your password has a digit and special character</p>"
      let jan = document.getElementsByClassName("bar") as HTMLCollectionOf<HTMLElement>;
      jan[0].style.visibility = "visible";
    }
  }


}
