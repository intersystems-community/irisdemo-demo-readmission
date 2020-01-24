Class IRISDemo.DataLake.VitalSignObservation Extends IRISDemo.DataLake.Observation
{

Property Value As %Double [ Required ];

Property Units As %String;

Storage Default
{
<Data name="VitalSignObservationDefaultData">
<Subscript>"VitalSignObservation"</Subscript>
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
<Value name="3">
<Value>Units</Value>
</Value>
</Data>
<DefaultData>VitalSignObservationDefaultData</DefaultData>
<ExtentSize>302124</ExtentSize>
<Property name="%%CLASSNAME">
<AverageFieldSize>40</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>6.03</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Code">
<AverageFieldSize>1.17</AverageFieldSize>
<Selectivity>11.1111%</Selectivity>
</Property>
<Property name="DiagnosticReport">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EffectiveDate">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0012%</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.62</AverageFieldSize>
<Selectivity>0.0011%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ObservationType">
<AverageFieldSize>11</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.86</AverageFieldSize>
<Selectivity>0.0378%</Selectivity>
</Property>
<Property name="Units">
<AverageFieldSize>3.96</AverageFieldSize>
<Selectivity>16.6666%</Selectivity>
</Property>
<Property name="Value">
<AverageFieldSize>14.07</AverageFieldSize>
<OutlierSelectivity>.063069:$double(2)</OutlierSelectivity>
<Selectivity>0.0774%</Selectivity>
</Property>
<Type>%Storage.Persistent</Type>
}

}
