import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { NavBarComponent } from './nav-bar/nav-bar.component';
import {CustomMaterialModule} from '../custom-material/custom-material.module';

@NgModule({
  declarations: [NavBarComponent],
  imports: [
    CommonModule,
    CustomMaterialModule
  ],
  exports: [
    NavBarComponent
  ]
})
export class TopNavModule { }
