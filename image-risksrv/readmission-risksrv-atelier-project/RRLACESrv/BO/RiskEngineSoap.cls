Class RRLACESrv.BO.LACESoap Extends Ens.BusinessOperation [ ProcedureBlock ]
{
 
Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

Method Admit(pRequest As RRLACESrv.BO.AdmitRequest, Output pResponse As RRLACESrv.BO.AdmitResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
 Set tSC = ..Adapter.InvokeMethod("Admit",.AdmitResult,pRequest.PatientID,pRequest.EncounterNumber,pRequest.EncounterType,pRequest.StartDate,pRequest.StartTime,pRequest.AdmissionSource)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.AdmitResult=$get(AdmitResult)
 Quit $$$OK
}

Method UpdateEncounter(pRequest As RRLACESrv.BO.UpdateEncounterRequest, Output pResponse As RRLACESrv.BO.UpdateEncounterResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
 Set tSC = ..Adapter.InvokeMethod("UpdateEncounter",.UpdateEncounterResult,pRequest.PatientID,pRequest.EncounterNumber,pRequest.EncounterType,pRequest.AdmissionSource,pRequest.EncounterStart, pRequest.EncounterEnd, pRequest.DischargeLocation,.EncounterID)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.UpdateEncounterResult=$get(UpdateEncounterResult),pResponse.EncounterID = $get(EncounterID)
 Quit $$$OK
}

Method Risk(pRequest As RRLACESrv.BO.RiskRequest, Output pResponse As RRLACESrv.BO.RiskResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "RRLACESrv.WSClient.LACESoap"
 Set tSC = ..Adapter.InvokeMethod("Risk",.RiskResult,pRequest.PatientID,pRequest.EncounterNumber)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.RiskResult=$get(RiskResult)
 Quit $$$OK
 
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="RRLACESrv.BO.AdmitRequest">
		<Method>Admit</Method>
	</MapItem>
	<MapItem MessageType="RRLACESrv.BO.UpdateEncounterRequest">
		<Method>UpdateEncounter</Method>
	</MapItem>
	<MapItem MessageType="RRLACESrv.BO.RiskRequest">
		<Method>Risk</Method>
	</MapItem>
</MapItems>
}

}
