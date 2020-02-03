Class RRLACESrv.BO.UpdateEncounterRequest Extends (%Persistent,Ens.Request)
{
Parameter RESPONSECLASSNAME = "RRLACESrv.BO.UpdateEncounterResponse";

Property PatientID As %String;

Property EncounterNumber As %String;

Property EncounterType As %String;

Property AdmissionSource As %String;

Property EncounterStart As %TimeStamp;

Property EncounterEnd As %TimeStamp;

Property DischargeLocation As %String;

Property UpdateMessageType As %String (VALUELIST = ",A01,A03,A08");

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
<Value>EncounterStart</Value>
</Value>
<Value name="7">
<Value>EncounterEnd</Value>
</Value>
<Value name="8">
<Value>DischargeLocation</Value>
</Value>
<Value name="9">
<Value>UpdateMessageType</Value>
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