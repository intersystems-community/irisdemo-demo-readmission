import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';

import DemoConfig from '../config/demo_config';

@Injectable({
  providedIn: 'root'
})
export class IrisMlService {

  MLProcedure: string = "MLEncounter";
  operationName: string = "Readmission Model Executor"

  constructor(private http: HttpClient) { }

  getAuthHeader(): HttpHeaders{
    const header = new HttpHeaders()
            .set("Authorization", "Basic " + btoa(DemoConfig.CREDENTIALS.userName + ":" + DemoConfig.CREDENTIALS.password));

    return header;
  }

  getMLDataMap(encounterNumber: string, procedureName: string): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      (DemoConfig.URL.cube.root + DemoConfig.URL.cube.getABTCubeData),
      {
        encounterNumber: encounterNumber,
        procedureName: procedureName
      },
      {
          headers: header
      }
    )
  }

  getMLPrediction(dataMap: any, operationName: string): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      (DemoConfig.URL.prediction.root + DemoConfig.URL.prediction.getPrediction),
      {
        dataMap: dataMap,
        operationName: operationName
      },
      {
          headers: header
      }
    )
  }

}
