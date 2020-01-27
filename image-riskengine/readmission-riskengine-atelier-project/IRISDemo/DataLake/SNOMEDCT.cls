Include DEMOMACROS

Class IRISDemo.DataLake.SNOMEDCT Extends %Persistent
{

Property SNOMEDCode As %String [ Required ];

Property ICDCode As %String;

Property SNOMEDDescription As %String(MAXLEN = "");

Property Comorbidity As Comorbidity;

Index SNOMEDCodeIndex On SNOMEDCode [ Unique ];

ClassMethod OpenOrCreate(pSNOMEDCode As %String, pSNOMEDDescription As %String) As SNOMEDCT
{
	Set obj = ..SNOMEDCodeIndexOpen(pSNOMEDCode)
	If obj="" 
	{
		Set obj = ..%New()
		Set obj.SNOMEDCode=pSNOMEDCode
		Set obj.SNOMEDDescription=pSNOMEDDescription
		Set tSC = obj.%Save()
		$$$ThrowStatusExceptionIfError(tSC,"SNOMEDCTSaveError")
	}
	
	Quit obj
}

Storage Default
{
<Data name="SNOMEDCTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SNOMEDCode</Value>
</Value>
<Value name="3">
<Value>ICDCode</Value>
</Value>
<Value name="4">
<Value>SNOMEDDescription</Value>
</Value>
<Value name="5">
<Value>Comorbidity</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.SNOMEDCTD</DataLocation>
<DefaultData>SNOMEDCTDefaultData</DefaultData>
<ExtentSize>9226</ExtentSize>
<IdLocation>^IRISDemo.DataLake.SNOMEDCTD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.SNOMEDCTI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3.88</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Comorbidity">
<AverageFieldSize>1.61</AverageFieldSize>
<OutlierSelectivity>.479167:10</OutlierSelectivity>
<Selectivity>3.4721%</Selectivity>
</Property>
<Property name="ICDCode">
<AverageFieldSize>4.95</AverageFieldSize>
<OutlierSelectivity>.131944:443.9</OutlierSelectivity>
<Selectivity>1.6232%</Selectivity>
</Property>
<Property name="SNOMEDCode">
<AverageFieldSize>8.7</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="SNOMEDDescription">
<AverageFieldSize>.25</AverageFieldSize>
<OutlierSelectivity>.989583:</OutlierSelectivity>
<Selectivity>0.0109%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-164</BlockCount>
</SQLMap>
<SQLMap name="SNOMEDCodeIndex">
<BlockCount>-92</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.SNOMEDCTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
