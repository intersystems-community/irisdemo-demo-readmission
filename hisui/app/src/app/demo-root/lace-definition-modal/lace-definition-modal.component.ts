import { Component, OnInit, Inject } from '@angular/core';

import { EMRUser } from '../../providers/iris-patient.service';
import { PatientCensusUtilityService } from '../../providers/patient-census-utility.service';

import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

export interface DialogData {
  patient: EMRUser;
}

@Component({
  selector: 'app-lace-definition-modal',
  templateUrl: './lace-definition-modal.component.html',
  styleUrls: ['./lace-definition-modal.component.css']
})
export class LaceDefinitionModalComponent implements OnInit {

  patient: EMRUser;
  hasError: boolean = false;
  isLoading: boolean = false;

  constructor(
    private PCUS: PatientCensusUtilityService,
    public dialogRef: MatDialogRef<LaceDefinitionModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {
        this.patient = Object.assign( Object.create( Object.getPrototypeOf(data.patient)), data.patient)
    }

  ngOnInit() {
  }
}
