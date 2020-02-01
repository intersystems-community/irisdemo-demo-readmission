Include DEMOMACROS

Class IRISDemo.Data.Utils
{
	/// This is being called from IRISConfig.Installer when the image is built
	/// This method loads all the encounters and patients from a file that was generated
	/// by the RRLACESrv image.
	ClassMethod LoadEncounters(pFileName as %String)
	{
		#Dim objRs As %Library.ResultSet
		#Dim objPatient As Patient
		
		Do ..CreateEncounterDischargeDest()
		
		set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV2")

		Set tSC = objRs.Execute(pFileName) 
		$$$ThrowStatusExceptionIfError(tSC, "LoadEncounterFileException")
		
		// This will prevent HL7 messages from being triggered while we load this file
		// Look at the IRISDemo.Data.Encounter table to see how we check this variable on the trigger
		// A variable name that starts with % is globally available for everyone on this process.
		// Do not confuse "globally available on this process" with globals. Global variable names
		// start with a ^ (caret) and they are persisted on disk which makes them globally available
		// for ALL PROCESSES, even after the system restarts until someone explicitly kills it. 
		// A variable name that starts with a % will be globally available on this process only and will
		// die with the process. 
		Set %NOHL7=1
		
		While objRs.Next() 
		{
			set objEncounter = ##class(IRISDemo.Data.Encounter).%New()
			Set objEncounter.EncounterNumber = objRs.Get("EncounterNumber")
			Set objEncounter.EncounterType = objRs.Get("EncounterType")
			Set objEncounter.EncounterStart = objRs.Get("EncounterStart")
			Set objEncounter.EncounterEnd = objRs.Get("EncounterEnd")
			Set objEncounter.AdmissionSource = objRs.Get("AdmissionSource")
			Set objEncounter.LACEScoreAggregate = objRs.Get("LACEScoreAggregate")
			Set objEncounter.LACEScore = objRs.Get("LACEScore")
			Set objEncounter.ReadmissionProbability = objRs.Get("ReadmissionProbability")
			Set objEncounter.DischargeDestination=##class(EncounterDischargeDest).DischargeDestCodeIndexOpen("H") // Send to home
			Set objEncounter.EncounterStatus="A"	//Active
			
			Set objPatient = ##class(IRISDemo.Data.Patient).MRNIndexOpen(objRs.Get("PatientID"))
			
			If objPatient=""
			{
				Set objPatient = ##class(IRISDemo.Data.Patient).%New()
				Set objPatient.MRN=objRs.Get("PatientID")
			}
			
			Set objEncounter.Patient=objPatient
			Set objPatient.DoB=objRs.Get("DateOfBirth")
			Set objPatient.FirstName=objRs.Get("FirstName")
			Set objPatient.Gender=$Extract($ZCONVERT(objRs.Get("Gender"),"U"))
			Set objPatient.LastName=objRs.Get("LastName")
			
			Set tSC = objEncounter.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "EncounterSaveException")
		}
		///This will need to be done
		//Do ..CreateAdmissions()
	}
	
	/// Called from REST service on IRISDemo.REST.Encounter
	ClassMethod ResetDemo()
	{
					
		Set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"Select ID, Patient->MRN From IRISDemo_Data.Encounter")
		$$$ThrowSQLExceptionIfResultError(rsEncounters, "SelectingAdmissionsException")
		
		While rsEncounters.%Next() 
		{	
			
			Set objEncounter=##class(IRISDemo.Data.Encounter).%OpenId(rsEncounters.%Get("ID"))
			//Patients in descending sickness order, the sicker the patient the farther back the end date
			// 900001, 900002, 900003
			If rsEncounters.%Get("MRN") = "900001"
			{
				Set objEncounter.EncounterStart = $SYSTEM.SQL.DATEADD("day", -4, $Horolog)
			}
			ElseIf rsEncounters.%Get("MRN") = "900002"
			{
				Set objEncounter.EncounterStart = $SYSTEM.SQL.DATEADD("day", -2, $Horolog)
			}
			Else {
				Set objEncounter.EncounterStart = $SYSTEM.SQL.DATEADD("day", -1, $Horolog)
			}
			
			Set objEncounter.EncounterEnd=""
			Set objEncounter.DischargeDestination=##class(EncounterDischargeDest).DischargeDestCodeIndexOpen("H") // Send to home
			Set objEncounter.EncounterStatus="A"
			
			Set tSC = objEncounter.%Save()
			$$$ThrowStatusExceptionIfError(tSC, "ResetDemoException")
		}	
		
	}

	ClassMethod CreateEncounterDischargeDest() [ Private ]
	{
		// That is just another way of doing some quick and dirty SQL:
		
		&SQL(INSERT INTO IRISDemo_Data.EncounterDischargeDest (Code, Description) values ('H', 'Home'))
		&SQL(INSERT INTO IRISDemo_Data.EncounterDischargeDest (Code, Description) values ('N', 'Nursing Facility'))
		&SQL(INSERT INTO IRISDemo_Data.EncounterDischargeDest (Code, Description) values ('D', 'Deceased'))
	}

}