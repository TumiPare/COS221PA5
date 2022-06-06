import { Injectable } from '@angular/core';
import { APIService } from './api.service';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private isSignedIn = false; // TODO set to false initially
  constructor(private api: APIService) {
    this.isSignedIn = this.api.getApiKey() ? true : false;
  }

  userSignedIn(): boolean {
    return this.isSignedIn;
  }
}
