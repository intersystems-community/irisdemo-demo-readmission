Class ML.DataPrep.Target Extends ML.DataPrep.AbstractDataPrep
{

Method PrepareMethod(pMethodDetails As %String)
{
	If $Data(^PublishedABT(..pABTName,"Target"))
	{
		$$$ThrowException("MultipleTargets","Multiple targets defined")
	}
	Set ^PublishedABT(..pABTName,"Target") = ..pColumnName
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
