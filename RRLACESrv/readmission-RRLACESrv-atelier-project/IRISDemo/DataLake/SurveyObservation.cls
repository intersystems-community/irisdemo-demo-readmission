Class IRISDemo.DataLake.SurveyObservation Extends IRISDemo.DataLake.Observation
{

/// This is a Measure Value, meaning a measure that also has an associated unit
Property Value As %Double;

Property Units As %String;

/// This is value that does not have a concrete value and its value is an associate SNOMED code
Property SNOMEDValue As SNOMEDCT;

Storage Default
{
<Data name="SurveyObservationDefaultData">
<Subscript>"SurveyObservation"</Subscript>
<Value name="1">
<Value>Value</Value>
</Value>
<Value name="2">
<Value>Units</Value>
</Value>
<Value name="3">
<Value>SNOMEDValue</Value>
</Value>
</Data>
<DefaultData>SurveyObservationDefaultData</DefaultData>
<ExtentSize>63798</ExtentSize>
<Property name="%%CLASSNAME">
<AverageFieldSize>37</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>5.99</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Code">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.977573:14</OutlierSelectivity>
<Selectivity>0.7468%</Selectivity>
</Property>
<Property name="DiagnosticReport">
<AverageFieldSize>1</AverageFieldSize>
<OutlierSelectivity>.999077:</OutlierSelectivity>
<Selectivity>0.0092%</Selectivity>
</Property>
<Property name="EffectiveDate">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0016%</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.56</AverageFieldSize>
<Selectivity>0.0016%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ObservationType">
<AverageFieldSize>5.98</AverageFieldSize>
<OutlierSelectivity>.989446:"survey"</OutlierSelectivity>
<Selectivity>1.0554%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.8</AverageFieldSize>
<Selectivity>0.0229%</Selectivity>
</Property>
<Property name="SNOMEDValue">
<AverageFieldSize>3.95</AverageFieldSize>
<OutlierSelectivity>.761214:9063</OutlierSelectivity>
<Selectivity>4.7757%</Selectivity>
</Property>
<Property name="Units">
<AverageFieldSize>.08</AverageFieldSize>
<OutlierSelectivity>.986807:</OutlierSelectivity>
<Selectivity>0.6590%</Selectivity>
</Property>
<Property name="Value">
<AverageFieldSize>.28</AverageFieldSize>
<OutlierSelectivity>.986807:</OutlierSelectivity>
<Selectivity>0.0016%</Selectivity>
</Property>
<Type>%Storage.Persistent</Type>
}

}
