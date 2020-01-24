import {Component, OnInit, ViewChild, Input, OnChanges, SimpleChange} from '@angular/core';
import {MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

/*Providers*/
import {EMRUser} from '../../providers/iris-patient.service';

@Component({
  selector: 'app-admission-search-table',
  templateUrl: './admission-search-table.component.html',
  styleUrls: ['./admission-search-table.component.css']
})
export class AdmissionSearchTableComponent implements OnInit, OnChanges {

  @Input() patientList: EMRUser[];
  @Input() dialogOpen: any;

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  displayedColumns: string[] = ['Admission Number', 'Medical Record Number', 'First Name', 'Last Name', 'Date Of Birth', 'Gender', 'Admitted', 'Discharged', 'Admission Status'];
  dataSource: MatTableDataSource<EMRUser>;

  constructor() {
    this.dataSource = new MatTableDataSource(this.patientList);
  }

  ngOnInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    for (let propName in changes) {
      let changedProp = changes[propName];
      let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        log.push(`Initial value of ${propName} set to ${to}`);
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
    console.log(log);
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  selectRow(row){
    console.log("clicked Row: ", row);
    this.dialogOpen(row);
  }
}
