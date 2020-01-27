import { Component, OnInit } from '@angular/core';

import { IrisWorkflowService } from '../../providers/iris-workflow.service';

/*Chart Imports*/
import { colorSets } from '@swimlane/ngx-charts/release/utils/color-sets';
import { formatLabel } from '@swimlane/ngx-charts/release/common/label.helper.js';

@Component({
  selector: 'app-workflow-root',
  templateUrl: './workflow-root.component.html',
  styleUrls: ['./workflow-root.component.css']
})
export class WorkflowRootComponent implements OnInit {

  /*Start of Chart Specific Properties*/
  view: any[];
  width: number = 300;
  height: number = 300;
  chartLabel: string = "Total Tasks"
  results: any[] = []
  animations: boolean = true;
  gradient = false;
  tooltipDisabled = false;
  colorScheme: any;
  colorSets: any;
  selectedColorScheme: string;
  /*End of Chart SpecificProperties*/
  taskList: any;
  GRAPHDATA: any = {
    assigned: 0,
    unassigned: 0
  }

  constructor(private IWS: IrisWorkflowService) {
    Object.assign(this, {colorSets});
    this.setColorScheme('cool');
    this.getTaskData();

    this.IWS.workflowChangeEmitter.subscribe(shouldLoadTasks => {
      if(shouldLoadTasks){
        this.clearGraphData();
        this.getTaskData();
      }
    },
    (err) => {
      console.log(err);
    });
  }

  ngOnInit() {
    this.applyDimensions();
  }

  applyDimensions(): void {
    this.view = [this.width, this.height];
  }

  applyGraphResults(): void {
    this.results = [
      {
        name: "Assigned",
        value: this.GRAPHDATA.assigned
      },
      {
        name: "Unassigned",
        value: this.GRAPHDATA.unassigned
      }
    ]
  }

  clearGraphData(): void{
    this.GRAPHDATA.assigned = 0;
    this.GRAPHDATA.unassigned = 0;
  }

  pieTooltipText({ data }) {
    const label = formatLabel(data.name);
    const val = formatLabel(data.value);

    return `
      <span class="tooltip-label">${label}</span>
      <span class="tooltip-val">${val}</span>
    `;
  }

  setColorScheme(name) {
    this.selectedColorScheme = name;
    this.colorScheme = this.colorSets.find(s => s.name === name);
  }

  onChartSelect(event) {
    console.log('Item clicked', event);
  }

  getTaskData(){
    this.IWS.getTasks().subscribe(res => {
      try{
        if(res && res.requestResult && res.tasks){
          if(res.requestResult.status === "OK"){
            console.log(res.tasks);
            this.configureGraphData(res.tasks);
            this.taskList = res.tasks;
            //this.patientList = res.encounters.map(this.IPS.EMRUserBuilder).sort(this.admissionSort);
          }
        }
      }catch(err){
        console.log("error transforming task data: ", err);
      }
    },
    (err) => {
      console.log("error retrieving task data: ", err);
    });
  }

  configureGraphData(taskData: any[]){
    taskData.forEach((task, index, arrayRef) => {
      if(task.status === "Assigned"){
        this.GRAPHDATA.assigned += 1
      }
      if(task.status === "Unassigned"){
        this.GRAPHDATA.unassigned += 1
      }
    });

    console.log(this.GRAPHDATA);
    this.applyGraphResults();
  }
}
