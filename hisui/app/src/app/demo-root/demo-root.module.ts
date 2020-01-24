import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';

import { ContentContainerComponent } from './content-container/content-container.component';

import {CustomMaterialModule} from '../custom-material/custom-material.module';
import { AdmissionRootComponent } from './admission-root/admission-root.component';
import { WaitingListRootComponent } from './waiting-list-root/waiting-list-root.component';
import { AdmissionSearchFormComponent } from './admission-search-form/admission-search-form.component';
import { AdmissionSearchTableComponent } from './admission-search-table/admission-search-table.component';
import { UserDischargeModalComponent } from './user-discharge-modal/user-discharge-modal.component';
import { LaceDefinitionModalComponent } from './lace-definition-modal/lace-definition-modal.component';
import { AnalyticsRootComponent } from './analytics-root/analytics-root.component'
/*Providers*/
import {IrisPatientService} from '../providers/iris-patient.service';

/*Uniform angualr spinners*/
import { NgxSpinnerModule } from 'ngx-spinner';
//import { ChartCommonModule } from '@swimlane/ngx-charts/release/common/chart-common.module';
//import { PieChartModule } from '@swimlane/ngx-charts/release/pie-chart/pie-chart.module';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { UserDischargeFormComponent } from './user-discharge-form/user-discharge-form.component';
import { WaitingListTableComponent } from './waiting-list-table/waiting-list-table.component';
import { WorkflowRootComponent } from './workflow-root/workflow-root.component';
import { WorkflowTableComponent } from './workflow-table/workflow-table.component';

@NgModule({
  declarations: [
    ContentContainerComponent,
    AdmissionRootComponent,
    WaitingListRootComponent,
    AdmissionSearchFormComponent,
    AdmissionSearchTableComponent,
    UserDischargeModalComponent,
    UserDischargeFormComponent,
    WaitingListTableComponent,
    AnalyticsRootComponent,
    WorkflowRootComponent,
    WorkflowTableComponent,
    LaceDefinitionModalComponent
  ],
  imports: [
    CommonModule,
    CustomMaterialModule,
    FormsModule,
    NgxSpinnerModule,
    NgxChartsModule
    //ChartCommonModule,
    //PieChartModule
  ],
  exports: [
    ContentContainerComponent,
    AdmissionRootComponent,
    WaitingListRootComponent
  ],
  providers: [IrisPatientService],
  entryComponents: [
    UserDischargeModalComponent,
    LaceDefinitionModalComponent
  ],
})
export class DemoRootModule { }
