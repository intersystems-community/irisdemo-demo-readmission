Include DEMOMACROS

Class IRISDemo.DataLake.LOINC Extends %Persistent
{

Property LOINCCode As %String [ Required ];

Property LOINCDescription As %String(MAXLEN = "") [ Required ];

Index LOINCCodeIndex On LOINCCode [ Unique ];

ClassMethod OpenOrCreate(pLOINCCode As %String, pLOINCDescription As %String) As LOINC
{
	Set obj = ##class(IRISDemo.DataLake.LOINC).LOINCCodeIndexOpen(pLOINCCode)
	If obj="" 
	{
		Set obj = ..%New()
		Set obj.LOINCCode=pLOINCCode
		Set obj.LOINCDescription=pLOINCDescription
		Set tSC = obj.%Save()
		$$$ThrowStatusExceptionIfError(tSC, "LOINCSaveError")
	}
	
	Quit obj
}

Storage Default
{
<Data name="LOINCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LOINCCode</Value>
</Value>
<Value name="3">
<Value>LOINCDescription</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.LOINCD</DataLocation>
<DefaultData>LOINCDefaultData</DefaultData>
<ExtentSize>135</ExtentSize>
<IdLocation>^IRISDemo.DataLake.LOINCD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.LOINCI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>2.2</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="LOINCCode">
<AverageFieldSize>6.5</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="LOINCDescription">
<AverageFieldSize>34.65</AverageFieldSize>
<Selectivity>0.7937%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<SQLMap name="LOINCCodeIndex">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.LOINCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
