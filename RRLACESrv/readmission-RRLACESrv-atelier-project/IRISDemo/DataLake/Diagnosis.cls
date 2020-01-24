Class IRISDemo.DataLake.Diagnosis Extends %Persistent
{

Property OnsetDate As %Date(FORMAT = 3);

Property Patient As Patient [ Required ];

Property AbatementDate As %Date(FORMAT = 3);

Property SNOMEDCT As SNOMEDCT [ Required ];

// Property EnteredBy As %String;

// Property AdditionalRemarks As %String (MAXLEN="");

Property Status As %String(VALUELIST = ",active,resolved");

Property Encounter As Encounter [ Required ];

Property FHIRReferenceCode As %String;

Index DiagnosisByEncounterIndex On Encounter;

Index FHIRReferenceCodeIndex On FHIRReferenceCode [ Unique ];

Index PatientOnsetDateIndex On (Patient, OnsetDate) [ Data = SNOMEDCT ];

Index PatientDiagIndex On (Patient, SNOMEDCT);

Storage Default
{
<Data name="DiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OnsetDate</Value>
</Value>
<Value name="3">
<Value>Patient</Value>
</Value>
<Value name="4">
<Value>AbatementDate</Value>
</Value>
<Value name="5">
<Value>SNOMEDCT</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>Encounter</Value>
</Value>
<Value name="8">
<Value>FHIRReferenceCode</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.DiagnosisD</DataLocation>
<DefaultData>DiagnosisDefaultData</DefaultData>
<ExtentSize>45311</ExtentSize>
<IdLocation>^IRISDemo.DataLake.DiagnosisD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.DiagnosisI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4.75</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="AbatementDate">
<AverageFieldSize>2.89</AverageFieldSize>
<OutlierSelectivity>.422535:</OutlierSelectivity>
<Selectivity>0.0105%</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.58</AverageFieldSize>
<Selectivity>0.0022%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="OnsetDate">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>0.0106%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.8</AverageFieldSize>
<Selectivity>0.0200%</Selectivity>
</Property>
<Property name="SNOMEDCT">
<AverageFieldSize>3.96</AverageFieldSize>
<OutlierSelectivity>.13928:9078</OutlierSelectivity>
<Selectivity>0.9762%</Selectivity>
</Property>
<Property name="Status">
<AverageFieldSize>7.15</AverageFieldSize>
<Selectivity>49.9998%</Selectivity>
</Property>
<SQLMap name="DiagnosisByEncounterIndex">
<BlockCount>-348</BlockCount>
</SQLMap>
<SQLMap name="FHIRReferenceCodeIndex">
<BlockCount>-1384</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-2048</BlockCount>
</SQLMap>
<SQLMap name="PatientDiagIndex">
<BlockCount>-360</BlockCount>
</SQLMap>
<SQLMap name="PatientOnsetDateIndex">
<BlockCount>-508</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.DiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
