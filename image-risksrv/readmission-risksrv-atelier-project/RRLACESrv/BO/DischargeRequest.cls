Class RRLACESrv.BO.DischargeRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "RRLACESrv.BO.DischargeResponse";

Property PatientID As %String;

Property EncounterNumber As %String;

Property EncounterType As %String;

Property AdmissionSource As %String;

Property StartDate As %Date(FORMAT = 3);

Property StartTime As %Time(FORMAT = 2);

Property EndDate As %Date(FORMAT = 3);

Property EndTime As %Time(FORMAT = 2);

Property DischargeLocation As %String;

Storage Default
{
<Data name="DischargeRequestDefaultData">
<Subscript>"DischargeRequest"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>EndTime</Value>
</Value>
<Value name="5">
<Value>DischargeLocation</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>StartTime</Value>
</Value>
<Value name="8">
<Value>EncounterType</Value>
</Value>
<Value name="9">
<Value>AdmissionSource</Value>
</Value>
</Data>
<DefaultData>DischargeRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
