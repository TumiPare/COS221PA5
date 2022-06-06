import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class APIService {
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
    })
  };
  private apiURL = 'https://api.faade.co.za/API.php';

  constructor(private http: HttpClient) { }

  signUpUser(Username: string, Email: string, Password: string): Observable<any> {
    let body = {
      type: "user",
      operation: "add",
      data: {
        username: Username,
        email: Email,
        password: Password,
      }
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  ValidateUser( Email: string, Password: string): Observable<any> {
    let body = {
      type: "user",
      operation: "login",
      data: [{
        email: Email,
        password: Password
      }]
    };
    console.log(body);
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  UpdateUser( Email: string,Username:string, Password: string,Key: string): Observable<any> {
    

    interface ExampleObject {
      [key: string]: any
  }
  let jan: ExampleObject = {};

  //Above is just to allow new attribures to be added to typescript json object. 

    
    // update email
    if(Email!="") jan.email = Email;

    if(Username!="") jan.username = Username;

    if(Password!="") jan.password = Password;

    let body = {
      apiKey: Key,
      type: "user",
      operation: "login",
      data: [jan]   // jan is a json object
    };

    console.log(body);
    return this.http.post(this.apiURL, body, this.httpOptions);
  }
}


