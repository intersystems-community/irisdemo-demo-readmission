import { Component, OnInit } from '@angular/core';
import { IrisWorkflowService } from '../../providers/iris-workflow.service';

@Component({
  selector: 'app-content-container',
  templateUrl: './content-container.component.html',
  styleUrls: ['./content-container.component.css']
})
export class ContentContainerComponent implements OnInit {

  constructor(private IWS: IrisWorkflowService) { }

  ngOnInit() {
  }

  onTabChange(event: any): void {
    if(event && event.tab && event.tab.textLabel === "Workflow"){
      this.IWS.emitChange(true);
    }
  }
}
