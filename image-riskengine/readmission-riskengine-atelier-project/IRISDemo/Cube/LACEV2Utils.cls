Class IRISDemo.Cube.LACEV2Utils
{
/// L Score - Length of Stay Score<br>
///  (component of LACE score)<br>
/// 
ClassMethod GetLScore(pEncounterID As IRISDemo.DataLake.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	set tLOS = 0
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"SELECT LOS FROM IRISDemo_DataLake.Encounter WHERE ID = '"_pEncounterID_"'")
	if objSQL.%Next() set tLOS = objSQL.%GetData(1)

	set tLScore = $Select(tLOS<=3 : tLOS, //if LOS less than 3, score is LOS
	                      tLOS<=6 : 4,    //if LOS between 4 and 6, score is 4
	                      tLOS<=13: 5,    //if LOS between 7 and 13, score is 5
	                      tLOS>=14: 7)    //if LOS 14 or higher, score is 7
	quit tLScore
}

/// A Score - Acuity Score
///  (component of LACE score)<br>
ClassMethod GetAScore(pEncounterID As IRISDemo.DataLake.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	
	// Need to determine if this admission is via the emergency dept 
	// For now we'll take the encounter type but could be a lookup by admission source
	set tAScore = 0
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"SELECT EncounterType FROM IRISDemo_DataLake.Encounter WHERE ID = '"_pEncounterID_"'")
	if objSQL.%Next() if objSQL.%GetData(1) = "E" set tAScore = 3

	quit tAScore
}

/// C Score - Comorbidities Score
///  (component of LACE score)<br>
ClassMethod GetCScore(pEncounterID As IRISDemo.DataLake.Encounter) As %Integer
{
	// pEncounterID is the ID of the instance (row ID) 
	
	set tCScore = 0

	// Get the patient number
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"SELECT Patient FROM IRISDemo_DataLake.Encounter where ID = '"_pEncounterID_"'")
	if objSQL.%Next() {
		set pId = objSQL.%GetData(1)
		// Get all the diagnoses for this patient
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"SELECT DISTINCT SNOMEDCT->Comorbidity->Description As Description,  SNOMEDCT->Comorbidity->CharlsonComorbidityIndex AS CCIndex FROM IRISDemo_DataLake.Diagnosis where Patient = '"_pId_"'")
		while objSQL.%Next() {
			Set description = objSQL.%Get("Description")
			Set CCIndex = objSQL.%Get("CCIndex")
			If (description '= "") && (CCIndex '= ""){
				set comorb(description) = CCIndex
			}
		}
	}
	set tTotalScore = 0
	set comorb = ""
	for  {
		set comorb = $order(comorb(comorb),1,value)
		if comorb = "" quit
		set tTotalScore = tTotalScore + value
	}

	if tTotalScore<=3 {
		set tCScore = tTotalScore
	}
	else {
		set tCScore = 5
	}
	
	quit tCScore
}

/// E Score - Emergency Visits Score
///  (component of LACE score)<br>
ClassMethod GetEScore(pEncounterID As IRISDemo.DataLake.Encounter) As %Integer
{
	
	// tEmergencyVisits is the count of patient visits to emergency dept in the 6 months prior to current admission,
	// not including the current admission
	set tEScore = 0
	set objSQL = ##class(%SQL.Statement).%ExecDirect(,"SELECT Patient, EncounterStart from IRISDemo_DataLake.Encounter where ID = '"_pEncounterID_"'")
	if objSQL.%Next() {
		set pId = objSQL.%GetData(1)
		set eDate = objSQL.%GetData(2)
		set objSQL = ##class(%SQL.Statement).%ExecDirect(,"SELECT count(*) from IRISDemo_DataLake.Encounter where Patient = '"_pId_"' and ID<>'"_pEncounterID_"' and EncounterType = 'E' and EncounterStart>=DATEADD('d',-180,'"_eDate_"')")
		if objSQL.%Next() {
			set tEmergencyVisits = objSQL.%GetData(1)
			if tEmergencyVisits > 4 {
				set tEScore = 4
			}
			else {
				set tEScore = tEmergencyVisits
			}
		}
	}
	quit tEScore
}


}