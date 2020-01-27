Class RRLACESrv.BO.AdmitResponse Extends Ens.Response [ ProcedureBlock ]
{

Property AdmitResult As %xsd.base64Binary;

Storage Default
{
<Data name="AdmitResponseDefaultData">
<Subscript>"AdmitResponse"</Subscript>
<Value name="1">
<Value>AdmitResult</Value>
</Value>
</Data>
<DefaultData>AdmitResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
