Class ML.Model.BO.Executor.ExecuteModelResp Extends (%Persistent, Ens.Response)
{

Property ModelOutput As array Of %String;

Storage Default
{
<Data name="ExecuteModelRespDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="ModelOutput">
<Attribute>ModelOutput</Attribute>
<Structure>subnode</Structure>
<Subscript>"ModelOutput"</Subscript>
</Data>
<DataLocation>^ML.Model.BB7C2.ExecuteModeD93DD</DataLocation>
<DefaultData>ExecuteModelRespDefaultData</DefaultData>
<IdLocation>^ML.Model.BB7C2.ExecuteModeD93DD</IdLocation>
<IndexLocation>^ML.Model.BB7C2.ExecuteModeD93DI</IndexLocation>
<StreamLocation>^ML.Model.BB7C2.ExecuteModeD93DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
