Class ML.DataPrep.Drop Extends ML.DataPrep.AbstractDataPrep
{

Method PrepareMethod(pMethodDetails As %String)
{
	Set tTargetIndex = ^PublishedABT(..pABTName,"PMap2",..pColumnName)
	Set tFactTablePropertyName = ""
	For
	{
		Set tFactTablePropertyName = $Order(^PublishedABT(..pABTName,"PMap1",tFactTablePropertyName))
		Quit:tFactTablePropertyName=""
		
		Set tStarTableName=^PublishedABT(..pABTName,"PMap1",tFactTablePropertyName)
		
		If tStarTableName=""
		{
			Set tIndex = ^PublishedABT(..pABTName,"PMap2",tFactTablePropertyName)

			If tIndex > tTargetIndex
			{
				Set ^PublishedABT(..pABTName,"PMap2",tFactTablePropertyName) = tIndex - 1
				Set ^PublishedABT(..pABTName,"PMap1",tFactTablePropertyName,tFactTablePropertyName) = tIndex - 1
			}
		}
		Else
		{
			Set tPropertyName = ""
			For
			{
				Set tPropertyName = $Order(^PublishedABT(..pABTName,"PMap1",tFactTablePropertyName, tPropertyName))
				Quit:tPropertyName=""

				Set tIndex = ^PublishedABT(..pABTName,"PMap2",tPropertyName)
				If tIndex > tTargetIndex
				{
					Set ^PublishedABT(..pABTName,"PMap2",tPropertyName) = tIndex - 1
					Set ^PublishedABT(..pABTName,"PMap1",tFactTablePropertyName,tPropertyName) = tIndex - 1
				}

			}
		}
	}
	Set ^PublishedABT(..pABTName,"PMap2",..pColumnName) = ""
	Set ^PublishedABT(..pABTName,"PMap1",..pColumnName,..pColumnName) = ""
	Set ^PublishedABT(..pABTName,"Dropped",..pColumnName) = 1
	// We need to change the column names and default values as well, not just the indices.
	Set ^PublishedABT(..pABTName,"ROWSPEC") = ##class(ML.DataPrep.Utils).DeleteFromStringList(^PublishedABT(..pABTName,"ROWSPEC"),tTargetIndex)
	Set ^PublishedABT(..pABTName,"DEFAULTVALUES") = ##class(ML.DataPrep.Utils).DeleteFromList(^PublishedABT(..pABTName,"DEFAULTVALUES"),tTargetIndex)
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
