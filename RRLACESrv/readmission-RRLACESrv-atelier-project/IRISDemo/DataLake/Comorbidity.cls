Include DEMOMACROS

Class IRISDemo.DataLake.Comorbidity Extends %Persistent
{

Property Description As %String(MAXLEN = "") [ Required ];

Property CharlsonComorbidityIndex As %Integer [ Required ];

Index DescriptionIndex On Description [ Unique ];

ClassMethod OpenOrCreate(pDescription As %String, pCharlsonComorbidityIndex As %Integer = 0) As Comorbidity
{
	Set obj = ..DescriptionIndexOpen(pDescription)
	
	If obj="" 
	{
		Set obj = ..%New()
		Set obj.Description=pDescription
		Set obj.CharlsonComorbidityIndex=pCharlsonComorbidityIndex
		Set tSC = obj.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "ComorbiditySaveError")
	}
	
	Quit obj
}

Storage Default
{
<Data name="ComorbidityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>CharlsonComorbidityIndex</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.ComorbidityD</DataLocation>
<DefaultData>ComorbidityDefaultData</DefaultData>
<ExtentSize>15</ExtentSize>
<IdLocation>^IRISDemo.DataLake.ComorbidityD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.ComorbidityI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>1.4</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="CharlsonComorbidityIndex">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="Description">
<AverageFieldSize>26.33</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DescriptionIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.ComorbidityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
