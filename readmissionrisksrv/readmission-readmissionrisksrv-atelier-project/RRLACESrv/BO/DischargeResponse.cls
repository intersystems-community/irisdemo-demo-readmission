Class RRLACESrv.BO.DischargeResponse Extends Ens.Response [ ProcedureBlock ]
{

Property DischargeResult As %xsd.base64Binary;

Property EncounterID As %String;

Storage Default
{
<Data name="DischargeResponseDefaultData">
<Subscript>"DischargeResponse"</Subscript>
<Value name="1">
<Value>DischargeResult</Value>
</Value>
<Value name="2">
<Value>EncounterID</Value>
</Value>
</Data>
<DefaultData>DischargeResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
