Class IRISDemo.DataLake.Patient Extends %Persistent
{

Property FHIRReferenceCode As %String;

Property DateOfBirth As %Date(FORMAT = 3);

Property MRN As %String [ Required ];

Property Gender As %String;

Property MaritalStatus As %String;

Property DateOfDeath As %Date(FORMAT = 3);

Property FirstName As %String;

Property LastName As %String;

Index MRNIndex On MRN [ Unique ];

Index FHIRReferenceCodeIndex On FHIRReferenceCode [ Unique ];

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FHIRReferenceCode</Value>
</Value>
<Value name="3">
<Value>DateOfBirth</Value>
</Value>
<Value name="4">
<Value>MRN</Value>
</Value>
<Value name="5">
<Value>Gender</Value>
</Value>
<Value name="6">
<Value>MaritalStatus</Value>
</Value>
<Value name="7">
<Value>DateOfDeath</Value>
</Value>
<Value name="8">
<Value>FirstName</Value>
</Value>
<Value name="9">
<Value>LastName</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>5848</ExtentSize>
<IdLocation>^IRISDemo.DataLake.PatientD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.PatientI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3.84</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="DateOfBirth">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>0.0260%</Selectivity>
</Property>
<Property name="DateOfDeath">
<AverageFieldSize>.85</AverageFieldSize>
<OutlierSelectivity>.829694:</OutlierSelectivity>
<Selectivity>0.0171%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="FirstName">
<AverageFieldSize>8.83</AverageFieldSize>
<Selectivity>0.0373%</Selectivity>
</Property>
<Property name="Gender">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="LastName">
<AverageFieldSize>9.47</AverageFieldSize>
<Selectivity>0.1790%</Selectivity>
</Property>
<Property name="MRN">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="MaritalStatus">
<AverageFieldSize>4.62</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="FHIRReferenceCodeIndex">
<BlockCount>-184</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-396</BlockCount>
</SQLMap>
<SQLMap name="MRNIndex">
<BlockCount>-192</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
