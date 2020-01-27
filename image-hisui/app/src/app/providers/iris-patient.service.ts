import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';

import DemoConfig from '../config/demo_config';

export class EMRUser {
  firstName: string;
  lastName: string;
  MRN: string;
  encounterNumber: string;
  startDate: Date;
  startTime: string;
  endDate: Date;
  endTime: string;
  DoB: Date;
  encounterStatus: string;
  encounterType: string;
  dischargeDestination: string;
  gender: string;
  encounterId: string;
  laceScoreAggregate: number;
  laceScore: string;
  readmissionProbability: number;

  prettyPrintDate(dateForConversion: Date): string{

    let output: string = "";

    const addZero = (num) => {
      let output = num;
      if(num){
        if(num.toString().length === 1){
          output = "0" + num;
        }
      }
      return output;
    }

    if(dateForConversion){
      output = dateForConversion.getFullYear() + "-" +
      addZero((dateForConversion.getMonth() + 1)) + "-" +
      addZero(dateForConversion.getDate());
    }

    return output;
  }

  constructor(
    firstName: string,
    lastName: string,
    mrn: string,
    encounterNumber: string,
    startDate: string,
    startTime: string,
    endDate: string,
    endTime: string,
    dob: string,
    encounterStatus: string,
    encounterType: string,
    dischargeDestination: string,
    gender: string,
    encounterId: string,
    laceScoreAggregate: number,
    laceScore: string,
    readmissionProbability: number,
  ){
    this.firstName = firstName;
    this.lastName = lastName;
    this.MRN = mrn;
    this.encounterNumber = encounterNumber;
    this.startDate = new Date(startDate);
    this.startTime = startTime;
    this.endDate = encounterStatus === "A" ? new Date() : new Date(endDate);
    this.endTime = endTime;
    this.DoB = new Date(dob);
    this.encounterStatus = encounterStatus;
    this.encounterType = encounterType;
    this.dischargeDestination = dischargeDestination;
    this.gender = gender;
    this.encounterId = encounterId;
    this.laceScoreAggregate = laceScoreAggregate;
    this.laceScore = laceScore;
    this.readmissionProbability =readmissionProbability;
  }
}

export class UserSearchRequest {
  firstName: string;
  lastName: string;
  MRN: string;
  encounterNumber: string;
  admissionDate: Date;

  constructor(){
    this.firstName = "";
    this.lastName = "";
    this.MRN = "";
    this.encounterNumber = "";
    this.admissionDate = new Date();
  }
}

export class DischargeRequest {
  firstName: string;
  lastName: string;
  MRN: string;
  encounterId: string;
  dischargeDestCode: string;

  constructor(firstName: string, lastName: string, MRN: string, encounterId: string, dischargeDestCode: string){
    this.firstName = firstName;
    this.lastName = lastName;
    this.MRN = MRN;
    this.encounterId = encounterId;
    this.dischargeDestCode = dischargeDestCode;
  }

}

@Injectable({
  providedIn: 'root'
})
export class IrisPatientService {

  /*Rxjs property that allows any component to listen to a demo reset message*/
  private resetDemoController: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);
  resetDemoEmitter: Observable<boolean> = this.resetDemoController.asObservable();

  constructor(private http: HttpClient) { }

  EMRUserBuilder(conversionObj: any): EMRUser{
    let parsedStartDate = conversionObj.EncounterStart.split(" ");
    let parsedEndDate = [null,null]
    if(conversionObj.EncounterEnd){
      parsedEndDate = conversionObj.EncounterEnd.split(" ");
    }
    return new EMRUser(
      conversionObj.FirstName,
      conversionObj.LastName,
      conversionObj.MRN,
      conversionObj.EncounterNumber,
      parsedStartDate[0],
      parsedStartDate[1],
      parsedEndDate[0],
      parsedEndDate[1],
      conversionObj.DoB,
      conversionObj.EncounterStatus,
      conversionObj.EncounterType,
      ("00" + conversionObj.DischargeDestination),
      conversionObj.Gender,
      conversionObj.EncounterID,
      conversionObj.LACEScoreAggregate,
      conversionObj.LACEScore,
      conversionObj.ReadmissionProbability
    );
  }

  getEmpyUser(): EMRUser {
    return new EMRUser("", "", "", "","", "", "", "", "", "", "", "", "", "", null, "", null);
  }

  getAuthHeader(): HttpHeaders{
    const header = new HttpHeaders()
            .set("Authorization", "Basic " + btoa(DemoConfig.CREDENTIALS.userName + ":" + DemoConfig.CREDENTIALS.password));

    return header;
  }

  resetDemo(): void {
    const header = this.getAuthHeader();

    this.http.get(
      DemoConfig.URL.resetDemo,
      {
          headers: header
      }
    ).subscribe( resp => {
      console.log("Resetting Demo: ", resp);

      let result:any  = resp['requestResult'];

      if(result.status === "OK"){
        this.resetDemoController.next(true);
      }else{
        this.resetDemoController.error(true);
      }
    },
    (err) => {
      console.log(err);
      this.resetDemoController.error(true);
    });
  }

  dischargePatient(dischargeObj: DischargeRequest): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      DemoConfig.URL.dischargeUser,
      dischargeObj,
      {
          headers: header
      }
    )
  }

  searchForUser(MRN: string, firstName: string, lastName: string, encounterNumber: string): Observable<any>{

    const header = this.getAuthHeader();
    const params = new HttpParams()
      .set("MRN", MRN || "")
      .set("encounterNumber", encounterNumber || "")
      .set("firstName", firstName || "")
      .set("lastName", lastName || "")


    return this.http.get(
      DemoConfig.URL.userList,
      {
        headers: header,
        params: params
      }
    )
  }

  getAdmissions(): Observable<any>{

    const header = this.getAuthHeader();

    return this.http.get(
      DemoConfig.URL.admissionsList,
      {
        headers: header
      }
    )
  }
}
