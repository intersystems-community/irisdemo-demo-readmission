Class IRISDemo.BO.Email.EmailMessage Extends (%Persistent, Ens.Request)
{

Property From As %String;

Property To As %String;

Property Subject As %String;

Property MessageText As %String(MAXLEN = "");

Storage Default
{
<Data name="EmailMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>From</Value>
</Value>
<Value name="3">
<Value>To</Value>
</Value>
<Value name="4">
<Value>Subject</Value>
</Value>
<Value name="5">
<Value>MessageText</Value>
</Value>
</Data>
<DataLocation>^IRISDemo.BO.E574C.EmailMessageD</DataLocation>
<DefaultData>EmailMessageDefaultData</DefaultData>
<IdLocation>^IRISDemo.BO.E574C.EmailMessageD</IdLocation>
<IndexLocation>^IRISDemo.BO.E574C.EmailMessageI</IndexLocation>
<StreamLocation>^IRISDemo.BO.E574C.EmailMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
