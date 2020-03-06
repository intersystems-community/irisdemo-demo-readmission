/// Allows you to execute a random PMML model (specified by name on ModelClassName) with an array of parameters.
/// This request can be sent to any available Executor. The Executor will ignore its ABT and run the model with
/// the provided data.
Class ML.Model.BO.Executor.ExecuteParamModelReq Extends (%Persistent, ML.Model.BO.Executor.ExecuteModelReq)
{

Property ModelClassName As %String [ Required ];

Storage Default
{
<Data name="ExecuteParamModelReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelClassName</Value>
</Value>
</Data>
<Data name="ModelData">
<Attribute>ModelData</Attribute>
<Structure>subnode</Structure>
<Subscript>"ModelData"</Subscript>
</Data>
<DataLocation>^ML.Model.BB7C2.ExecuteParamDACD</DataLocation>
<DefaultData>ExecuteParamModelReqDefaultData</DefaultData>
<IdLocation>^ML.Model.BB7C2.ExecuteParamDACD</IdLocation>
<IndexLocation>^ML.Model.BB7C2.ExecuteParamDACI</IndexLocation>
<StreamLocation>^ML.Model.BB7C2.ExecuteParamDACS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
