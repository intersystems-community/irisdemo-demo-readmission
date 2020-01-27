Class RRLACESrv.BO.RiskRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "RRLACESrv.BO.RiskResponse";

Property PatientID As %String;

Property EncounterNumber As %String;

Storage Default
{
<Data name="RiskRequestDefaultData">
<Subscript>"RiskRequest"</Subscript>
<Value name="1">
<Value>PatientID</Value>
</Value>
<Value name="2">
<Value>EncounterNumber</Value>
</Value>
</Data>
<DefaultData>RiskRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
