import { Component, OnInit } from '@angular/core';
import { APIService } from '../api.service';

@Component({
  selector: 'app-manage',
  templateUrl: './manage.component.html',
  styleUrls: ['./manage.component.css']
})
export class ManageComponent implements OnInit {

  constructor(
    private api: APIService
  ) { }

  print(jan: string): void {
    document.getElementById("mess").style.visibility = 'visible';
    document.getElementById("mess").innerHTML = "<p>" + jan + "</p>";
  }

  Setter() :void  // Validate that give input is valid
  {

    let Password =  (<HTMLInputElement>document.getElementById("password")).value;
    let check = (<HTMLInputElement>document.getElementById("cpassword")).value;

    if(Password!=check)   // confirm password wrong
    {
      this.print("Password and confirmation do not match")
      return;
    }

    let Email = (<HTMLInputElement>document.getElementById("email")).value;
    let Username = (<HTMLInputElement>document.getElementById("username")).value;
    let Key = sessionStorage.getItem("apiKey");

    //Check for is empty
  {  // Entire bracket to check if user just deletes values because oxygen commit no reach lungs
    if(Email=="")
    {
      this.print("You must have an email");
      return;
    }

    if(Password=="")
    {
      this.print("Please enter your current or new password");
      return;
    }

    if(Username=="")
    {
      this.print("Please enter your username");
      return;
    }
  }

  //Did not change email
  if(Email == sessionStorage.getItem("email")) Email = "";  //Refer to UpdateUser in api.service

  if(Username == sessionStorage.getItem("username")) Username = "";  //Refer to UpdateUser in api.service



  if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(Email)) {
    // Bad email
    document.getElementById("email").focus();
    this.print("Please check that your email is valid");
  } else if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/gm.test(Password)) {
    // Bad Password
    document.getElementById("password").focus();
    this.print("Please ensure that your Password is valid and correct");
  } 
  
  else {

  this.api.UpdateUser( Email, Username,Password,Key).subscribe((res) => {
    console.log(res);


    if(res.status=="success")
    {
      sessionStorage.setItem("username",res.username);
      sessionStorage.setItem("email",res.email);
      sessionStorage.setItem("apiKey",res.apiKey);
      this.print("Account succesfully updated");
    }
    else
      if(res.status=="failed")
      {
        // do something
      }
    else
    this.print("Something went wrong");
    

    });
  }
  }
  

  ngOnInit(): void {

    (<HTMLInputElement>document.getElementById("email")).value = sessionStorage.getItem("email");
    (<HTMLInputElement>document.getElementById("username")).value = sessionStorage.getItem("username");

    


    document.getElementById("Deleteimg").onclick = () =>
    {
      if(confirm('Are you sure you want to delete this account? This decision is permanent'))
      {
        let Key = sessionStorage.getItem("apiKey");
        this.api.DeleteUser(Key).subscribe((res) => {
          console.log(res);
      
      
          if(res.status=="success")
          {
            alert("account deleted");
            window.location.replace("https://faade.co.za/login");
          }
          else
          this.print("Something went wrong");
          
      
          });
      }
      else
      return;
    
    }
  }

  

}
