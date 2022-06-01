import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  private isSignedIn = true; // TODO set to false initially
  constructor() { }

  userSignedIn(): boolean {
    return this.isSignedIn;
  }
}
