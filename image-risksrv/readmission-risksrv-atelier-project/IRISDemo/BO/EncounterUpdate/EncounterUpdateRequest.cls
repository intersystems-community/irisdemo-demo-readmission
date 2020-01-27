Class IRISDemo.BO.EncounterUpdate.EncounterUpdateRequest Extends (%Persistent, Ens.Request)
{

Property EncounterID As %String;

Property LACEScoreAggregate As %Integer;

Property LACEScore As %String;

Property MLPrediction As %Double;

Storage Default
{
<Data name="EncounterUpdateRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EncounterID</Value>
</Value>
<Value name="3">
<Value>LACEScoreAggregate</Value>
</Value>
<Value name="4">
<Value>LACEScore</Value>
</Value>
<Value name="5">
<Value>MLPrediction</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.B9F2B.EncounterUp5A69D</DataLocation>
<DefaultData>EncounterUpdateRequestDefaultData</DefaultData>
<IdLocation>^IRISDemo.B9F2B.EncounterUp5A69D</IdLocation>
<IndexLocation>^IRISDemo.B9F2B.EncounterUp5A69I</IndexLocation>
<StreamLocation>^IRISDemo.B9F2B.EncounterUp5A69S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
