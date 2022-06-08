import { Component, OnInit, Input } from '@angular/core';

export class Site{
  streetNo: string;
  street: string;
  city: string;
  postalCode: string;
  country: stirng;
  countryCode: string;
}
@Component({
  selector: 'app-site',
  templateUrl: './site.component.html',
  styleUrls: ['./site.component.css']
})
export class SiteComponent implements OnInit {
  @Input('sites') sites: Site[];
  constructor() { }

  ngOnInit(): void {
  }
  setSites(){

  }
}
