Class RRLACESrv.BO.RiskResponse Extends Ens.Response [ ProcedureBlock ]
{

Property RiskResult As %String;

Storage Default
{
<Data name="RiskResponseDefaultData">
<Subscript>"RiskResponse"</Subscript>
<Value name="1">
<Value>RiskResult</Value>
</Value>
</Data>
<DefaultData>RiskResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
