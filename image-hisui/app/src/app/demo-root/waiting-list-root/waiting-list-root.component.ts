import { Component, OnInit, AfterViewInit } from '@angular/core';

import {IrisPatientService, EMRUser, UserSearchRequest, DischargeRequest} from '../../providers/iris-patient.service';
import { IrisWorkflowService } from '../../providers/iris-workflow.service';

import {MatDialog} from '@angular/material';

import {LaceDefinitionModalComponent} from '../lace-definition-modal/lace-definition-modal.component';
import {UserDischargeModalComponent} from '../user-discharge-modal/user-discharge-modal.component';

@Component({
  selector: 'app-waiting-list-root',
  templateUrl: './waiting-list-root.component.html',
  styleUrls: ['./waiting-list-root.component.css']
})
export class WaitingListRootComponent implements OnInit {

  currentlySelectedUser: EMRUser = this.IPS.getEmpyUser();
  patientList: EMRUser[] = [];

  /*Binding any methods that are shared with children so they may be called in the parent context*/
  sharedLACEDialogOpen = this.openLACEDialog.bind(this);
  sharedDischargeDialogOpen = this.openDischargeDialog.bind(this);
  sharedGetAdmissions = this.getAdmissions.bind(this);
  sharedDischargePatient = this.clearDischargedPatient.bind(this);

  constructor(
    private IWS: IrisWorkflowService,
    private IPS: IrisPatientService,
    private dialog: MatDialog) {
      this.getAdmissions();
      this.IPS.resetDemoEmitter.subscribe(shouldReset =>{
        if(shouldReset){
          this.getAdmissions();
        }
      },
      (err) =>{
        window.alert("Error Resetting Demo");
      });
  }

  ngOnInit() {
  }

  clearDischargedPatient(encounterNumber: string): void {
    this.patientList = this.patientList.filter(rec => rec.encounterNumber !== encounterNumber);
    this.IWS.emitChange(true);
  }

  openLACEDialog(selectedUser: EMRUser): void {
    this.currentlySelectedUser = selectedUser;
    const dialogRef = this.dialog.open(LaceDefinitionModalComponent, {
      width: '600px',
      data: {patient: this.currentlySelectedUser}
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      console.log('Currently Selected User', this.currentlySelectedUser);
    });
  }

  openDischargeDialog(selectedUser): void {
    this.currentlySelectedUser = selectedUser;
    const dialogRef = this.dialog.open(UserDischargeModalComponent, {
      width: '700px',
      data: {user: this.currentlySelectedUser, discharge: this.sharedDischargePatient}
    });

    dialogRef.afterClosed().subscribe(result => {
      console.log('The dialog was closed');
      console.log('Currently Selected User', this.currentlySelectedUser);
    });
  }

  getAdmissions(): void {
    this.IPS.getAdmissions().subscribe( res =>{
          try{
            if(res && res.requestResult && res.encounters){
              if(res.requestResult.status === "OK"){
                this.patientList = res.encounters.map(this.IPS.EMRUserBuilder);
              }
            }
          }catch(err){
            console.log("error transforming encounter data: ", err);
          }
        },
        (err) => {console.log("Error Loading User List: ", err);});
  }

}
