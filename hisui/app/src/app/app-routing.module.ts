import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import {ContentContainerComponent} from './demo-root/content-container/content-container.component';
import {AdmissionRootComponent} from './demo-root/admission-root/admission-root.component';
import {WaitingListRootComponent} from './demo-root/waiting-list-root/waiting-list-root.component';

const routes: Routes = [
  {
    path: 'admissions',
    component: AdmissionRootComponent,
  },
  {
    path: 'waiting-list',
    component: WaitingListRootComponent,
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
