Class IRISDemo.DataLake.Encounter Extends %Persistent
{

Parameter DSTIME = "AUTO";

Property ActCode As %String(DISPLAYLIST = ",Ambulatory,Emergency,Field,Home Health,Inpatient Encounter,Inpatient Acute,Inpatient Non-Acute,Observation Encounter,Pre-Admission,Short Stay,Virtual", VALUELIST = ",AMB,EMER,FLD,HH,IMP,ACUTE,NONAC,OBSENC,PRENC,SS,VR") [ Required ];

Property FHIRReferenceCode As %String;

/// AKA "Encounter class" 
Property EncounterType As %String(DISPLAYLIST = ",Outpatient,Inpatient,Emergency", VALUELIST = ",O,I,E") [ Required ];

Property SNOMEDTypeCode As %String;

/// You may rename this if you want
Property EncounterStart As %TimeStamp;

/// You may rename this if you want
Property EncounterEnd As %TimeStamp;

Property Patient As Patient [ Required ];

/// Chief complaint, etc..
Property AdmitReason As %String(MAXLEN = "");

/// Home, Deceased, Nursing Home, etc...
Property DischargeLocation As %String(DISPLAYLIST = ",Home,Deceased,Skilled Nursing Facility", VALUELIST = ",H,D,N") [ InitialExpression = "H" ];

Property EncounterNumber As %String [ Required ];

Property LOS As %Integer [ SqlComputeCode = {
 Set {LOS} = $Select(
 						{EncounterEnd}'="":$System.SQL.DATEDIFF("d",{EncounterStart}, {EncounterEnd}),
 						1:$System.SQL.DATEDIFF("d",{EncounterStart}, $ZDateTime($H,3))
 					)
}, SqlComputed, SqlComputeOnChange = (EncounterStart, EncounterEnd) ];

Property Status As %String(VALUELIST = ",active,finished") [ Required ];

Property LACEScoreAggregate As %Integer;

Property LACEScore As %String;

Property ReadmissionProbability As %Double;

Index FutureEncounterSearchIndex On (Patient, EncounterType, EncounterStart);

Index EncounterNumberIndex On EncounterNumber [ Unique ];

Index FHIRReferenceCodeIndex On FHIRReferenceCode [ Unique ];

Storage Default
{
<Data name="EncounterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ActCode</Value>
</Value>
<Value name="3">
<Value>FHIRReferenceCode</Value>
</Value>
<Value name="4">
<Value>EncounterType</Value>
</Value>
<Value name="5">
<Value>SNOMEDTypeCode</Value>
</Value>
<Value name="6">
<Value>EncounterStart</Value>
</Value>
<Value name="7">
<Value>EncounterEnd</Value>
</Value>
<Value name="8">
<Value>Patient</Value>
</Value>
<Value name="9">
<Value>AdmitReason</Value>
</Value>
<Value name="10">
<Value>DischargeLocation</Value>
</Value>
<Value name="11">
<Value>EncounterNumber</Value>
</Value>
<Value name="12">
<Value>LOS</Value>
</Value>
<Value name="13">
<Value>Status</Value>
</Value>
<Value name="14">
<Value>LACEScoreAggregate</Value>
</Value>
<Value name="15">
<Value>LACEScore</Value>
</Value>
<Value name="16">
<Value>ReadmissionProbability</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.DataLake.EncounterD</DataLocation>
<DefaultData>EncounterDefaultData</DefaultData>
<ExtentSize>270223</ExtentSize>
<IdLocation>^IRISDemo.DataLake.EncounterD</IdLocation>
<IndexLocation>^IRISDemo.DataLake.EncounterI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>5.57</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="ActCode">
<AverageFieldSize>3.04</AverageFieldSize>
<OutlierSelectivity>.912765:"AMB"</OutlierSelectivity>
<Selectivity>4.3618%</Selectivity>
</Property>
<Property name="AdmitReason">
<AverageFieldSize>30.25</AverageFieldSize>
<OutlierSelectivity>.278384:"General examination of patient (procedure)"</OutlierSelectivity>
<Selectivity>1.6782%</Selectivity>
</Property>
<Property name="DischargeLocation">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="EncounterEnd">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0004%</Selectivity>
</Property>
<Property name="EncounterNumber">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="EncounterStart">
<AverageFieldSize>19</AverageFieldSize>
<Selectivity>0.0005%</Selectivity>
</Property>
<Property name="EncounterType">
<AverageFieldSize>1</AverageFieldSize>
<OutlierSelectivity>.912765:"O"</OutlierSelectivity>
<Selectivity>4.3618%</Selectivity>
</Property>
<Property name="FHIRReferenceCode">
<AverageFieldSize>36</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="LACEScore">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LACEScoreAggregate">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="LOS">
<AverageFieldSize>1.01</AverageFieldSize>
<OutlierSelectivity>.930725:0</OutlierSelectivity>
<Selectivity>0.8659%</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>3.81</AverageFieldSize>
<Selectivity>0.0430%</Selectivity>
</Property>
<Property name="ReadmissionProbability">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SNOMEDTypeCode">
<AverageFieldSize>8.97</AverageFieldSize>
<OutlierSelectivity>.278384:162673000</OutlierSelectivity>
<Selectivity>2.1224%</Selectivity>
</Property>
<Property name="Status">
<AverageFieldSize>8</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="EncounterNumberIndex">
<BlockCount>-8440</BlockCount>
</SQLMap>
<SQLMap name="FHIRReferenceCodeIndex">
<BlockCount>-8436</BlockCount>
</SQLMap>
<SQLMap name="FutureEncounterSearchIndex">
<BlockCount>-3784</BlockCount>
</SQLMap>
<SQLMap name="IDKEY">
<BlockCount>-30664</BlockCount>
</SQLMap>
<StreamLocation>^IRISDemo.DataLake.EncounterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
