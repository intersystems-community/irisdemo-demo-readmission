Class ML.DataPrep.Standardization Extends ML.DataPrep.AbstractNormalization
{

Method GetExpression(pCol As %String)
{
	Quit "(?-avg(?))/stddev(?)"
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
