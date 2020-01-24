/// 
Class IRISDemo.BP.ReadmissionRisk.Process Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='RRLACESrv.BO.UpdateEncounterRequest' response='Ens.Response' height='2050' width='2000' >
<context>
<property name='UpdateEncounterResult' type='%Library.Status' initialexpression='1' instantiate='0' />
<property name='EmailTo' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='EmailSubject' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='EmailText' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
<property name='RiskScore' type='%Integer' instantiate='0' />
<property name='LScore' type='%Integer' instantiate='0' />
<property name='AScore' type='%Integer' instantiate='0' />
<property name='CScore' type='%Integer' instantiate='0' />
<property name='EScore' type='%Integer' instantiate='0' />
<property name='PatientID' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='DischargeLocation' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='AlertMessage' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='2500' />
</parameters>
</property>
<property name='EncounterID' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='MLReadmissionRisk' type='%Float' instantiate='0' />
</context>
<sequence xend='200' yend='1800' >
<call name='Discharge patient' target='LACE SOAP Operation' async='0' xpos='200' ypos='250' >
<request type='RRLACESrv.BO.UpdateEncounterRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='RRLACESrv.BO.UpdateEncounterResponse' >
<assign property="context.UpdateEncounterResult" value="callresponse.UpdateEncounterResult" action="set" />
<assign property="context.EncounterID" value="callresponse.EncounterID" action="set" />
</response>
</call>
<if name='Discharge OK?' condition='context.UpdateEncounterResult=1' xpos='200' ypos='350' xend='200' yend='1700' >
<true>
<call name='Calculate Risk with LACE' target='LACE SOAP Operation' async='0' xpos='335' ypos='500' >
<request type='RRLACESrv.BO.RiskRequest' >
<assign property="callrequest.PatientID" value="request.PatientID" action="set" />
<assign property="callrequest.EncounterNumber" value="request.EncounterNumber" action="set" />
</request>
<response type='RRLACESrv.BO.RiskResponse' >
<assign property="response" value="callresponse" action="set" />
<assign property="context.RiskScore" value="$Piece(callresponse.RiskResult,&quot;,&quot;,1)" action="set" />
<assign property="context.LScore" value="$Piece(callresponse.RiskResult,&quot;,&quot;,5)" action="set" />
<assign property="context.AScore" value="$Piece(callresponse.RiskResult,&quot;,&quot;,2)" action="set" />
<assign property="context.CScore" value="$Piece(callresponse.RiskResult,&quot;,&quot;,3)" action="set" />
<assign property="context.EScore" value="$Piece(callresponse.RiskResult,&quot;,&quot;,4)" action="set" />
</response>
</call>
<call name='Calculate Risk with ML' target='Readmission ML Model Consumer' async='0' xpos='335' ypos='600' >
<request type='ML.Model.BO.Executor.CubeSourceScoreRequest' >
<assign property="callrequest.MLOperationName" value="&quot;Readmission Model Executor&quot;" action="set" />
<assign property="callrequest.CubeSourceRowID" value="context.EncounterID" action="set" />
</request>
<response type='ML.Model.BO.Executor.ScoreResponse' >
<assign property="context.MLReadmissionRisk" value="callresponse.ModelOutput.GetAt(&quot;probability1&quot;)" action="set" />
</response>
</call>
<if name='Risk Alert?' condition='(context.RiskScore&gt;11) || (context.MLReadmissionRisk &gt; 0.15)' xpos='335' ypos='700' xend='335' yend='1600' >
<annotation><![CDATA[If LACE score is above 10 or if 
ML readmission prediction is above 50%]]></annotation>
<true>
<assign name="Compose Alert Message" property="context.AlertMessage" value="&quot;Patient '&quot;_request.PatientID_&quot;' has just been discharged to '&quot;_request.DischargeLocation_&quot;' and has a &quot;_$select(context.RiskScore&gt;9:&quot;high&quot;,1:&quot;moderate&quot;)_&quot; risk of readmission&quot;_$char(13,10)_&quot;The scores are as follows:&quot;_$char(13,10)_&quot;Risk Score: &quot;_context.RiskScore_$char(13,10)_&quot;'L' Score (Length of stay): &quot;_context.LScore_$char(13,10)_&quot;'A' Score (Acuity): &quot;_context.AScore_$char(13,10)_&quot;'C' Score (Comorbidity): &quot;_context.CScore_$char(13,10)_&quot;'E' Score (Emergency department visits): &quot;_context.EScore_$char(13,10)_&quot;ML Readmission Risk Prediction: &quot;_(context.MLReadmissionRisk*100)_&quot;%&quot;" action="set" xpos='470' ypos='850' />
<call name='Add Patient to Risk Program' target='Care Team' async='1' xpos='470' ypos='950' >
<request type='EnsLib.Workflow.TaskRequest' >
<assign property="callrequest.%Message" value="context.AlertMessage" action="set" />
<assign property="callrequest.%Subject" value="&quot;Patient at Risk of Readmission&quot;" action="set" />
<assign property="callrequest.%Actions" value="&quot;Visited the Patient,Called the Patient&quot;" action="set" />
<assign property="callrequest.%FormFields" value="&quot;PatientID,DischargeLocation,RiskScore&quot;" action="set" />
<assign property="callrequest.%FormValues" value="request.PatientID_&quot;,&quot;_request.DischargeLocation_&quot;,&quot;_context.RiskScore" action="set" />
</request>
<response type='EnsLib.Workflow.TaskResponse' />
</call>
<call name='Alert Care Team' target='Risk Alert Email Operation' async='0' xpos='470' ypos='1050' >
<request type='IRISDemo.BO.Email.EmailMessage' >
<assign property="callrequest.From" value="&quot;IRISDemo&quot;" action="set" />
<assign property="callrequest.Subject" value="&quot;LACE readmission alert&quot;" action="set" />
<assign property="callrequest.To" value="&quot;readmission.alert@healthcare.med&quot;" action="set" />
<assign property="callrequest.MessageText" value="context.AlertMessage" action="set" />
</request>
</call>
<sync name='Follow up SLA 2 days' calls='Add Patient to Risk Program' timeout='172800' type='all' xpos='470' ypos='1150' >
<annotation><![CDATA[Is the patient following the care plan?]]></annotation>
</sync>
<if name='No follow up?' condition='synctimedout' xpos='470' ypos='1250' xend='470' yend='1500' >
<true>
<alert value='"Follow up of patient id "_request.PatientID_" pending."' xpos='605' ypos='1400' />
</true>
</if>
</true>
</if>
</true>
</if>
</sequence>
</process>
}

/// BPL Definition
Storage Default
{
<Description>
<![CDATA[BPL Definition]]></Description>
<Type>%Storage.Persistent</Type>
}

}
