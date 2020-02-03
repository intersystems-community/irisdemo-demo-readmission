Include DEMOMACROS

Class IRISDemo.DataLake.Utils
{

/// We will be adding this to all clinical dates so that the LACE score will
/// be correctly computed in 6 months from now.
Parameter DATEWINDOW = {$Horolog-$ZDateH("2020-01-01",3)};

ClassMethod LoadDemoData(debug As %Boolean = 0)
{
	Write !!,"Loading All demo data",!
	Do ..LoadIndexData("/tmp/ComorbidityIndexMapping.csv", debug)
	
	Write !!,"Loading Synthetic Patient Data",!
	Do ..LoadPatientData()
	write !!,"Loading All demo data finished",!!
	    
    Write !!,"Updating 10% of encounters that will NOT readmit to have the patient discharged to nursing facility.",!!
    Do ..UpdateEncountersWithNursingFacilityDischargeLocation()
    
    Write !!,"Building MLEncounterV2 cube..."
    Set tSC = $System.DeepSee.BuildCube("MLEncounterV2")
    $$$ThrowStatusExceptionIfError(tSC, "BuildCubeException")
    
	write !!,"Importing the Machine Learning Model",!!
	Set tClassName = $Piece($Piece("/tmp/IRISDemo.ImportedModel.RandomForest.pmml","/",*),".",1,*-1)
	Set tSC = ##class(%DeepSee.PMML.Utils).CreateFromFile("/tmp/IRISDemo.ImportedModel.RandomForest.pmml", tClassName)
	$$$ThrowStatusExceptionIfError(tSC, "Error Importing Machine Learning Model")
	
	Write !!,"Generating Demo Patient Data",!
	Do ..UpdateDemoPatients(debug)
	write !!,"Generating Demo Patient Data finished",!!
	
	Write !!,"Publishing MLEncounterV2 Cube as ABT",!!
    Do ##class(ML.Director).PublishCubeAsABT("MLEncounterV2","MLEncounter")
    
   Write !!,"Adding Probabilities to demo encounters",!!
   Do ..AddProbabilitiesToDemoEncounters()
}

ClassMethod UpdateEncountersWithNursingFacilityDischargeLocation()
{
	#Dim rsEncounters As %SQL.StatementResult
	#Dim encounter As IRISDemo.Data.Patient.Encounter
	
	Set tSC = $$$OK
	Try{
	
		Set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"SELECT ID, EncounterEnd, Patient from IRISDemo_DataLake.Encounter WHERE { fn mod (ID, 10)} = 0 AND EncounterType='I'")
		$$$ThrowSQLExceptionIfResultError(rsEncounters, "SelectPatientsForNursingFacilityUpdateException")
		
		While rsEncounters.%Next() 
		{
			Set encounterId = rsEncounters.%GetData(1)
			Set encounterEnd = rsEncounters.%GetData(2)
			Set encounterPatientId = rsEncounters.%GetData(3)
			
			Set willReadmit = ##class(IRISDemo.Cube.MLEncounterV2Utils).WillReAdmit(encounterEnd, encounterPatientId)
			If 'willReadmit
			{
				Set encounter = ##class(IRISDemo.DataLake.Encounter).%OpenId(encounterId)
				Set encounter.DischargeLocation = "N"
				
				Set tSC = encounter.%Save()
				$$$ThrowStatusExceptionIfError(tSC, "UpdateEncounterDischargeLocationException")
			}
		}
	}
	Catch(oException){
		Set tSC = oException.AsStatus()
	}
	
	$$$ThrowStatusExceptionIfError(tSC, "UpdatingEncountersWithNursingFacilityException")
}

ClassMethod LoadIndexData(fileName As %String, debug As %Boolean = 0)
{
	if debug write !!,"Loading comorbidity index",!
	Set objRs = ##class(%Library.ResultSet).%New("IRISDemo.Util.FileReader:CSV")

	Set tSC = objRs.Execute(fileName) 
	$$$ThrowStatusExceptionIfError(tSC, "LoadIndexDataFileException")
	
	do ##class(IRISDemo.DataLake.SNOMEDCT).%KillExtent()
	do ##class(IRISDemo.DataLake.Comorbidity).%KillExtent()

	While objRs.Next() 
	{
		if debug set count = $increment(count) if (count#1000)=0 write $justify(count,10)
		
		//Get or create the associated Comorbidity
		Set comorbidityDescription = objRs.Get("Comorbidity")
		Set comorbidityIndex = objRs.Get("CharlsonComorbidityIndex")
		Set comorbidityObj = ##class(IRISDemo.DataLake.Comorbidity).OpenOrCreate(comorbidityDescription, comorbidityIndex)
		
		// Mapping from SNOMED to ICD
		Set SNOMEDCode = objRs.Get("SNOMEDCode")
		Set SNOMEDObj = ##class(IRISDemo.DataLake.SNOMEDCT).OpenOrCreate(SNOMEDCode,"")
		
		If SNOMEDObj.ICDCode = ""
		{
			Set SNOMEDObj.ICDCode = objRs.Get("ICDCode")
		}
		
		If SNOMEDObj.Comorbidity = ""
		{
			Set SNOMEDObj.Comorbidity = comorbidityObj
		}
		Set tSC = SNOMEDObj.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "SNOMEDCTSaveException")
	}
}

ClassMethod ExportPatients()
{
	#Dim oFile As %Library.File
	#Dim rsEncounters As %SQL.StatementResult
	#Dim oResultMetadata As %SQL.StatementMetadata
	#Dim oColumn As %SQL.StatementColumn
	
	set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"SELECT Patient->FHIRReferenceCode As PatientID, Patient->DateOfBirth, Patient->FirstName, Patient->LastName, Patient->Gender, EncounterNumber, EncounterType, EncounterStart, EncounterEnd, AdmitReason, LACEScore, LACEScoreAggregate, ReadmissionProbability "_
															"FROM IRISDemo_DataLake.Encounter WHERE EncounterNumber IN('900001-1', '900002-1', '900003-1')")
	$$$ThrowSQLExceptionIfResultError(rsEncounters, "SelectPatientsForExportException")
	
	Set oFile = ##class(%Library.File).%New("/tmp/export_to_hisdb.csv")
	
	Set tSC = oFile.Open("NW")
	$$$ThrowStatusExceptionIfError(tSC, "CouldNotOpenCSVFileException")
	
	Set oResultMetadata = rsEncounters.%GetMetadata()
	
	Set tHeader=""
	For iCol=1:1:oResultMetadata.columnCount
	{
		Set oColumn = oResultMetadata.columns.GetAt(iCol)
		Set $Piece(tHeader,";",iCol)=oColumn.colName
	}
	
	Set tSC = oFile.WriteLine(tHeader)
	$$$ThrowStatusExceptionIfError(tSC, "CouldNotWriteCSVHeaderException")
	
	While rsEncounters.%Next() 
	{
		Set tRecord=""
		For iCol=1:1:oResultMetadata.columnCount
		{				
			Set $Piece(tRecord,";",iCol)=rsEncounters.%GetData(iCol)
		}
		
		Set tSC = oFile.WriteLine(tRecord)
		$$$ThrowStatusExceptionIfError(tSC, "CouldNotWriteCSVRecordrException")
	}

	Do oFile.%Close()
}

ClassMethod AddReadmissionPredictionsToEncounter(encounterID As %Integer)
{
		#Dim rsEncounters As %SQL.StatementResult
		#Dim encounter As IRISDemo.DataLake.Encounter
		#Dim oModelDataOutput AS ML.Model.BO.Executor.ExecuteModelResp
		
		Set tSC = $$$OK
		Try{
		
			Set tSC = ##class(ML.Model.Util).GetModelInstance("IRISDemo.ImportedModel.RandomForest", .oModel)
			$$$ThrowStatusExceptionIfError(tSC, "ErrorGettingModelException")
		
			Set rsFact = ##class(%SQL.Statement).%ExecDirect(,"SELECT MxLACE, MxLScore, MxAScore, MxCScore, MxEScore from IRISDemo_Cube_LACEV2.Fact WHERE %sourceId ="_encounterID)
			$$$ThrowSQLExceptionIfResultError(rsFact, "AddReadmissionPredictionsToEncounterException")
			
			While rsFact.%Next() 
			{
				Set encounter = ##class(IRISDemo.DataLake.Encounter).%OpenId(encounterID)
				
				Set LACEScore = rsFact.%Get("MxLACE")
				Set LScore = rsFact.%Get("MxLScore")
				Set AScore = rsFact.%Get("MxAScore")
				Set CScore = rsFact.%Get("MxCScore")
				Set EScore = rsFact.%Get("MxEScore")
				
				Set encounter.LACEScore = LACEScore_", "_LScore_", "_AScore_", "_CScore_", "_EScore
				Set encounter.LACEScoreAggregate = LACEScore
				
				Set tSC = ##class(ML.Director).RunModelOnABTSourceId("MLEncounter", encounterID, oModel, .oModelDataOutput)
				$$$ThrowStatusExceptionIfError(tSC, "ErrorGettingPredictionException")
				
				Set encounter.ReadmissionProbability = $property(oModelDataOutput, "probability1")
				
				Do encounter.%Save()
			}
		}
		Catch(oException){
			Set tSC = oException.AsStatus()
		}
		
		$$$ThrowStatusExceptionIfError(tSC, "AddReadmissionPredictionsToEncounterException")
}

/// Pick the patients we want to use on the demo and give them fixed names
ClassMethod UpdateDemoPatients(debug As %Boolean = 0)
{
		if debug write !!,"Updating demo patients",!
		
		#dim objPat as IRISDemo.DataLake.Patient
		#dim objEnc as IRISDemo.DataLake.Encounter
		#dim objDgn as IRISDemo.DataLake.Diagnosis
		
		// Remove the 3 patients first in case we have the ID numbers in the system
		for pId = 900001:1:900003 {
			set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_DataLake.Diagnosis where Patient->MRN ='"_pId_"'")
			set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_DataLake.Observation where Patient->MRN ='"_pId_"'")
			set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_DataLake.Encounter where Patient->MRN ='"_pId_"'")
			set objSQL = ##class(%SQL.Statement).%ExecDirect(,"delete from IRISDemo_DataLake.Patient where MRN ='"_pId_"'")
		}

		// First - a very sick patient
		write "Loading Very Sick PAtient", !
		set objPat = ##class(IRISDemo.DataLake.Patient).%New()
		set objPat.FHIRReferenceCode = "900001"
		set objPat.MRN = "900001"
		
		set objPat.DateOfBirth = $zdateh("1944-07-21",3) + ..#DATEWINDOW
		set objPat.Gender = "M"
		set objPat.FirstName = "Frederick"
		set objPat.LastName = "Masters"
		Set tSC = objPat.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSavePatientException")

		// Encounter #1
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.EncounterNumber = "9001001"
		set objEnc.FHIRReferenceCode = "9001001"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-170, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+3,objEnc.EncounterStart)		
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(8668)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		// Encounter #2
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9001002"
		set objEnc.EncounterNumber = "9001002"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-155, 3)_" 09:30:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+4,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(8668)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #3
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9001003"
		set objEnc.EncounterNumber = "9001003"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-140,3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+6,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(8668)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #4
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9001004"
		set objEnc.EncounterNumber = "9001004"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-120, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+5,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(8668)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #5
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9001005"
		set objEnc.EncounterNumber = "9001005"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-90, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+4,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(1487)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		// Encounter #6
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9001006"
		set objEnc.EncounterNumber = "9001006"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-60, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+2,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(8668)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")

		// Encounter #7
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9001007"
		set objEnc.EncounterNumber = "9001007"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-30, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+3,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(3604)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")	
		
		///Add encounters to CUBES
		for eId = 9001001:1:9001007 {
			Set encounter = ##class(IRISDemo.DataLake.Encounter).FHIRReferenceCodeIndexOpen(eId)
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACEV2",encounter.%Id())
			$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingLAceCube")
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("MLEncounterV2",encounter.%Id())
			$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingMLEncounterCube")
		}
		
		write "Loading Fairly Sick PAtient", !
		
		// Now a fairly sick patient
		set objPat = ##class(IRISDemo.DataLake.Patient).%New()
		set objPat.FHIRReferenceCode = "900002"
		set objPat.MRN = "900002"
		set objPat.DateOfBirth = $zdateh("1950-02-03",3) + ..#DATEWINDOW
		set objPat.Gender = "F"
		set objPat.FirstName = "Katherine"
		set objPat.LastName = "Smith"
		Set tSC = objPat.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSavePatientException")

		// Encounter #1
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9002001"
		set objEnc.EncounterNumber = "9002001"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-90, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+9,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		// Encounter #2
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9002002"
		set objEnc.EncounterNumber = "9002002"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-60, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+2,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(135)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		// Encounter #3		
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9002003"
		set objEnc.EncounterNumber = "9002003"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-45, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+2,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(4) //289
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		///Add encounters to CUBES
		for eId = 9002001:1:9002003 {
			Set encounter = ##class(IRISDemo.DataLake.Encounter).FHIRReferenceCodeIndexOpen(eId)
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACEV2",encounter.%Id())
			$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingLAceCube")
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("MLEncounterV2",encounter.%Id())
			$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingMLEncounterCube")
		}
		
		write "Loading Healthy PAtient", !
		
		// Now a fairly healthy patient
		set objPat = ##class(IRISDemo.DataLake.Patient).%New()
		set objPat.FHIRReferenceCode = "900003"
		set objPat.MRN = "900003"
		set objPat.DateOfBirth = $zdateh("1980-08-18",3) + ..#DATEWINDOW
		set objPat.Gender = "M"
		set objPat.FirstName = "James"
		set objPat.LastName = "Davidson"
		Set tSC = objPat.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSavePatientException")
		
		// Encounter #1
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9003001"
		set objEnc.EncounterNumber = "9003001"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-120, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+4,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "EMER"
		set objEnc.AdmitReason = "Emergency Room admission (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")

		// Encounter #2
		set objEnc = ##class(IRISDemo.DataLake.Encounter).%New()
		set objEnc.Patient = objPat
		set objEnc.FHIRReferenceCode = "9003002"
		set objEnc.EncounterNumber = "9003002"
		set objEnc.EncounterType = "I"
		Set objEnc.EncounterStart = $ZDATETIME($horolog-60, 3)_" 10:00:00"
		Set end = $SYSTEM.SQL.DATEADD("day",+2,objEnc.EncounterStart)
		Set $piece(end, " ", 2) = "17:00:00"
		Set objEnc.EncounterEnd = end
		Set objEnc.Status = "finished"
		set objEnc.ActCode = "IMP"
		set objEnc.AdmitReason = "Encounter for check up (procedure)"
		set objEnc.DischargeLocation = "H"
		Set tSC = objEnc.%Save() 
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveEncounterException")
		
		set objDgn = ##class(IRISDemo.DataLake.Diagnosis).%New()
		set objDgn.Patient = objPat
		set objDgn.Encounter = objEnc
		Set objDgn.SNOMEDCT = ##class(IRISDemo.DataLake.SNOMEDCT).%OpenId(4)
		set objDgn.OnsetDate = $ZDATEH(objEnc.EncounterStart, 3)
		set objDgn.Status = "active"
		Set tSC = objDgn.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "UpdateDemoPatientsSaveDiagnosisException")
		
		
		///Add encounters to CUBES
		for eId = 9003001:1:9003002 {
			Set encounter = ##class(IRISDemo.DataLake.Encounter).FHIRReferenceCodeIndexOpen(eId)
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACEV2",encounter.%Id())
			$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingLAceCube")
			set tSC = ##class(%DeepSee.Utils).%ProcessFact("MLEncounterV2",encounter.%Id())
			$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingMLEncounterCube")
		}
		
		Do ..CreateDemoEncounter("900001", -4, 1)
		Do ..CreateDemoEncounter("900002", -2, 1)
		Do ..CreateDemoEncounter("900003", -1, 1)
}

ClassMethod CreateDemoEncounter(pMRN As %String, pOffSet As %Integer, pDemoNumber As %Integer)
{

	set objEncounter = ##class(IRISDemo.DataLake.Encounter).%New()
	Set objEncounter.FHIRReferenceCode = pMRN_"-"_pDemoNumber
	Set objEncounter.EncounterNumber = pMRN_"-"_pDemoNumber
	Set objEncounter.EncounterType = "I" //Inpatient
	Set objEncounter.EncounterStart = $SYSTEM.SQL.DATEADD("day", pOffSet, $Horolog)
	Set objEncounter.EncounterEnd = $ZDATETIME($Horolog, 3)
	set objEncounter.ActCode = "IMP"
	set objEncounter.AdmitReason = "Encounter for problem"
	set objEncounter.Status = "active"
	set objEncounter.DischargeLocation = "H"
			
	Set objEncounter.Patient = ##class(IRISDemo.DataLake.Patient).MRNIndexOpen(pMRN)
	If objEncounter.Patient="" $$$ThrowException("PatientNotFoundException", "Patient with MRN "_pMRN_" was not found.")
		
	Set tSC = objEncounter.%Save()
	$$$ThrowStatusExceptionIfError(tSC, "EncounterSaveException")
	
	set tSC = ##class(%DeepSee.Utils).%ProcessFact("LACEV2",objEncounter.%Id())
	$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingLAceCube")
	set tSC = ##class(%DeepSee.Utils).%ProcessFact("MLEncounterV2",objEncounter.%Id())
	$$$ThrowStatusExceptionIfError(tSC, "ErrorUpdatingMLEncounterCube")
	
	write objEncounter.AdmitReason, !
	write "FINISHED CREATING DEMO ENCOUNTER", !
}

ClassMethod AddProbabilitiesToDemoEncounters()
{
	#Dim rsEncounters As %SQL.StatementResult
	#Dim oResultMetadata As %SQL.StatementMetadata
	#Dim oColumn As %SQL.StatementColumn
	
	set rsEncounters = ##class(%SQL.Statement).%ExecDirect(,"SELECT ID FROM IRISDemo_DataLake.Encounter WHERE EncounterNumber IN('900001-1', '900002-1', '900003-1')")
	$$$ThrowSQLExceptionIfResultError(rsEncounters, "SelectPatientsForExportException")
	
	While rsEncounters.%Next() 
	{
		Do ..AddReadmissionPredictionsToEncounter(rsEncounters.%Get("ID"))
	}
}

ClassMethod LoadPatientData()
{
	Set statement=##class(%SQL.Statement).%New()
	Set status=statement.%PrepareClassQuery("%Library.File", "FileSet")
	
	If $$$ISERR(status){ 
		Do $system.OBJ.DisplayError(status) 
	}
	
	Set resultset=statement.%Execute("/tmp/output/fhir/", "*json")
	
	Set fileCount=0
	While resultset.%Next() {
		Do ##class(IRISDemo.DataLake.Utils).LoadSyntheaFile(resultset.%Get("Name"))
		
		Write:(fileCount#100=0) "."
		Set fileCount=fileCount+1		
	}
	Write !, "-------------------------------FINISHED LOADING ",fileCount," FILES -----------------------------"
}

ClassMethod LoadSyntheaFile(pFileName As %String)
{
	Set tsc=$$$OK
	
	Set stream = ##class(%FileCharacterStream).%New()
	Set stream.Filename = pFileName
	
	Set fbundle = ##class(%Library.DynamicObject).%FromJSON(stream)
	If (fbundle '= "")
	{
		Do ..LoadPatientMedicalHistory(fbundle)
	}
	Else
	{
		Write "BUNDLE EMPTY"
		$$$ThrowException("FHIRBundleLoadException", "Error Loading: "_pFileName)
	}
}

ClassMethod LoadPatientMedicalHistory(pfhirBundle As %Library.DynamicObject)
{

	If pfhirBundle.%Get("resourceType") = "Bundle" {
		Set medicalHistoryEntries = pfhirBundle.%Get("entry")
		Set entryIter = medicalHistoryEntries.%GetIterator()
		
		While entryIter.%GetNext(.key , .value ) 
		{
	      If value.resource.resourceType = "Patient"
	      {
	      	Do ..LoadPatient(value.resource)
	      }
	      ElseIf value.resource.resourceType = "Encounter"
	      {
	      	Do ..LoadPatientEncounter(value.resource)
	      }
	      ElseIf value.resource.resourceType = "Observation"
	      {
	      	Do ..LoadPatientObservation(value.resource)
	      }
	      ElseIf value.resource.resourceType = "Condition"
	      {
	      	Do ..LoadPatientCondition(value.resource)
	      }
	      ElseIf value.resource.resourceType = "DiagnosticReport"
	      {
	      	Do ..LoadDiagnosticReport(value.resource)
	      }
		}
		
	}
}

ClassMethod LoadPatient(pPatientData As %Library.DynamicObject)
{
	
	#dim patient As IRISDemo.DataLake.Patient
	
	
	Set tSC = $$$OK
	Set patient = ##class(IRISDemo.DataLake.Patient).%New()
	
	Set patient.FHIRReferenceCode = pPatientData.id
	Set patient.Gender =$Extract($ZCONVERT(pPatientData.gender,"U"))
	Set patient.DateOfBirth = $ZDATEH(pPatientData.birthDate, 3)
	
	If pPatientData.%IsDefined("deceasedDateTime")
	{
		Set patient.DateOfDeath = $ZDATEH(pPatientData.deceasedDateTime,3)
	}
	
	Set patient.MaritalStatus = pPatientData.maritalStatus.text
	Set patient.MRN = ..GetMRNForPatient(pPatientData.identifier)
	
	Set nameIter = pPatientData.name.%GetIterator()
	While nameIter.%GetNext(.key , .value ) 
	{
      If value.use = "official"
      {
      	Set firstName = "" 
      	Set givenIter = value.given.%GetIterator()
      	While givenIter.%GetNext(.index, .name)
      	{
      		Set firstName = firstName _ " " _ name 
      	}
      	Set patient.FirstName = $ZSTRIP(firstName, "<>W")
      	Set patient.LastName = $ZSTRIP(value.%Get("family"), "<>W")
      }
	}
	Set tSC = patient.%Save()
	$$$ThrowStatusExceptionIfError(tSC, "PatientSaveException")
}

ClassMethod GetMRNForPatient(pPatientIdentifiers As %Library.DynamicArray) As %String
{
	Set identifierIter = pPatientIdentifiers.%GetIterator()
		
	while identifierIter.%GetNext(.key , .value ) 
	{
      If value.%IsDefined("type") && value.type.%IsDefined("coding")
      {
      	Set codingIter = value.type.coding.%GetIterator()
      	while codingIter.%GetNext(.codeName , .codeValue ) 
      	{
      		If codeValue.code = "MR"
      		{
      			return value.value
      		}
      	}
      }
	}
	
	return ""
}

/// ACt Code from FHIR Specification
/// https://www.hl7.org/fhir/v3/ActEncounterCode/vs.html
/// 
ClassMethod GetEncounterType(ActCode) As %String
{
	Set eType = "O"
	
	If (ActCode = "EMER") || ( ActCode = "FLD")
	{
		Set eType = "E"
	}
	
	ElseIf  (ActCode = "IMP") || (ActCode = "ACUTE") || (ActCode = "NONAC") 
	{
		Set eType = "I"
	}
	
	return eType
}

ClassMethod GetPatientForResource(pPatientReferencecode) As IRISDemo.DataLake.Patient
{
	Set patientFHIRReference = $REPLACE(pPatientReferencecode, "urn:uuid:", "")
	Set patient = ##class(IRISDemo.DataLake.Patient).FHIRReferenceCodeIndexOpen(patientFHIRReference)
	If patient = ""
	{
		$$$ThrowException("InvalidPatientLookupException", "There is no Patient entry for patient with reference ID:"_patientFHIRReference)
	}
	return patient
}

ClassMethod GetEncounterForResource(pEncounterReferencecode) As IRISDemo.DataLake.Encounter
{
	Set encounterFHIRReference = $REPLACE(pEncounterReferencecode, "urn:uuid:", "")
	Set encounter = ##class(IRISDemo.DataLake.Encounter).FHIRReferenceCodeIndexOpen(encounterFHIRReference)
	If encounter = ""
	{
		$$$ThrowException("InvalidEncounterLookupException", "There is no Encounter entry for encounter with reference ID:"_pEncounterReferencecode)
	}
	return encounter
}

ClassMethod GetTimeStamp(pDateString) As %TimeStamp
{
	return $Piece($Replace(pDateString, "T", " "), "+", 1, *-1)
}

ClassMethod GetBloodPressureObservation(pBloodPressureData As %Library.DynamicArray) As IRISDemo.DataLake.BloodPressureObservation
{

	#dim bpObservation AS IRISDemo.DataLake.BloodPressureObservation
	
	Set bpObservation = ##class(IRISDemo.DataLake.BloodPressureObservation).%New()
	
	Set bpIter = pBloodPressureData.%GetIterator()
		
	while bpIter.%GetNext(.key , .value ) 
	{
		
		If value.code.coding.%Get(0).%Get("code") = "8462-4"
		{
			Set bpObservation.Units = value.valueQuantity.unit
		  	Set bpObservation.DiastolicBloodPressure = value.valueQuantity.value
		}
		ElseIf value.code.coding.%Get(0).code = "8480-6"
		{
		  	Set bpObservation.SystolicBloodPressure = value.valueQuantity.value
		}
	}
	
	return bpObservation
}

ClassMethod LoadPatientEncounter(pEncounterData As %Library.DynamicObject)
{
	
	#dim encounter As IRISDemo.DataLake.Encounter
	
	Set tSC = $$$OK
	
	Set patient = ..GetPatientForResource(pEncounterData.subject.reference)
	
	Set encounter = ##class(IRISDemo.DataLake.Encounter).%New()
	Set encounter.FHIRReferenceCode = pEncounterData.id
	Set encounter.EncounterNumber = pEncounterData.id
	Set encounter.Patient = patient
	Set encounter.Status = pEncounterData.status
	Set encounter.ActCode = pEncounterData.class.code
	Set encounter.AdmitReason = pEncounterData.type.%Get(0).text
	Set encounter.SNOMEDTypeCode = pEncounterData.type.%Get(0).coding.%Get(0).code
	Set encounter.EncounterStart = ..GetTimeStamp(pEncounterData.period.start)
	If encounter.Status = "finished"{
		Set encounter.EncounterEnd = ..GetTimeStamp(pEncounterData.period.end)
	}
	Set encounter.EncounterType = ..GetEncounterType(pEncounterData.class.code)
	
	Set tSC = encounter.%Save()
	$$$ThrowStatusExceptionIfError(tSC, "EncounterSaveException")
}

ClassMethod LoadPatientObservation(pObservationData As %Library.DynamicObject)
{
	
	#dim observation As IRISDemo.DataLake.Observation
	
	Set tSC = $$$OK
	Set observation = ""
	Set observationValue = ""
	Set observationUnits = ""
	Set SNOMED= ""
	
	Set patient = ..GetPatientForResource(pObservationData.subject.reference)
	Set encounter = ..GetEncounterForResource(pObservationData.encounter.reference)
	
	Set LOINCCode=pObservationData.code.coding.%Get(0).code
	Set LOINCDescription=pObservationData.code.coding.%Get(0).display
	Set LOINC = ##class(IRISDemo.DataLake.LOINC).OpenOrCreate(LOINCCode,LOINCDescription)
	
	Set observationType = $ZSTRIP(pObservationData.category.%Get(0).coding.%Get(0).code, "<>W")
	
	If (LOINCDescription = "Blood Pressure"){
			Set observation = ..GetBloodPressureObservation(pObservationData.component)
	}Else{
	
		If pObservationData.%IsDefined("valueQuantity") {
			Set observationValue = pObservationData.valueQuantity.value
			Set observationUnits = pObservationData.valueQuantity.unit
		}
		ElseIf pObservationData.%IsDefined("valueCodeableConcept") {
			Set SNOMEDCode = pObservationData.valueCodeableConcept.coding.%Get(0).code
			Set SNOMEDDescription = pObservationData.valueCodeableConcept.coding.%Get(0).display
			Set SNOMED = ##class(IRISDemo.DataLake.SNOMEDCT).OpenOrCreate(SNOMEDCode,SNOMEDDescription)
		}
	
		If observationType = "laboratory"{
			Set observation = ##class(IRISDemo.DataLake.LabObservation).%New() 
			If observationValue '= "" {
				Set observation.Value = observationValue
				Set observation.Units = observationUnits 
			}Else{
				Set observation.SNOMEDValue = SNOMED
			}
			
		}ElseIf observationType = "vital-signs"{
			Set observation = ##class(IRISDemo.DataLake.VitalSignObservation).%New()
			Set observation.Value = observationValue
			Set observation.Units = observationUnits
		
		}ElseIf (observationType = "survey") || (observationType = "exam"){
			Set observation = ##class(IRISDemo.DataLake.SurveyObservation).%New()
			If observationValue '= "" {
				Set observation.Value = observationValue
				Set observation.Units = observationUnits 
			}Else{
				Set observation.SNOMEDValue = SNOMED
			}
		}		
	}
	
	If observation '= "" {
		Set observation.Code = LOINC
		Set observation.FHIRReferenceCode = pObservationData.id
		Set observation.ObservationType = observationType
		Set observation.Encounter = encounter
		Set observation.Patient = patient
		Set observation.EffectiveDate = ..GetTimeStamp(pObservationData.effectiveDateTime)
		
		Set tSC = observation.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "ObservationSaveException")
	}
}

ClassMethod LoadPatientCondition(pConditionData As %Library.DynamicObject)
{

	#dim diagnosis As IRISDemo.DataLake.Diagnosis
	Set tSC = $$$OK
	
	Set patient = ..GetPatientForResource(pConditionData.subject.reference)
	Set encounter = ..GetEncounterForResource(pConditionData.encounter.reference)
	
	Set diagnosis = ##class(IRISDemo.DataLake.Diagnosis).%New()
	
	Set diagnosis.Patient = patient
	Set diagnosis.Encounter = encounter
	Set diagnosis.FHIRReferenceCode = pConditionData.id
	Set diagnosis.Status = pConditionData.clinicalStatus.coding.%Get(0).code
	Set diagnosis.OnsetDate = $ZDATEH(pConditionData.onsetDateTime, 3)
	If diagnosis.Status = "resolved" {
		Set diagnosis.AbatementDate = $ZDATEH(pConditionData.abatementDateTime, 3)
	}
	
	Set SNOMEDCode = pConditionData.code.coding.%Get(0).code
	Set SNOMEDDescription = pConditionData.code.coding.%Get(0).display
	Set SNOMED = ##class(IRISDemo.DataLake.SNOMEDCT).OpenOrCreate(SNOMEDCode,SNOMEDDescription)
	Set diagnosis.SNOMEDCT = SNOMED
	Set tSC = diagnosis.%Save()
	$$$ThrowStatusExceptionIfError(tSC, "ConditionSaveException")
}

ClassMethod LoadDiagnosticReport(pDiagnosticReportData As %Library.DynamicObject)
{
	#dim diagnosticReport As IRISDemo.DataLake.DiagnosticReport
	Set tSC = $$$OK
	
	Set patient = ..GetPatientForResource(pDiagnosticReportData.subject.reference)
	Set encounter = ..GetEncounterForResource(pDiagnosticReportData.encounter.reference)
	
	Set diagnosticReport = ##class(IRISDemo.DataLake.DiagnosticReport).%New()
	Set diagnosticReport.FHIRReferenceCode = pDiagnosticReportData.id
	Set diagnosticReport.Patient = patient
	Set diagnosticReport.Encounter = encounter
	Set diagnosticReport.ReportType = $ZSTRIP(pDiagnosticReportData.category.%Get(0).coding.%Get(0).code, "<>W")
	Set diagnosticReport.IssueDate = ..GetTimeStamp(pDiagnosticReportData.issued)
	
	Set resultsIter = pDiagnosticReportData.result.%GetIterator()
		
	while resultsIter.%GetNext(.key , .value ) {
		Set observationReference = $REPLACE(value.reference, "urn:uuid:", "")
		Set associatedObservation = ##class(IRISDemo.DataLake.Observation).FHIRReferenceCodeIndexOpen(observationReference)
		If associatedObservation '= "" {
			Do diagnosticReport.Observations.Insert(associatedObservation)
			Set associatedObservation.DiagnosticReport = diagnosticReport
			Do associatedObservation.%Save()
		}Else{
			write !!, "NO Saved Observation FOR: "_key
		}
	}
	
	Set tSC = diagnosticReport.%Save()
	$$$ThrowStatusExceptionIfError(tSC, "DiagnosticReportSaveException")
}

}
