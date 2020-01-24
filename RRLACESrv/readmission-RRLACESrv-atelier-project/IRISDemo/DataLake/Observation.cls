Class IRISDemo.DataLake.Observation Extends %Persistent
{

Property FHIRReferenceCode As %String;

Property ObservationType As %String(VALUELIST = ",exam,survey,vital-signs,laboratory") [ Required ];

Property Code As LOINC [ Required ];

Property Encounter As Encounter [ Required ];

Property Patient As Patient [ Required ];

Property EffectiveDate As %TimeStamp [ Required ];

Relationship DiagnosticReport As DiagnosticReport [ Cardinality = one, Inverse = Observations ];

Index FHIRReferenceCodeIndex On FHIRReferenceCode [ Unique ];

/// Eliminated Index on Code. Added this one instead because the cube needs it. 
/// I don't believe anyone will be looking by a random Observation with Code X from "any" patient
Index PatiendLOINCIndex On (Patient, ObservationType, Code);

Storage Default
{
<Data name="ObservationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FHIRReferenceCode</Value>
</Value>
<Value name="3">
<Value>ObservationType</Value>
</Value>
<Value name="4">
<Value>Code</Value>
</Value>
<Value name="5">
<Value>Encounter</Value>
</Value>
<Value name="6">
<Value>Patient</Value>
</Value>
<Value name="7">
<Value>EffectiveDate</Value>
</Value>
<Value name="8">
<Value>DiagnosticReport</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.ObservationD</DataLocation>
<DefaultData>ObservationDefaultData</DefaultData>
<ExtentSize>1106806</ExtentSize>
<IdLocation>^IRISDemo.DataLake.ObservationD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.ObservationI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>36.37</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>6</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Code">
<AverageFieldSize>1.6</AverageFieldSize>
<OutlierSelectivity>.077313:2</OutlierSelectivity>
<Selectivity>1.2640%</Selectivity>
</Property>
<Property name="DiagnosticReport">
<AverageFieldSize>2.79</AverageFieldSize>
<OutlierSelectivity>.426806:</OutlierSelectivity>
<Selectivity>0.0008%</Selectivity>
</Property>
<Property name="EffectiveDate">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0017%</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.6</AverageFieldSize>
<Selectivity>0.0017%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ObservationType">
<AverageFieldSize>10.13</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.83</AverageFieldSize>
<Selectivity>0.0368%</Selectivity>
</Property>
<SQLMap name="FHIRReferenceCodeIndex">
<BlockCount>-64360</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-121396</BlockCount>
</SQLMap>
<SQLMap name="PatiendLOINCIndex">
<BlockCount>-1812</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.ObservationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
