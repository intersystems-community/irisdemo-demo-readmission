Include DEMOMACROS

Class PublishedABT.MLEncounterDecisionTrees Extends ML.ABT.AbstractABT [ Not ProcedureBlock ]
{

ClassMethod MLEncounterDecisionTreesGetFeaturesClose(ByRef qHandle As %Binary, pSourceId As %String) As %Status
{
 Quit $$$OK
}

ClassMethod MLEncounterDecisionTreesGetFeaturesExecute(ByRef qHandle As %Binary, pSourceId As %String) As %Status
{
 Set tSC = $$$OK
 Try {
   Set pSourceId=$Get(pSourceId)
   If pSourceId="" {
     Set qHandle("RS") = ##class(%SQL.Statement).%ExecDirect(,"select * from IRISDemo_Cube_MLEncounter.Fact")
   } Else {
     Set tID = ##class(ML.ABT.Utils).GetFactIdForCubeSourceId("MLEncounter", pSourceId)
     Set qHandle("RS") = ##class(%SQL.Statement).%ExecDirect(,"select * from IRISDemo_Cube_MLEncounter.Fact where ID="_tID)
   }
   $$$ThrowSQLExceptionIfResultError(qHandle("RS"), "ABTFactTableQueryException")
 } Catch (oException) { Set tSC = oException.AsStatus() }
 Quit tSC
}

ClassMethod MLEncounterDecisionTreesGetFeaturesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 Set tSC = $$$OK
 Try {
   Set Row=^PublishedABT("MLEncounterDecisionTrees","DEFAULTVALUES")
   Set oRS = qHandle("RS")
   If oRS.%Next(.tSC) {

     //Comorbidities
     Set tColumnValue = oRS.%Get("Comorbidities")
     Set listRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT * from IRISDemo_Cube_MLEncounter.Comorbidities Where ID IN ( "_tColumnValue_" )")
     $$$ThrowSQLExceptionIfResultError(listRS, "StarTableFetchException")
     While listRS.%Next() {
       Set explodedPropertySuffix = listRS.%Get("Comorbidities")
       If explodedPropertySuffix '= "<null>" {
         Set explodedPropertySuffix = $Translate(explodedPropertySuffix, " ", "_")
         Set fullExplodedPropertyName = "Comorbidities_"_explodedPropertySuffix
         Set iColumnIndex = ^PublishedABT("MLEncounterDecisionTrees","PMap1","Comorbidities", fullExplodedPropertyName)
         Set $List(Row,iColumnIndex)=1
       }
     }

     //CurrentComorbidities
     Set tColumnValue = oRS.%Get("CurrentComorbidities")
     Set listRS = ##class(%SQL.Statement).%ExecDirect(,"SELECT * from IRISDemo_Cube_MLEncounter.CurrentComorbidities Where ID IN ( "_tColumnValue_" )")
     $$$ThrowSQLExceptionIfResultError(listRS, "StarTableFetchException")
     While listRS.%Next() {
       Set explodedPropertySuffix = listRS.%Get("CurrentComorbidities")
       If explodedPropertySuffix '= "<null>" {
         Set explodedPropertySuffix = $Translate(explodedPropertySuffix, " ", "_")
         Set fullExplodedPropertyName = "CurrentComorbidities_"_explodedPropertySuffix
         Set iColumnIndex = ^PublishedABT("MLEncounterDecisionTrees","PMap1","CurrentComorbidities", fullExplodedPropertyName)
         Set $List(Row,iColumnIndex)=1
       }
     }

     Set $List(Row,21) = oRS.%Get("DxAdmissionSource")

     Set $List(Row,22) = oRS.%Get("DxAgeGroup")

     Set $List(Row,23) = oRS.%Get("DxDischargeLocation")

     Set $List(Row,24) = oRS.%Get("DxEncounterType")

     Set $List(Row,25) = oRS.%Get("DxEndDateDayOfMonth")

     Set $List(Row,26) = oRS.%Get("DxEndDateDayOfWeek")

     Set $List(Row,27) = oRS.%Get("DxEndDateMonth")

     Set $List(Row,28) = oRS.%Get("DxEndDateYear")

     Set $List(Row,29) = oRS.%Get("DxGenderViaPatient")

     Set $List(Row,30) = oRS.%Get("DxStartDateDayOfMonth")

     Set $List(Row,31) = oRS.%Get("DxStartDateDayOfWeek")

     Set $List(Row,32) = oRS.%Get("DxStartDateMonth")

     Set $List(Row,33) = oRS.%Get("DxStartDateYear")

     Set $List(Row,34) = oRS.%Get("MxAgeDischarged")

     Set $List(Row,35) = oRS.%Get("MxAlcohol")

     Set $List(Row,36) = oRS.%Get("MxDrugs")

     Set $List(Row,37) = oRS.%Get("MxExSmoker")

     Set $List(Row,38) = oRS.%Get("MxIsReAdmit")

     Set $List(Row,39) = oRS.%Get("MxLOS")

     Set $List(Row,40) = oRS.%Get("MxNeverSmoked")

     Set $List(Row,41) = oRS.%Get("MxPatientIDViaPatient")

     Set $List(Row,42) = oRS.%Get("MxSmoker")

     Set $List(Row,43) = oRS.%Get("MxWillReAdmit")
   } Else {
     $$$ThrowStatusExceptionIfError(tSC, "ABTFactTableFetchException")
     Set AtEnd=1
   }
 } Catch (oException) { Set tSC = oException.AsStatus() }
 Quit tSC
}

Query MLEncounterDecisionTreesGetFeatures(pSourceId As %String) As %Query(ROWSPEC = "Comorbidities_CEREBROVASCULAR_DISEASE:%Integer,Comorbidities_CHRONIC_PULMONARY_DISEASE:%Integer,Comorbidities_CONGESTIVE_HEART_FAILURE:%Integer,Comorbidities_DIABETES_WITHOUT_CHRONIC_COMPLICATION:%Integer,Comorbidities_HEMIPLEGIA_OR_PARAPLEGIA:%Integer,Comorbidities_METASTATIC_SOLID_TUMOR:%Integer,Comorbidities_MILD_LIVER_DISEASE:%Integer,Comorbidities_MODERATE_OR_SEVERE_LIVER_DISEASE:%Integer,Comorbidities_MYOCARDIAL_INFARCTION:%Integer,Comorbidities_PERIPHERY_VASCULAR_DISEASE:%Integer,Comorbidities_RENAL_DISEASE:%Integer,CurrentComorbidities_CEREBROVASCULAR_DISEASE:%Integer,CurrentComorbidities_CHRONIC_PULMONARY_DISEASE:%Integer,CurrentComorbidities_CONGESTIVE_HEART_FAILURE:%Integer,CurrentComorbidities_METASTATIC_SOLID_TUMOR:%Integer,CurrentComorbidities_MILD_LIVER_DISEASE:%Integer,CurrentComorbidities_MODERATE_OR_SEVERE_LIVER_DISEASE:%Integer,CurrentComorbidities_MYOCARDIAL_INFARCTION:%Integer,CurrentComorbidities_PERIPHERY_VASCULAR_DISEASE:%Integer,CurrentComorbidities_RENAL_DISEASE:%Integer,DxAdmissionSource:%Integer,DxAgeGroup:%Integer,DxDischargeLocation:%Integer,DxEncounterType:%Integer,DxEndDateDayOfMonth:%Integer,DxEndDateDayOfWeek:%Integer,DxEndDateMonth:%Integer,DxEndDateYear:%Integer,DxGenderViaPatient:%Integer,DxStartDateDayOfMonth:%Integer,DxStartDateDayOfWeek:%Integer,DxStartDateMonth:%Integer,DxStartDateYear:%Integer,MxAgeDischarged:%Integer,MxAlcohol:%Double,MxDrugs:%Double,MxExSmoker:%Double,MxIsReAdmit:%Double,MxLOS:%Integer,MxNeverSmoked:%Double,MxPatientIDViaPatient:%String,MxSmoker:%Double,MxWillReAdmit:%Double") [ SqlName = MLEncounterDecisionTreesGetFeatures, SqlProc ]
{
}

}
