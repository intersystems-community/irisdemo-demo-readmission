import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Observable, BehaviorSubject } from 'rxjs';

import DemoConfig from '../config/demo_config';

@Injectable({
  providedIn: 'root'
})
export class IrisWorkflowService {

  /*Rxjs property that allows any component to listen to a workflow change message*/
  private workflowChangeController: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);
  workflowChangeEmitter: Observable<boolean> = this.workflowChangeController.asObservable();

  constructor(private http: HttpClient) { }

  emitChange(message: boolean): void {
    this.workflowChangeController.next(message);
  }

  getAuthHeader(): HttpHeaders{
    const header = new HttpHeaders()
            .set("Authorization", "Basic " + btoa(DemoConfig.CREDENTIALS.userName + ":" + DemoConfig.CREDENTIALS.password));

    return header;
  }

  clearTasks(): void{
    const header = this.getAuthHeader();

    this.http.get(
      (DemoConfig.URL.workflow.root + DemoConfig.URL.workflow.clear),
      {
        headers: header,
        //params: params
      }
    ).subscribe(res => {
      console.log(res)
      let result:any  = res['requestResult'];
      if(result){
        if(result.status === "OK"){
          this.workflowChangeController.next(true);
        }
      }
    },
    (err) => {console.log(err)})
  }

  assignTask(taskId: string): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      (DemoConfig.URL.workflow.root + DemoConfig.URL.workflow.assign),
      {ID: taskId},
      {
          headers: header
      }
    )
  }

  unAssignTask(taskId: string): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      (DemoConfig.URL.workflow.root + DemoConfig.URL.workflow.unassign),
      {ID: taskId},
      {
          headers: header
      }
    )
  }

  completeTask(taskId: string, action: string): Observable<any>{
    const header = this.getAuthHeader();

    return this.http.post(
      (DemoConfig.URL.workflow.root + DemoConfig.URL.workflow.complete),
      {
        ID: taskId,
        action: action
      },
      {
          headers: header
      }
    )
  }

  getTasks(count?: number, startId?: number): Observable<any>{

    const header = this.getAuthHeader();
    //const URLParams = count ? (("/" + count) + startId ? "/" + startId : "") : "";
    /*const params = new HttpParams()
      .set("", MRN || "")
      .set("encounterNumber", encounterNumber || "")
      .set("firstName", firstName || "")
      .set("lastName", lastName || "")*/


    return this.http.get(
      (DemoConfig.URL.workflow.root + DemoConfig.URL.workflow.tasks),
      {
        headers: header,
        //params: params
      }
    )
  }
}
