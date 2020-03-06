Class ML.Model.BO.Executor.ScoreResponse Extends (%Persistent, Ens.Response)
{

Property ModelOutput As array Of %String;

Storage Default
{
<Data name="ModelOutput">
<Attribute>ModelOutput</Attribute>
<Structure>subnode</Structure>
<Subscript>"ModelOutput"</Subscript>
</Data>
<Data name="ScoreResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^ML.Model.BOB7C2.ScoreResponseD</DataLocation>
<DefaultData>ScoreResponseDefaultData</DefaultData>
<IdLocation>^ML.Model.BOB7C2.ScoreResponseD</IdLocation>
<IndexLocation>^ML.Model.BOB7C2.ScoreResponseI</IndexLocation>
<StreamLocation>^ML.Model.BOB7C2.ScoreResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
