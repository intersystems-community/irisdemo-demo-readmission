Class ML.Model.BO.Executor.SimpleScoreRequest Extends (%Persistent, Ens.Request)
{

Property MLOperationName As %String;

Property MLModelDataForPrediction As array Of %String;

Storage Default
{
<Data name="MLModelDataForPrediction">
<Attribute>MLModelDataForPrediction</Attribute>
<Structure>subnode</Structure>
<Subscript>"MLModelDataForPrediction"</Subscript>
</Data>
<Data name="SimpleScoreRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MLOperationName</Value>
</Value>
</Data>
<DataLocation>^ML.Model.BB7C2.SimpleScoreCCF7D</DataLocation>
<DefaultData>SimpleScoreRequestDefaultData</DefaultData>
<IdLocation>^ML.Model.BB7C2.SimpleScoreCCF7D</IdLocation>
<IndexLocation>^ML.Model.BB7C2.SimpleScoreCCF7I</IndexLocation>
<StreamLocation>^ML.Model.BB7C2.SimpleScoreCCF7S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
