Class IRISDemo.Data.Patient Extends %Persistent
{

Property MRN As %String;

Property DoB As %Date;

Property FirstName As %String;

Property LastName As %String;

Property Gender As %String(DISPLAYLIST = ",Male,Female,Other", VALUELIST = ",M,F,O");

Index MRNIndex On MRN [ Unique ];

Index FirstNameIndex On FirstName; 

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MRN</Value>
</Value>
<Value name="3">
<Value>DoB</Value>
</Value>
<Value name="4">
<Value>FirstName</Value>
</Value>
<Value name="5">
<Value>LastName</Value>
</Value>
<Value name="6">
<Value>Gender</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.Data.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^IRISDemo.Data.PatientD</IdLocation>
<IndexLocation>^IRISDemo.Data.PatientI</IndexLocation>
<StreamLocation>^IRISDemo.Data.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
