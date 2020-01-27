Class IRISDemo.DataLake.DiagnosticReport Extends %Persistent
{

Property ReportType As %String;

Property FHIRReferenceCode As %String;

Property Encounter As Encounter [ Required ];

Property Patient As Patient [ Required ];

Property IssueDate As %TimeStamp [ Required ];

Relationship Observations As Observation [ Cardinality = many, Inverse = DiagnosticReport ];

Index FHIRReferenceCodeIndex On FHIRReferenceCode [ Unique ];

Storage Default
{
<Data name="DiagnosticReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FHIRReferenceCode</Value>
</Value>
<Value name="3">
<Value>Encounter</Value>
</Value>
<Value name="4">
<Value>Patient</Value>
</Value>
<Value name="5">
<Value>IssueDate</Value>
</Value>
<Value name="6">
<Value>ReportType</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DD8B5.DiagnosticR9BA8D</DataLocation>
<DefaultData>DiagnosticReportDefaultData</DefaultData>
<ExtentSize>74623</ExtentSize>
<IdLocation>^IRISDemo.DD8B5.DiagnosticR9BA8D</IdLocation>
<IndexLocation>^IRISDemo.DD8B5.DiagnosticR9BA8I</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>4.83</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Encounter">
<AverageFieldSize>5.56</AverageFieldSize>
<Selectivity>0.0022%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="IssueDate">
<AverageFieldSize>22.91</AverageFieldSize>
<Selectivity>0.0022%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.79</AverageFieldSize>
<Selectivity>0.0658%</Selectivity>
</Property>
<Property name="ReportType">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="FHIRReferenceCodeIndex">
<BlockCount>-2320</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-3704</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DD8B5.DiagnosticR9BA8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
