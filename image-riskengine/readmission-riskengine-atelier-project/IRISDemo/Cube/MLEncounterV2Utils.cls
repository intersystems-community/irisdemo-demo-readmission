Class IRISDemo.Cube.MLEncounterV2Utils
{
ClassMethod GetAgeAtDischarge(pEncounterStart As %TimeStamp, pEncounterEnd As %TimeStamp, pPatientDOB As %Date) As %Integer
{
	set age = ""
	
	Try 
	{	
		//Impossible to compute age without date of birth
		Quit:pPatientDOB="" 
		
		//Age to be computed relatively to the encounter end date
		Set endDateTime=pEncounterEnd 
		
		//If the encounter has not ended yet, age is to be computed by encounter start date
		If (endDateTime="") Set endDateTime=pEncounterStart
		
		//Computing age by counting the number of days between the two dates and dividing by 365.25
		Set age=$System.SQL.DATEDIFF("dd",pPatientDOB, endDateTime)\365.25
	}
	Catch {	}
	
	quit age
}

/// Calculates the smoking status
ClassMethod Smoking(pPatient As IRISDemo.DataLake.Patient) As %String
{
	// Setup an array of the various types along with their position in the string
	set smoking("FORMER SMOKER") = 2
	set smoking("NEVER SMOKER") = 1
	set smoking("CURRENT EVERY DAY SMOKER") = 3
	set smoking("CURRENT SOME DAY SMOKER") = 3
	set smoking("LIGHT TOBACCO SMOKER") = 3
	set smoking("SMOKER") = 3
	set smoking("HEAVY TOBACCO SMOKER") = 3
	set smoking("UNKNOWN IF EVER SMOKED") = 1

	//Initialise the smoking to 'non-smoker'
	set smoking = "1,0,0"
	
	// Get the social history for this patient's smoking status. Assume that there is only one
	set objSql = ##class(%SQL.Statement).%ExecDirect(,"SELECT SNOMEDValue->SNOMEDDescription As Description from IRISDemo_DataLake.SurveyObservation WHERE Code->LOINCCode='72166-2' AND Patient = "_pPatient)
	if objSql.%Next()
	{
		///Code for Tobacco smoking status NHIS is 72166-2
		Set SNOMEDDescription = objSql.%Get("Description")
		
		// Set the position in the string according to the position indicated by the text
		set position = $get(smoking($zconvert(SNOMEDDescription,"U")))
		If position
		{
			set $piece(smoking,",",position) = 1
			if position > 1 set $piece(smoking,",",1) = 0
		}
		
	}
	quit smoking
}

/// Calculates the number of patient admissions in the last "X" months
ClassMethod NumAdmitsInXMonths(pEncounterID As IRISDemo.DataLake.Encounter, pNumOfMonths As %Integer, pEncounterStart As %TimeStamp, pPatientID As %Integer) As %Integer
{
	// Initialise the result to zero
	Set numOfDays = pNumOfMonths * 30
	
	set Admits = 0

	set sDate = pEncounterStart

	if sDate '= ""
	{
		// Get the previous encounter dates for this patient
		set objSql = ##class(%SQL.Statement).%ExecDirect(,"Select count(*) as ct from IRISDemo_DataLake.Encounter where EncounterEnd<DATEADD('d',-1,'"_sDate_"') AND EncounterStart>=DATEADD('d',-"_numOfDays_",'"_sDate_"') and Patient="_pPatientID_" and EncounterType in ('I', 'E')")
		if objSql.%Next()
		{
			set Admits =  objSql.%Get("ct")
		}
	}
	
	quit Admits
}

ClassMethod NumDiagnosisInXMonths(pEncounterID As IRISDemo.DataLake.Encounter, pNumOfMonths As %Integer, pEncounterStart As %TimeStamp, pPatient As %Integer) As %Integer
{
	// Calculate the number of days needed
	Set numOfDays = pNumOfMonths * 30
	
	// Initialise the result to zero
	Set Diag = 0
	
	Set sDate = pEncounterStart
	Set pid = pPatient
	
	if sDate '= ""
	{
		// Get the previous encounter dates for this patient
		set objSql = ##class(%SQL.Statement).%ExecDirect(,"select count(*) as ct from IRISDemo_DataLake.Diagnosis where OnsetDate<=DATEADD('d',0,'"_sDate_"') and OnsetDate>=DATEADD('d',-"_numOfDays_",'"_sDate_"') and Patient="_pid)
		if objSql.%Next()
		{
			set Diag =  objSql.%Get("ct")
		}
	}
	
	quit Diag
}

/// Calculates whether the encounter after this was a re-admittance
ClassMethod WillReAdmit(pEncounterEnd As %TimeStamp, pPatientID As %Integer) As %Boolean
{
	// Initialise the result to zero (false)
	set willReAdmit = 0
	
	// If we have an end date then find the next start date for this patient
	if pEncounterEnd'= ""
	{
		set objSql = ##class(%SQL.Statement).%ExecDirect(,"SELECT MIN(EncounterStart) As Start, DATEDIFF('day','"_pEncounterEnd_"', MIN(EncounterStart)) As Diff from IRISDemo_DataLake.Encounter where EncounterStart>DATEADD('d',0,'"_pEncounterEnd_"') and Patient="_pPatientID_" and EncounterType = 'I'")
		if objSql.%Next()
		{
			If (objSql.%Get("Start") '= "") && (objSql.%Get("Diff") '= "")
			{
				// Ignore it if the next date is the next day as this is probably a transfer
				// Otherwise mark it as the next encounter was a re-admittance if the difference between the dates is 30 days or less
				Set diff = objSql.%Get("Diff")
				If (diff > 1)&&(diff < 31) set willReAdmit = 1
			}
		}
	}
	
	quit willReAdmit
}

/// Find the comorbidities relevant to this encounter
ClassMethod Comorbidities2(pEncounterID As %String, pCurrentOnly As %Boolean = 0) As %String
{
	#Dim objSql1 As %SQL.StatementResult
	
	// Initialise the string to be blank (all false)
	set comorbidities = ""
	
	// Get the dates for this encounter as we'll need to use a date to get the diagnoses
	set objSql1 = ##class(%SQL.Statement).%ExecDirect(,"select EncounterStart, IFNULL(EncounterEnd,EncounterStart,EncounterEnd) AS EncounterEnd, Patient from IRISDemo_DataLake.Encounter where %ID = "_pEncounterID)
	
	If objSql1.%Next() 
	{
		Set startDate = objSql1.%Get("EncounterStart")
		Set endDate = objSql1.%Get("EncounterEnd")
		
		If 'pCurrentOnly 
		{
			Set startDate = 0
		}
		set pid = objSql1.%Get("Patient")
		
		// Get all the diagnoses for this patient where the onset date isn't later than the encounter
		set objSql3 = ##class(%SQL.Statement).%ExecDirect(,"SELECT distinct com.Description As Comorbidity "_
														   "FROM IRISDemo_DataLake.Diagnosis diag,"_
														   "IRISDemo_DataLake.SNOMEDCT s2c,"_
														   "IRISDemo_DataLake.Comorbidity com "_
														   "WHERE diag.SNOMEDCT=s2c.%ID AND " _
														   "s2c.Comorbidity=com.%ID AND "_
														   "diag.Patient = ? AND "_
														   "diag.OnsetDate >= DATEADD('d', 0, ?) AND "_
														   "diag.OnsetDate <= DATEADD('d', 0, ?)", pid, startDate, endDate)
		while objSql3.%Next() 
		{
			If objSql3.%Get("Comorbidity")'=""
			{
				Set comorbidities=comorbidities_","_objSql3.%Get("Comorbidity")
			}
		}
		
	}
	quit $Extract(comorbidities,2,*)
}

/// Find the comorbidities relevant to this encounter
ClassMethod Comorbidities(pEncounterID As %String, pCurrentOnly As %Boolean = 0, pEncounterStart As %TimeStamp, pEncounterEnd As %TimeStamp, pPatient As %Integer) As %String
{
	#Dim objSql1 As %SQL.StatementResult
	
	// Initialise the string to be blank (all false)
	set comorbidities = ""
	set pid = pPatient
	Set startDate = +$ZDateTimeH(pEncounterStart,3)
	Set endDate = startDate
	If pEncounterEnd '= "" {
		Set endDate = +$ZDateTimeH(pEncounterEnd, 3)
	}
	
	If 'pCurrentOnly 
	{
		Set startDate = 0
	}
	
	
	// Get all the diagnoses for this patient where the onset date isn't later than the encounter
	set objSql = ##class(%SQL.Statement).%ExecDirect(,"SELECT distinct diag.SNOMEDCT->Comorbidity->Description As Comorbidity "_
													   "FROM IRISDemo_DataLake.Diagnosis diag "_
													   "WHERE diag.Patient = ? AND "_
													   "diag.OnsetDate >= ? AND "_
													   "diag.OnsetDate <= ?" , pid, startDate, endDate)
	while objSql.%Next() 
	{
		If (objSql.%Get("Comorbidity")'="")
		{
			Set comorbidities=comorbidities_","_objSql.%Get("Comorbidity")
		}
	}
		
	
	quit $Extract(comorbidities,2,*)
}

ClassMethod Alcohol(pPatientID As %String) As %Boolean 
{
	// Initialise the result to zero
	Set isAlcoholUser = 0
	
	// SNOMEDCode for Alcoholism is 7200002
	Set objSql = ##class(%SQL.Statement).%ExecDirect(,"SELECT TOP 1 ID FROM IRISDemo_DataLake.Diagnosis WHERE SNOMEDCT->SNOMEDCode = 7200002 AND Patient="_pPatientID)
	If objSql.%Next()
	{
		Set isAlcoholUser = 1
	}
	quit isAlcoholUser
}


ClassMethod Drugs(pPatientID As %String) As %Boolean
{
	// Initialise the result to zero
	Set isDrugUser = 0
	
	// SNOMEDCode for Drug overdose is 55680006
	Set objSql = ##class(%SQL.Statement).%ExecDirect(,"SELECT TOP 1 ID FROM IRISDemo_DataLake.Diagnosis WHERE SNOMEDCT->SNOMEDCode = 55680006 AND Patient="_pPatientID)
	If objSql.%Next()
	{
		Set isDrugUser = 1
	}
	quit isDrugUser
}


}