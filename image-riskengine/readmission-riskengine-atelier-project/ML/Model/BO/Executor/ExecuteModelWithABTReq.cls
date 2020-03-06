/// This request will use the provided SourceId to identify the record on the ABT from which to fetch 
/// the required feature row to run the configured PMML model on the executor.
/// SourceID is the ID of the base table used to build the cube from which the ABT was derived.
Class ML.Model.BO.Executor.ExecuteModelWithABTReq Extends (%Persistent, Ens.Request)
{

Property SourceID As %String [ Required ];

Storage Default
{
<Data name="ExecuteModelWithABTReqDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceID</Value>
</Value>
</Data>
<DataLocation>^ML.Model.BB7C2.ExecuteMode42A8D</DataLocation>
<DefaultData>ExecuteModelWithABTReqDefaultData</DefaultData>
<IdLocation>^ML.Model.BB7C2.ExecuteMode42A8D</IdLocation>
<IndexLocation>^ML.Model.BB7C2.ExecuteMode42A8I</IndexLocation>
<StreamLocation>^ML.Model.BB7C2.ExecuteMode42A8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
