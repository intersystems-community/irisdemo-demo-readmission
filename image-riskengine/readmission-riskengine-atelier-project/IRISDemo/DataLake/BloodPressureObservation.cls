Class IRISDemo.DataLake.BloodPressureObservation Extends IRISDemo.DataLake.Observation
{

Property Units As %String;

Property DiastolicBloodPressure As %Double [ Required ];

Property SystolicBloodPressure As %Double [ Required ];

Storage Default
{
<Data name="BloodPressureObservationDefaultData">
<Subscript>"BloodPressureObservation"</Subscript>
<Value name="1">
<Value>Units</Value>
</Value>
<Value name="2">
<Value>DiastolicBloodPressure</Value>
</Value>
<Value name="3">
<Value>SystolicBloodPressure</Value>
</Value>
</Data>
<DefaultData>BloodPressureObservationDefaultData</DefaultData>
<ExtentSize>63741</ExtentSize>
<Property name="%%CLASSNAME">
<AverageFieldSize>44</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>5.97</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Code">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DiagnosticReport">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="DiastolicBloodPressure">
<AverageFieldSize>2.05</AverageFieldSize>
<Selectivity>2.3810%</Selectivity>
</Property>
<Property name="EffectiveDate">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0016%</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.55</AverageFieldSize>
<Selectivity>0.0016%</Selectivity>
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
<AverageFieldSize>3.79</AverageFieldSize>
<Selectivity>0.0265%</Selectivity>
</Property>
<Property name="SystolicBloodPressure">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1.3698%</Selectivity>
</Property>
<Property name="Units">
<AverageFieldSize>6</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Type>%Storage.Persistent</Type>
}

}
