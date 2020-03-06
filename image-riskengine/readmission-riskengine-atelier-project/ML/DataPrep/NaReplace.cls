Class ML.DataPrep.NaReplace Extends ML.DataPrep.AbstractDataPrep
{

Method PrepareMethod(pMethodDetails As %String)
{
	If +pMethodDetails'=0 || ($EXTRACT(pMethodDetails,1,1)=0)
	{
		Set $Piece(^PublishedABT(..pABTName, "ABTDefinitionQuery"),",",*+1) = +pMethodDetails_" as "_..pColumnName_"NULLREPLACE"
		Set ^PublishedABT(..pABTName, "NULLREPLACE", ..pColumnName) = "COALESCE("_..pColumnName_","_+pMethodDetails_")"
	}
	ElseIf (pMethodDetails="mean") || (pMethodDetails="avg") || (pMethodDetails="average")
	{
		Set $Piece(^PublishedABT(..pABTName, "ABTDefinitionQuery"),",",*+1) = "avg("_..pColumnName_") as "_..pColumnName_"NULLREPLACE"
		Set ^PublishedABT(..pABTName, "NULLREPLACE", ..pColumnName) = "COALESCE("_..pColumnName_", avg("_..pColumnName_"))"
	}
	ElseIf pMethodDetails="median" //Not currently functional. To replace with functional median method
	{
		Set $Piece(^PublishedABT(..pABTName, "ABTDefinitionQuery"),",",*+1) = "median("_..pColumnName_") as "_..pColumnName_"NULLREPLACE"
		Set ^PublishedABT(..pABTName, "NULLREPLACE", ..pColumnName) = "COALESCE("_..pColumnName_", median("_..pColumnName_"))"
	}
	Else
	{
		$$$ThrowException("UnknownMethod", "Null replacement value of "_pMethodDetails_" is not understood.")
	}
	Set ^PublishedABT(..pABTName,"QueryPiece",..pColumnName) = "COALESCE("_^PublishedABT(..pABTName,"QueryPiece",..pColumnName)_","_..pColumnName_"NULLREPLACE)"
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
