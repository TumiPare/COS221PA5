import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-manage',
  templateUrl: './manage.component.html',
  styleUrls: ['./manage.component.css']
})
export class ManageComponent implements OnInit {

  constructor() { }

  Setter() :void  // Validate that give input is valid
  {

  }
  

  ngOnInit(): void {

    document.getElementById("Deleteimg").onclick = function()
    {
      if(confirm('Are you sure you want to delete this account? This decision is permanent.'))
      {
        // API request to kill account
      }
    
    }
  }

  

}
