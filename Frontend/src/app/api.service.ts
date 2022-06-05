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

  signUpUser(username: string, email: string, password: string): Observable<any> {
    let body = {
      type: "user",
      operation: "add",
      data: {
        username: username,
        email: email,
        password: password,
      }
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }
}
