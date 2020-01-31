Class RRLACESrv.WSClient.LACESoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://rrlacesrv:52773/csp/appint/IRISDemo.SOAP.LACE.Service.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "LACE";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Overrides default handling of string arguments.
Parameter XMLIGNORENULL = 1;

Method Admit(PatientID As %String, EncounterNumber As %String, EncounterType As %String, StartDate As %Date, StartTime As %Time, AdmissionSource As %String) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Admit").Invoke($this,"http://tempuri.org/IRISDemo.SOAP.LACE.Service.Admit",.PatientID,.EncounterNumber,.EncounterType,.StartDate,.StartTime,.AdmissionSource)
}

Method UpdateEncounter(PatientID As %String, EncounterNumber As %String, EncounterType As %String, AdmissionSource As %String, EncounterStart As %TimeStamp, EncounterEnd As %TimeStamp, DischargeLocation As %String, Output EncounterID As %String) As %xsd.base64Binary [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("UpdateEncounter").Invoke($this,"http://tempuri.org/IRISDemo.SOAP.LACE.Service.UpdateEncounter",.PatientID,.EncounterNumber,.EncounterType,.AdmissionSource,.EncounterStart,.EncounterEnd,.DischargeLocation,.EncounterID)
}


Method Risk(PatientID As %String, EncounterNumber As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Risk").Invoke($this,"http://tempuri.org/IRISDemo.SOAP.LACE.Service.Risk",.PatientID,.EncounterNumber)
}

}
