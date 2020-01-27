Class RRLACESrv.BO.AdmitRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "RRLACESrv.BO.AdmitResponse";

Property PatientID As %String;

Property EncounterNumber As %String;

Property EncounterType As %String;

Property StartDate As %Date;

Property StartTime As %Time;

Property AdmissionSource As %String;

Storage Default
{
<Data name="AdmitRequestDefaultData">
<Subscript>"AdmitRequest"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
<Value name="3">
<Value>EncounterType</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>AdmissionSource</Value>
</Value>
</Data>
<DefaultData>AdmitRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
