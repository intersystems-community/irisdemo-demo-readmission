Class ML.DataPrep.Skip Extends ML.DataPrep.AbstractDataPrep
{

Method PrepareMethod(pMethodDetails As %String)
{
	Set ^PublishedABT(..pABTName,"Skipped",..pColumnName) = 1
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
