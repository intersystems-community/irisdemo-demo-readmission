Class RRLACESrv.BO.UpdateEncounterResponse Extends (%Persistent,Ens.Response)
{

Property UpdateEncounterResult As %xsd.base64Binary;

Property EncounterID As %String;

Storage Default
{
<Data name="UpdateEncounterResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UpdateEncounterResult</Value>
</Value>
<Value name="3">
<Value>EncounterID</Value>
</Value>
</Data>
<DataLocation>^RRLACESrv.BO.UpdateEncouE9E6D</DataLocation>
<DefaultData>UpdateEncounterResponseDefaultData</DefaultData>
<IdLocation>^RRLACESrv.BO.UpdateEncouE9E6D</IdLocation>
<IndexLocation>^RRLACESrv.BO.UpdateEncouE9E6I</IndexLocation>
<StreamLocation>^RRLACESrv.BO.UpdateEncouE9E6S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}