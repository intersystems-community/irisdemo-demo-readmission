Class IRISDemo.BS.AppTrigger.TriggerEventReq Extends (%Persistent,Ens.Request)
{
	Property TriggerEvent As %String [ Required ];
	
	Property ObjectId As %String [ Required ];
	


Storage Default
{
<Data name="TriggerEventReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TriggerEvent</Value>
</Value>
<Value name="3">
<Value>ObjectId</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.BBA72.TriggerEvenB726D</DataLocation>
<DefaultData>TriggerEventReqDefaultData</DefaultData>
<IdLocation>^IRISDemo.BBA72.TriggerEvenB726D</IdLocation>
<IndexLocation>^IRISDemo.BBA72.TriggerEvenB726I</IndexLocation>
<StreamLocation>^IRISDemo.BBA72.TriggerEvenB726S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}