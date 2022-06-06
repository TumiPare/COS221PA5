import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class APIService {
  private httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json',
      'OUR-OWN-ORIGIN': environment.production ? 'faade.co.za' : 'localhost:4200',
    })
  };
  private apiURL = 'https://api.faade.co.za/API.php';
  private apiKey: string;

  constructor(private http: HttpClient) {
    this.apiKey = this.getApiKey();
  }

  setAPIKey(apiKey: string, expiresInDays?: number): void {
    let expires = "";
    if (expiresInDays) {
      var date = new Date();
      date.setTime(date.getTime() + (expiresInDays * 24 * 60 * 60 * 1000));
      expires = "; expires=" + date.toUTCString();
    }
    document.cookie = "apiKey" + "=" + (apiKey || "") + expires + "; path=/";
  }

  getApiKey(): string {
    var nameEQ = "apiKey" + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == ' ') c = c.substring(1, c.length);
      if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
  }

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

  ValidateUser(email: string, password: string): Observable<any> {
    let body = {
      type: "user",
      operation: "login",
      data: {
        email: email,
        password: password,
      }
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  addTournament(tournName: string, lineupArr: Array<any>[8]): Observable<any> {
    let body = {
      type: "tournament",
      operation: "add",
      data: [
        {
          tournamentName: tournName,
          lineups: lineupArr,
        },
      ]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getAllTeams(): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "team",
      operation: "getAll"
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }
}
