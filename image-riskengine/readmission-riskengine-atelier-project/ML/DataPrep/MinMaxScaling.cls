Class ML.DataPrep.MinMaxScaling Extends ML.DataPrep.AbstractNormalization
{

Method GetExpression()
{
	Quit "(?-min(?))/(max(?)-min(?))"
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
