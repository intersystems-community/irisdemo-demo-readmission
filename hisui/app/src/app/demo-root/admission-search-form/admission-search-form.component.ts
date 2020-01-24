import { Component, OnInit, Input } from '@angular/core';

import {UserSearchRequest} from '../../providers/iris-patient.service';


@Component({
  selector: 'app-admission-search-form',
  templateUrl: './admission-search-form.component.html',
  styleUrls: ['./admission-search-form.component.css']
})
export class AdmissionSearchFormComponent implements OnInit {

  @Input() userSearchRequest: UserSearchRequest;
  @Input() searchPatients: any;

  constructor() {

  }

  ngOnInit() {
    
  }

  submit(){
    console.log("submitting");
    this.searchPatients();
  }

  // TODO: Remove this when we're done
  get diagnostic() { return JSON.stringify(this.userSearchRequest); }

}
