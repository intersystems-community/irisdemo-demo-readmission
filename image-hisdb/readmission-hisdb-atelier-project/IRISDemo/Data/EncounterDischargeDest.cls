Class IRISDemo.Data.EncounterDischargeDest Extends %Persistent
{
	Property Code As %String [ Required ];
	
	Property Description As %String [ Required ];
	
	Index DischargeDestCodeIndex On Code [ Unique ];
	
Storage Default
{
<Data name="EncounterDischargeDestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.EncounterDi3AE0D</DataLocation>
<DefaultData>EncounterDischargeDestDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.EncounterDi3AE0D</IdLocation>
<IndexLocation>^IRISDemo.Data.EncounterDi3AE0I</IndexLocation>
<StreamLocation>^IRISDemo.Data.EncounterDi3AE0S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}