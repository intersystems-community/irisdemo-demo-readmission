import { Injectable } from '@angular/core';

import {EMRUser} from './iris-patient.service';

@Injectable({
  providedIn: 'root'
})
export class PatientCensusUtilityService {

  constructor() { }

  getLACERiskStatusColor(lace: number): string{
    const colorMap = {
      low: 'green',
      moderate: 'yellow',
      high: 'orange',
      highest: 'red'
    }

    var risk = "low"

    if(lace <= 4) {
      risk = "low"
    } else if(lace <= 9) {
      risk = "moderate"
    } else if(lace <= 12) {
      risk = "high"
    } else {
      risk = "highest"
    }

    return colorMap[risk]

  }

  getLACERiskProbability(lace: number): number{

    var riskProbability;

    if(lace <= 4) {
      riskProbability = 3.30
    } else if(lace <= 9) {
      riskProbability = 7.90
    } else if(lace <= 12) {
      riskProbability = 14.70
    } else {
      riskProbability = 20.80
    }

    return riskProbability
  }

  getMLRiskStatusColor(probability: number): string{
    const colorMap = {
      low: 'green',
      moderate: 'yellow',
      high: 'orange',
      highest: 'red'
    }

    var risk = "low"

    if(probability <= 5.00) {
      risk = "low"
    } else if(probability <= 10.00) {
      risk = "moderate"
    } else if(probability <= 15.00) {
      risk = "high"
    } else {
      risk = "highest"
    }

    return colorMap[risk]

  }

  getReadmissionPercentage(prob: number): number{
    return (100 * prob)
  }

  getLOS(start: Date, end: Date): number{
    const ONE_DAY = 1000 * 60 * 60 * 24;

    var startTime: number = start.getTime()
    var endTime: number = end.getTime()

    var difference_ms: number = Math.abs(endTime - startTime);

    return Math.round(difference_ms/ONE_DAY);
  }

  getAge(dob: Date): number{
    const today = new Date()

    var diff =(dob.getTime() - today.getTime()) / 1000;

    diff /= (60 * 60 * 24);

    return Math.abs(Math.round(diff/365.25));
  }

  getDemographic(covObj: EMRUser): string{
    return this.getAge(covObj.DoB) + " y.o. / " + covObj.gender + " / " + covObj.prettyPrintDate(covObj.DoB)
  }

  getDate(strDate: string): Date{

      var dateArr = strDate.split('-')
      var year = parseInt(dateArr[0]);
      var month = parseInt(dateArr[1]) - 1;
      var day = parseInt(dateArr[2])

      return new Date(year, month, day)
  }
}
