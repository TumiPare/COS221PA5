import { Component, OnInit, Input } from '@angular/core';
import {Site} from 'src/app/site/site.component';

@Component({
  selector: 'app-site-card',
  templateUrl: './site-card.component.html',
  styleUrls: ['./site-card.component.css']
})
export class SiteCardComponent implements OnInit {
  @Input('site') site: Site;
  constructor() { }

  ngOnInit(): void {
  }

}
