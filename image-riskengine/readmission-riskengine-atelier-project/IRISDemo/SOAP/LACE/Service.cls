Include DEMOMACROS

/// IRISDemo.SOAP.LACE.Service
Class IRISDemo.SOAP.LACE.Service Extends %SOAP.WebService [ Language = objectscript, ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "LACE";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Parameter XMLIGNORENULL=1;

/// Admit patient (new encounter)
Method Admit(PatientID As %String, EncounterNumber As %String, EncounterType As %String, StartDate As %Date, StartTime As %Time, AdmissionSource As %String) As %Status [ WebMethod ]
{
	try {
		set obj = ##class(IRISDemo.Data.Patient.Encounter).%New()
		set objPatient = ##class(IRISDemo.Data.Patient.Demographics).PatientIDIndexOpen(PatientID)
		If objPatient=""
		{
			set objPatient = ##class(IRISDemo.Data.Patient.Demographics).%New()
			Set objPatient.PatientID = PatientID
		}
		Set obj.Patient = objPatient
		set obj.EncounterNumber = EncounterNumber
		set obj.EncounterType = EncounterType
		set obj.StartDate = StartDate
		set obj.StartTime = StartTime
		set obj.AdmissionSource = AdmissionSource
		set tSC = obj.%Save()
	
		// Update DeepSee
		if tSC {
			// Immediate update of Cube
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACE",obj.%Id()) 
		}
	}
	catch(objException)
	{
		set tSC = objException.AsStatus()
	}
	
	quit tSC
}

///
Method UpdateEncounter(PatientID As %String, EncounterNumber As %String, EncounterType As %String, AdmissionSource As %String, EncounterStart As %TimeStamp, EncounterEnd As %TimeStamp, DischargeLocation As %String, Output EncounterID As %String) As %Status [ WebMethod ]
{
	set tSC = $$$OK
	Set EncounterID=""
	
	try {
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"select ID from IRISDemo_DataLake.Encounter where Patient->FHIRReferenceCode = '"_PatientID_"' and EncounterNumber = '"_EncounterNumber_"'")
		if objSQL.%Next() 
		{
			set obj = ##class(IRISDemo.DataLake.Encounter).%OpenId(objSQL.%Get("ID"),,.tSC)
		}
		else 
		{
			set obj = ##class(IRISDemo.DataLake.Encounter).%New()
			set obj.EncounterNumber = EncounterNumber
			
			set objPatient = ##class(IRISDemo.DataLake.Patient).FHIRReferenceCodeIndexOpen(PatientID)
			If objPatient=""
			{
				set objPatient = ##class(IRISDemo.DataLake.Patient).%New()
				Set objPatient.FHIRReferenceCode = PatientID
				Set objPatient.MRN = PatientID
			}
			Set obj.Patient = objPatient
		}
	
		Set obj.DischargeLocation = DischargeLocation		
		set obj.EncounterType = EncounterType
		Set obj.EncounterStart = EncounterStart
		
		/*If the encounter is provided it means that the person was discharged from the EMR system*/
		If EncounterEnd'=""
		{ 
			Set obj.Status = "finished"
		}Else {
			/// A running encounter end still needs to be provided so that probabilities can 
			/// be continuously calculated for every update to the EMR system. Every time a new
			/// probability is calculated for an active encounter it is calculated as if the person
			/// was dischared at the current moment.
			
			Set obj.EncounterEnd = $ZDATETIME($Horolog, 3)
		}
		
		set tSC = obj.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "ErrorSavingObject")
		
		// Synchronize this single fact into the LACEV2 cube because we need it current right now
		set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACEV2",obj.%Id())
		$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingLACECube")
		
		// Synchronize this single fact into the ML Encounter cube because we need it current right now
		set tSC = ##class(%DeepSee.Utils).%ProcessFact("MLEncounterV2",obj.%Id())
		$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingMLEncounterCube")
		
		//Recalculate LACE scores and readmission probabilities every single time an encounter message is updated.
		Do ##class(IRISDemo.DataLake.Utils).AddReadmissionPredictionsToEncounter(obj.%Id())
		
		//Adding EncounterID so it is available in the production for running machine learning models
		set EncounterID = obj.%Id()
	}
	catch(objException)
	{
		set tSC = objException.AsStatus()
	}
	quit tSC
}

Method Risk(PatientID As %String, EncounterNumber As %String) As %String [ WebMethod ]
{
	set return = ""
	Set tSC = $$$OK
	try 
	{
		set oResultSet = ##class(%SQL.Statement).%ExecDirect(,"SELECT ID from IRISDemo_DataLake.Encounter where EncounterNumber = ?", EncounterNumber)
		$$$ThrowSQLExceptionIfResultError(oResultSet, "RiskFindEncounterException")
		
		If oResultSet.%Next()
		{
			set encId = oResultSet.%Get("ID")
			set factID = ""
			set factID = ##class(ML.ABT.Utils).GetFactIdForCubeSourceId("LACEV2", encId)
			
			If factID = ""
			{
				$$$ThrowException("FactIDNotFoundException","The FactID for Encounter "_EncounterNumber_" Does Not Exist on the LACE Fact Table")
			}
					
			Set oRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT * from IRISDemo_Cube_LACEV2.Fact where ID="_factID)
			$$$ThrowSQLExceptionIfResultError(oRS, "LACEFactFindException")	
			
			If oRS.%Next() 
			{
				set LScore = oRS.%Get("MxLScore")
				set AScore = oRS.%Get("MxAScore")
				set CScore = oRS.%Get("MxCScore")
				set EScore = oRS.%Get("MxEScore")
				
				set RiskScore = LScore + AScore + CScore + EScore
				set return = RiskScore_","_AScore_","_CScore_","_EScore_","_LScore
				
			}
		}
	}
	catch(objException)
	{
		set tSC = objException.AsStatus()
	}
	
	If $System.Status.IsError(tSC)
	{
		Set oFault = ..MakeStatusFault($$$FAULTServer,"",tSC, $System_":"_..%ClassName(1))
		Do ..ReturnFault(oFault)
	}
	
	quit return
}

}
