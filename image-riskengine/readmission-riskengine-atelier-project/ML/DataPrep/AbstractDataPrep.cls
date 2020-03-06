Include (%DeepSee, DEMOMACROS)

Class ML.DataPrep.AbstractDataPrep Extends %SerialObject [ Abstract ]
{

Property pColumnName As %String;

Property pABTName As %String;

Method %OnNew(ABTName As %String, pColumn As %String, pMethodDetails As %String = "") As %Library.Status
{
	Set ..pColumnName = pColumn
	Set ..pABTName = ABTName

	If '$Data(^PublishedABT(..pABTName,"Dropped",pColumn)) && '$Data(^PublishedABT(..pABTName,"Target",pColumn)) && '$Data(^PublishedABT(..pABTName,"Skipped",pColumn))
	{
		Set tParsedDetails = ##class(ML.DataPrep.Utils).DetailSearch(pColumn,pMethodDetails)
		If $List(tParsedDetails,1) = 1
		{
			Do ..PrepareMethod($List(tParsedDetails,2))
		}
	}
	
	Quit $$$OK
}

Method PrepareMethod(pMethodDetails As %String) [ Abstract ]
{
}

Storage Default
{
<Data name="AbstractDataPrepState">
<Value name="1">
<Value>pColumnName</Value>
</Value>
<Value name="2">
<Value>pABTName</Value>
</Value>
<Value name="3">
<Value>pVariantName</Value>
</Value>
</Data>
<State>AbstractDataPrepState</State>
<StreamLocation>^ML.DataPrep.AbstractDataPrepS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
