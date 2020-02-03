import { Component, OnInit, Inject } from '@angular/core';

import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

/*Providers*/
import { NgxSpinnerService } from 'ngx-spinner';
import {IrisPatientService, EMRUser, DischargeRequest} from '../../providers/iris-patient.service';
import {PatientCensusUtilityService} from '../../providers/patient-census-utility.service';
import {IrisMlService} from '../../providers/iris-ml.service';

export interface DialogData {
  user: EMRUser;
  discharge: any;
  treatment: number;
}

@Component({
  selector: 'app-user-discharge-modal',
  templateUrl: './user-discharge-modal.component.html',
  styleUrls: ['./user-discharge-modal.component.css']
})
export class UserDischargeModalComponent implements OnInit {

  patient: EMRUser;
  allowDischarge: boolean;
  hasError: boolean;
  laceStatusColor: string;
  mlStatusColor: string;

  spinnerColor: string = "primary"
  spinnerMode: string = "indeterminate"
  isLoadingProbability: boolean = false;

  /*Binding any methods that are shared with children so they may be called in the parent context*/
  sharedCareRecommendationUpdated = this.careRecommendationUpdated.bind(this);

  constructor(
    private IMLS: IrisMlService,
    private PCUS: PatientCensusUtilityService,
    private IPS: IrisPatientService,
    private spinner: NgxSpinnerService,
    public dialogRef: MatDialogRef<UserDischargeModalComponent>,
    @Inject(MAT_DIALOG_DATA) public data: DialogData) {

      /*Creating a shallow copy for editing in the dialog while still Keeping it as the correct class type*/
      this.patient = Object.assign( Object.create( Object.getPrototypeOf(data.user)), data.user)
      this.allowDischarge = this.patient.encounterStatus !== "D";
      this.laceStatusColor = PCUS.getLACERiskStatusColor(this.patient.laceScoreAggregate);
      this.mlStatusColor = PCUS.getMLRiskStatusColor(PCUS.getReadmissionPercentage(this.patient.readmissionProbability));
  }

  ngOnInit() {}

  onNoClick(): void {
    this.dialogRef.close();
  }

  dischargePatient(): void {
    console.log("dischargingPatient: ", this.patient);
    this.hasError = false;

    const dischargeRequest = new DischargeRequest(
      this.patient.firstName,
      this.patient.lastName,
      this.patient.MRN,
      this.patient.encounterId,
      this.patient.dischargeDestination);

    this.IPS.dischargePatient(dischargeRequest).subscribe(res => {
      try{
        this.spinner.show();
        setTimeout(() => { /*Adding in so dischrge spinner can display to users*/
          this.spinner.hide();
          if(res && res.requestResult){
            if(res.requestResult.status === "OK"){
              this.data.discharge(this.patient.encounterNumber);
              this.onNoClick();
            }else{
              this.hasError = true;
            }
          }
        }, 3000);
      }catch(err){
        this.spinner.hide();
        console.log("issue discharing error closing dialog: ", err);
        this.hasError = true;
      }
    },
    (err) => {
      console.log("Error Discharging User: ", err)
      this.hasError = true;
      this.spinner.hide();
    });
  }

  careRecommendationUpdated(event){
    let dataMapUpdates = {
      "DxDischargeLocation": event.value
    }

    if(event.value === '1'){
      this.recalculatePatientMLScore(dataMapUpdates, this.patient.encounterNumber)
    }
  }

  recalculatePatientMLScore(dataMapUpdates: any, encounterNumber: string, procedureName: string = this.IMLS.MLProcedure){
    console.log("recalculatingPatientMLScore: ", this.patient);
    this.hasError = false;

    let MLDataMap = {}
    this.isLoadingProbability = true;
    this.IMLS.getMLDataMap(encounterNumber, procedureName).subscribe(res => {
      try{
        setTimeout(() => {
          if(res && res.requestResult){
            if(res.requestResult.status === "OK"){

              MLDataMap = Object.assign(MLDataMap, res.requestResult.data.ABTData);
              this.updatePrediction(MLDataMap, dataMapUpdates)
            }else{
              this.hasError = true;
            }
          }
        }, 2000);
      }catch(err){
        console.log("Error Getting ML Data MAp", err);
        this.hasError = true;
        this.isLoadingProbability = false;
      }
    },
    (err) => {
      console.log("Error Getting ML Data MAp: ", err)
      this.hasError = true;
      this.isLoadingProbability = false;
    });
  }

  updatePrediction(originalDataMap: any, dataMapUpdates: any){

    const updatedDataMap = Object.assign(originalDataMap, dataMapUpdates);

    this.IMLS.getMLPrediction(updatedDataMap, this.IMLS.operationName).subscribe(res => {
      try{
        if(res && res.requestResult){
          if(res.requestResult.status === "OK"){
            this.patient.readmissionProbability = res.requestResult.data.prediction.probability1;
          }else{
            this.hasError = true;
          }
          this.isLoadingProbability = false;
        }
      }catch(err){
        console.log("Error Getting ML Prediction", err);
        this.hasError = true;
        this.isLoadingProbability = false;
      }
    },
    (err) => {
      console.log("Error Getting ML Prediction", err)
      this.hasError = true;
      this.isLoadingProbability = false;
    });
  }

}
