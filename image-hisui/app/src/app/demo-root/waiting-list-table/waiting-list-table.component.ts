import { Component, OnInit, ViewChild, Input, SimpleChange } from '@angular/core';

import {IrisPatientService, EMRUser} from '../../providers/iris-patient.service';
import {PatientCensusUtilityService} from '../../providers/patient-census-utility.service';

import {MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

@Component({
  selector: 'app-waiting-list-table',
  templateUrl: './waiting-list-table.component.html',
  styleUrls: ['./waiting-list-table.component.css']
})
export class WaitingListTableComponent implements OnInit {

  @Input() patientList: EMRUser[];
  @Input() laceDialogOpen: any;
  @Input() dischargeDialogOpen: any;

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  displayedColumns: string[] = ['patientName', 'Age/Sex/DOB', 'mrn', 'admissionDate', 'los', 'laceScoreAggregate', 'readmissionProbability'];
  dataSource: MatTableDataSource<EMRUser>;

  constructor(
    private IPS: IrisPatientService,
    private PCUS: PatientCensusUtilityService
  ) {
    this.dataSource = new MatTableDataSource(this.patientList);
  }

  openLACEDialog(row: any) {
    console.log(row)
    this.laceDialogOpen(row);
  }

  openDischargeDialog(row: any) {
    console.log(row)
    this.dischargeDialogOpen(row);
  }

  ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    for (let propName in changes) {
      let changedProp = changes[propName];
      let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        //log.push(`Initial value of ${propName} set to ${to}`);
      } else {
        if(propName === 'patientList'){
          this.dataSource = new MatTableDataSource(changedProp.currentValue);
          this.dataSource.sort = this.sort;
          this.dataSource.paginator = this.paginator;
          log.push(to);
        }else{
          console.log("Something Else Changed");
        }
      }
    }
    //console.log(log);
  }

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  selectLACEColumn(event, row){
    console.log("clicked Row: ", row);
    event.stopPropagation();
    this.laceDialogOpen(row);
  }

  selectRow(row){
    console.log("clicked Row: ", row);
    this.dischargeDialogOpen(row);
  }
}
