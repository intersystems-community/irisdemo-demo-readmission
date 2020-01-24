Class IRISDemo.DataLake.LabObservation Extends IRISDemo.DataLake.Observation
{

/// This is a Measure Value, meaning a measure that also has an associated unit
Property Value As %Double;

Property Units As %String;

/// This is value that does not have a concrete value and its value is an associate SNOMED code
Property SNOMEDValue As SNOMEDCT;

Storage Default
{
<Data name="LabObservationDefaultData">
<Subscript>"LabObservation"</Subscript>
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
<Value name="3">
<Value>Units</Value>
</Value>
<Value name="4">
<Value>SNOMEDValue</Value>
</Value>
</Data>
<DefaultData>LabObservationDefaultData</DefaultData>
<ExtentSize>677143</ExtentSize>
<Property name="%%CLASSNAME">
<AverageFieldSize>34</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>6.01</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Code">
<AverageFieldSize>1.82</AverageFieldSize>
<Selectivity>1.4706%</Selectivity>
</Property>
<Property name="DiagnosticReport">
<AverageFieldSize>4.5</AverageFieldSize>
<OutlierSelectivity>.074119:</OutlierSelectivity>
<Selectivity>0.0010%</Selectivity>
</Property>
<Property name="EffectiveDate">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0025%</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.58</AverageFieldSize>
<Selectivity>0.0023%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ObservationType">
<AverageFieldSize>10</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.84</AverageFieldSize>
<Selectivity>0.0526%</Selectivity>
</Property>
<Property name="SNOMEDValue">
<AverageFieldSize>.18</AverageFieldSize>
<OutlierSelectivity>.955448:</OutlierSelectivity>
<Selectivity>0.3427%</Selectivity>
</Property>
<Property name="Units">
<AverageFieldSize>4.56</AverageFieldSize>
<OutlierSelectivity>.36533:"mg/dL"</OutlierSelectivity>
<Selectivity>3.5259%</Selectivity>
</Property>
<Property name="Value">
<AverageFieldSize>19.62</AverageFieldSize>
<OutlierSelectivity>.044957:</OutlierSelectivity>
<Selectivity>0.0067%</Selectivity>
</Property>
<Type>%Storage.Persistent</Type>
}

}
