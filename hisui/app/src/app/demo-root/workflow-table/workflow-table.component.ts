import {Component, OnInit, ViewChild, Input, OnChanges, SimpleChange} from '@angular/core';
import {MatPaginator, MatSort, MatTableDataSource} from '@angular/material';

import { IrisWorkflowService } from '../../providers/iris-workflow.service';

@Component({
  selector: 'app-workflow-table',
  templateUrl: './workflow-table.component.html',
  styleUrls: ['./workflow-table.component.css']
})
export class WorkflowTableComponent implements OnInit {

  @Input() taskList: any[];

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  displayedColumns: string[] = ['Id', 'Subject', 'Status', 'Assigned To', 'Priority', 'Time Created', 'Action', 'Action Processor'];
  dataSource: MatTableDataSource<any>;
  showAssigned: boolean = true;
  showUnassigned: boolean = false;
  defaultFilterPredicate: any;

  constructor(private IWS: IrisWorkflowService) {
    this.dataSource = this.createDataSource([]);
  }

  ngOnInit() {
    this.initializeDataSourceProperties();
  }

  createDataSource(data: any[]): MatTableDataSource<any>{
    return new MatTableDataSource(data.map(this.addRowSelectionFields));
  }

  addRowSelectionFields(obj: any){
    return Object.assign(obj, {followUpResponse: ""});
  }

  initializeDataSourceProperties(){
    this.dataSource.paginator = this.paginator;
    this.dataSource.filterPredicate = this.customFilter;
    if(this.showAssigned){
      this.dataSource.filter = "Assigned";
    }
    if(this.showUnassigned){
      this.dataSource.filter = "Unassigned";
    }
  }

  ngOnChanges(changes: {[propKey: string]: SimpleChange}) {
    let log: string[] = [];
    for (let propName in changes) {
      let changedProp = changes[propName];
      let to = JSON.stringify(changedProp.currentValue);
      if (changedProp.isFirstChange()) {
        log.push(`Initial value of ${propName} set to ${to}`);
      } else {
        if(propName === 'taskList'){
          this.dataSource = this.createDataSource(changedProp.currentValue);
          this.initializeDataSourceProperties();
          log.push(to);
        }else{
          console.log("Something Else Changed");
        }
      }
    }
    console.log(log);
  }

  customFilter(task: any, filter: string){
    return !filter || task.status === filter;
  }

  applyFilter(filterValue: string) {
    this.dataSource.filter = filterValue.trim();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  tableFilterChange(event: any){
    this.showAssigned = false;
    this.showUnassigned = false;

    if(event.checked === true){
      if(event.source.name === "Unassigned"){
        this.showUnassigned = true;
        this.applyFilter("Unassigned");
      }else{
        this.showAssigned = true;
        this.applyFilter("Assigned");
      }
    }else{
      this.applyFilter("");
    }
  }

  processResponse(response: any): void {
    try{
      if(response && response.requestResult){
        if(response.requestResult.status === "OK"){
          this.IWS.emitChange(true);
        }else{
          this.IWS.emitChange(false);
        }
      }
    }catch(err){
      console.log("error transforming response: ", err);
      this.IWS.emitChange(false);
    }
  }

  acceptTask(row: any){
    this.IWS.assignTask(row.taskId).subscribe(res => {
      this.processResponse(res);
    },
    (err) => {
      console.log("error retrieving task data: ", err);
      this.IWS.emitChange(false);
    });
  }

  relinquishTask(row: any){
    this.IWS.unAssignTask(row.id).subscribe(res => {
      this.processResponse(res);
    },
    (err) => {
      console.log("error retrieving task data: ", err);
      this.IWS.emitChange(false);
    });
  }

  completeTask(row: any){
    this.IWS.completeTask(row.taskId, row.followUpResponse).subscribe(res => {
      this.processResponse(res);
    },
    (err) => {
      console.log("error retrieving task data: ", err);
      this.IWS.emitChange(false);
    });
  }

  isAssigned(row){
    return row.status==='Assigned';
  }

  selectionChange(event: any, row: any){
    console.log("Selection Change", event, row);
    row.followUpResponse = event.value;
  }

  selectRow(row){
    console.log("clicked Row: ", row);
  }

}
