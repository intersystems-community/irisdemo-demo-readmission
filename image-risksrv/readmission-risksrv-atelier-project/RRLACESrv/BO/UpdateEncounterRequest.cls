Class RRLACESrv.BO.UpdateEncounterRequest Extends (%Persistent,Ens.Request)
{
Parameter RESPONSECLASSNAME = "RRLACESrv.BO.UpdateEncounterResponse";

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
<Data name="UpdateEncounterRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EncounterNumber</Value>
</Value>
<Value name="4">
<Value>EncounterType</Value>
</Value>
<Value name="5">
<Value>AdmissionSource</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>StartTime</Value>
</Value>
<Value name="8">
<Value>EndDate</Value>
</Value>
<Value name="9">
<Value>EndTime</Value>
</Value>
<Value name="10">
<Value>DischargeLocation</Value>
</Value>
</Data>
<DataLocation>^RRLACESrv.BO.UpdateEncouFB16D</DataLocation>
<DefaultData>UpdateEncounterRequestDefaultData</DefaultData>
<IdLocation>^RRLACESrv.BO.UpdateEncouFB16D</IdLocation>
<IndexLocation>^RRLACESrv.BO.UpdateEncouFB16I</IndexLocation>
<StreamLocation>^RRLACESrv.BO.UpdateEncouFB16S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}