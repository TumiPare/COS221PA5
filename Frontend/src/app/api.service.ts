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
      'OUR-OWN-ORIGIN': environment.production ? 'https://faade.co.za' : 'http://localhost:4200',
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

  signUpUser(Username: string, Email: string, Password: string): Observable<any> {
    let body = {
      type: "user",
      operation: "add",
      data: [{
        username: Username,
        email: Email,
        password: Password,
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getLeagues(): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "league",
      operation: "get"
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getSubSeasons(seasonID: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "season",
      operation: "get",
      data: [{
        seasonID: seasonID,
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getTournaments(Season: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "tournament",
      operation: "get",
      data: [{
        "tournamentID": Season
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  editPlayer(playerID: number, name: string, surname: string, DOB: string, playerPic: string): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "player",
      operation: "set",
      data: [{
        "playerID": playerID,
        "firstName": name,
        "surname": surname,
        "DOB": DOB,
        "pic": playerPic,
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  ValidateUser(Email: string, Password: string): Observable<any> {
    let body = {
      type: "user",
      operation: "login",
      data: [{
        email: Email,
        password: Password
      }]
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

  get2Teams(team1: number, team2: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "team",
      operation: "get",
      data: [{
        teamID: team1
      },
      {
        teamID: team2
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }


  UpdateUser(Email: string, Username: string, Password: string, Key: string): Observable<any> {


    interface ExampleObject {
      [key: string]: any
    }
    let jan: ExampleObject = {};

    //Above is just to allow new attribures to be added to typescript json object. 


    // update email
    if (Email != "") jan.email = Email;

    // update Username
    if (Username != "") jan.username = Username;

    // update Password
    if (Password != "") jan.password = Password;

    // wont include an attribute if its value stayed the same

    let body = {
      apiKey: Key,
      type: "user",
      operation: "set",
      data: [jan]   // jan is a json object
    };

    console.log(body);
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  DeleteUser(Key: string): Observable<any> {
    let body = {
      type: "user",
      operation: "delete",
      data: [{
        apiKey: Key
      }]
    };
    console.log(body);
    return this.http.post(this.apiURL, body, this.httpOptions);
  }


  getPlayer(playerId: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "player",
      operation: "get",
      data: [{
        playerID: playerId
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getTournament(tourId: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "tournament",
      operation: "get",
      data: [{
        tournamentID: tourId
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getMatch(MatchID: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "match",
      operation: "get",
      data: [{
        matchID: MatchID
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  getTeam(TeamID: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "team",
      operation: "get",
      data: [{
        teamID: TeamID
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  DeletePlayer(PlayerID: number): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "player",
      operation: "delete",
      data: [{
        playerID: PlayerID
      }]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  UpdateStats(PlayerID: number,FirstName:string,LastName:string,DOOB:string,Image:string): Observable<any> {

    interface ExampleObject {
      [key: string]: any
    }
    let jan: ExampleObject = {};

    jan.playerID = PlayerID;
    jan.firstName = FirstName;
    jan.lastName = LastName;
    jan.DOB = DOOB;

    if (Image != "") jan.image = Image;
    let body = {
      apiKey: this.apiKey,
      type: "player",
      operation: "seet",
      data: [jan]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  AddPlayer(PlayerID: number,FirstName:string,LastName:string,Image:string,Gender:string,DOOB:string,PersonKey:string,
    StreetNo:string,Street:string,City:string,PostalCode:number,Country:string): Observable<any> {
    interface ExampleObject {
      [key: string]: any
    }
    let jan: ExampleObject = {};

    jan.playerID = PlayerID;
    jan.firstName = FirstName;
    jan.lastName = LastName;
    if (Image != "") jan.image = Image;
    jan.gender = Gender;
    jan.DOB = DOOB;
    jan.personKey = PersonKey;
    jan.birthAddr = 
    {
      streetNo: StreetNo,
      street: Street,
      city: City,
      postalCode:PostalCode,
      country:Country
    };

    let body = {
      apiKey: this.apiKey,
      type: "player",
      operation: "add",
      data: [jan]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  GetAllTeams(PlayerID: number,): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "team",
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  DeleteTeam(TeamID: number,): Observable<any> {
    let body = {
      apiKey: this.apiKey,
      type: "team",
      operation: "delete",
      data: [
        {teamID: TeamID}
      ]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }

  AddTeam(TeamID: number,TeamLogo:string,HomeSite:string,TeamName:string,PostalCode:number,Country:string): Observable<any> {
    interface ExampleObject {
      [key: string]: any
    }
    let jan: ExampleObject = {};

    jan.teamName = TeamName;
    if (TeamLogo != "") jan.teamLogo = TeamLogo;
    if (HomeSite != "") jan.homeSite = HomeSite;
  
    let body = {
      apiKey: this.apiKey,
      type: "team",
      operation: "add",
      data: [jan]
    };
    return this.http.post(this.apiURL, body, this.httpOptions);
  }











}


