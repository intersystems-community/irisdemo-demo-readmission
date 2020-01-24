import { Component, OnInit } from '@angular/core';
import { DomSanitizer} from '@angular/platform-browser';

@Component({
  selector: 'app-analytics-root',
  templateUrl: './analytics-root.component.html',
  styleUrls: ['./analytics-root.component.css']
})
export class AnalyticsRootComponent implements OnInit {

  iframe_src: any = "";

  constructor(private sanitizer: DomSanitizer) {
    this.iframe_src = sanitizer.bypassSecurityTrustResourceUrl("http://" + window.location.hostname + ":9094/csp/appint/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=LACE/LACE Scores.dashboard&EMBED=1&IRISUserName=SuperUser&IRISPassword=sys")
  }

  ngOnInit() {
  }

}
