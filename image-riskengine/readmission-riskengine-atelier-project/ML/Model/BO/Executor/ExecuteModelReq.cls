/// Allows you to run the PMML model specified on the Executor with the data provided on ModelData array
Class ML.Model.BO.Executor.ExecuteModelReq Extends (%Persistent, Ens.Request)
{

/// Array of string values containing model input values
Property ModelData As array Of %String;

Storage Default
{
<Data name="ExecuteModelReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="ModelData">
<Attribute>ModelData</Attribute>
<Structure>subnode</Structure>
<Subscript>"ModelData"</Subscript>
</Data>
<DataLocation>^ML.Model.BB7C2.ExecuteModeBDD2D</DataLocation>
<DefaultData>ExecuteModelReqDefaultData</DefaultData>
<IdLocation>^ML.Model.BB7C2.ExecuteModeBDD2D</IdLocation>
<IndexLocation>^ML.Model.BB7C2.ExecuteModeBDD2I</IndexLocation>
<StreamLocation>^ML.Model.BB7C2.ExecuteModeBDD2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
