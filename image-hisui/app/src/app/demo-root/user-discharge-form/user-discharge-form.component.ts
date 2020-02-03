import { Component, OnInit, Input } from '@angular/core';

/*Providers*/
import {EMRUser} from '../../providers/iris-patient.service';

@Component({
  selector: 'app-user-discharge-form',
  templateUrl: './user-discharge-form.component.html',
  styleUrls: ['./user-discharge-form.component.css']
})
export class UserDischargeFormComponent implements OnInit {

  @Input() user: EMRUser;
  @Input() treatment: number;
  @Input() careRecommendationUpdated: any;

  hasHighReadmissionProbability: boolean = false;

  ctypes = [
    {value: '1', viewValue: 'Send To Nursing Facility'},
    {value: '2', viewValue: 'Schedule Follow up in 72 Hours'},
    {value: '3', viewValue: 'Give Focused Medical Education'}
  ]

  dtypes = [
    {value: 'H', viewValue: 'Home'},
    {value: 'N', viewValue: 'Skilled Nursing Facility'}
  ]

  constructor() { }

  ngOnInit() {

    this.hasHighReadmissionProbability = this.user.laceScoreAggregate >= 9 || this.user.readmissionProbability >= .15

    if(this.user.endDate === null || this.user.encounterStatus === 'A'){
      this.user.endDate = new Date();
      this.user.dischargeDestination = "H";
    }
  }

  compareFn: ((f1: any, f2: any) => boolean) | null = this.compareByValue;

  compareByValue(f1: any, f2: any) {
    return f1 && f2 && f1.toLowerCase() === f2.toLowerCase();
  }
}
