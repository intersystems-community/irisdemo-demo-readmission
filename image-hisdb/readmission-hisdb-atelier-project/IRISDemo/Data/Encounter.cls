Include DEMOMACROS

Class IRISDemo.Data.Encounter Extends %Persistent
{
	Property EncounterNumber As %String [ Required ];
	
	Property AdmissionSource As %String;
	
	Property Patient As Patient [ Required ];
	
	Property EncounterType As %String (VALUELIST=",I,O,E", DISPLAYLIST=",Inpatient,Outpatient,Emergency") [ Required ];
	
	Property EncounterStart As %TimeStamp [ Required ];
	
	Property EncounterEnd As %TimeStamp;
	
	Property EncounterStatus As %String (VALUELIST=",P,A,D", DISPLAYLIST=",Pre-Admitted,Admitted,Discharged") [ InitialExpression = {"A"} ];
	
	Property DischargeDestination As EncounterDischargeDest;
	
	Property LACEScoreAggregate As %Integer;

	Property LACEScore As %String;
	
	Property ReadmissionProbability As %Double;
	
	ForeignKey PatientFK(Patient) References Patient();
	
	ForeignKey DischargeDestinationFK(DischargeDestination) References EncounterDischargeDest();
	
	Index PatientIndex On Patient;
	
	Index EncounterNumberIndex On EncounterNumber [ Unique ];
	
	/// Called from REST service on IRISDemo.REST.Encounter
	Method Discharge(pDischargeDestCode As %String = "")
	{
		Set ..EncounterStatus="D"
		Set ..EncounterEnd = $ZDATETIME($HOROLOG,3,1)
		
		If pDischargeDestCode'=""
		{
			Set ..DischargeDestination=##class(EncounterDischargeDest).DischargeDestCodeIndexOpen(pDischargeDestCode)
			If '$IsObject(..DischargeDestination) $$$ThrowException("DischargeDestinationNotFoundException", "Discharge Destination Code: "_pDischargeDestCode)
		}
		
		Set tSC = ..%Save()
		$$$ThrowStatusExceptionIfError(tSC, "DischargeException")
	}
	
	ClassMethod UpdateProbabilities(encounterID As %Integer, laceScoreAggregate As %Integer, laceScore As %String, mlProbability As %Double) As %Status
	{
		Set %NOHL7=1
			
		Set obj = ##class(IRISDemo.Data.Encounter).EncounterNumberIndexOpen(encounterID)
		If '$IsObject(obj) $$$ThrowException("EncounterNotFoundException", "encounterId: "_encounterId)
			
		Set obj.LACEScoreAggregate = laceScoreAggregate
		Set obj.LACEScore = laceScore
		Set obj.ReadmissionProbability = mlProbability
		
		Set tSC = obj.%Save()
		
		kill %NOHL7
		
		return tSC
	}
	
	/// Setting %NOHL7 to 1 will prevent HL7 messages from being triggered while we load this record. 
	/// A variable name that starts with % is globally available for everyone on this process.
	/// Do not confuse "globally available on this process" with globals. Global variable names
	/// start with a ^ (caret) and they are persisted on disk which makes them globally available
	/// for ALL PROCESSES, even after the system restarts until someone explicitly kills it. 
	/// A variable name that starts with a % will be globally available on this process only and will
	/// die with the process. 
	Trigger OnUpdate [ Event = INSERT/UPDATE, Time = AFTER, Foreach = row/object ]
	{
		Quit:$Get(%NOHL7)=1
		
		// %oper is a special variable that can tell us what is the event (INSERT,UPDATE or DELETE)
		// The following code is an oversimplification. We just want to show how one could go about doing this
		If (%oper="INSERT")
		{
			If ({EncounterStatus*N}="P")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A05", {ID})
			}
			ElseIf ({EncounterStatus*N}="Admitted")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A01", {ID})
			}
			Else
			{
				// We don't want to send HL7 messages for admissions that have been created
				// with the Discharged status.
			}
		}
		ElseIf (%oper="UPDATE")
		{
			// If this encounter was previously with the Admitted status and is now on the Discharged
			// status, then we should trigger an ADT_A03
			If ({EncounterStatus*O}="P") && ({EncounterStatus*N}="A")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A01", {ID})
			}
			ElseIf ({EncounterStatus*O}="A") && ({EncounterStatus*N}="D")
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A03", {ID})
			}
			/*If I am Resetting the Demo to update the start date*/
			ElseIf ({EncounterStart*O}'={EncounterStart*N})
			{
				Do ##class(IRISDemo.BS.AppTrigger.Service).TriggerEvent("ADT_A08", {ID})
			}
		}
		Else
		{
			// You should NEVER delete anything on a clinical database.
		}
	}

Storage Default
{
<Data name="EncounterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
<Value name="3">
<Value>Patient</Value>
</Value>
<Value name="4">
<Value>EncounterType</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>EndTime</Value>
</Value>
<Value name="9">
<Value>EncounterStatus</Value>
</Value>
<Value name="10">
<Value>DischargeDestination</Value>
</Value>
<Value name="11">
<Value>AdmissionSource</Value>
</Value>
<Value name="12">
<Value>LACEScoreAggregate</Value>
</Value>
<Value name="13">
<Value>LACEScore</Value>
</Value>
<Value name="14">
<Value>ReadmissionProbability</Value>
</Value>
<Value name="15">
<Value>EncounterStart</Value>
</Value>
<Value name="16">
<Value>EncounterEnd</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.EncounterD</DataLocation>
<DefaultData>EncounterDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.EncounterD</IdLocation>
<IndexLocation>^IRISDemo.Data.EncounterI</IndexLocation>
<StreamLocation>^IRISDemo.Data.EncounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}