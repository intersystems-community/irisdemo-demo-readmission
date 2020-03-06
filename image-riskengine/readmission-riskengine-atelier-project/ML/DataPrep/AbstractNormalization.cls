Class ML.DataPrep.AbstractNormalization Extends ML.DataPrep.AbstractDataPrep [ Abstract ]
{

Method PrepareMethod(pMethodDetails As %String = "")
{
	Set Parser = ##class(ML.DataPrep.EqnParser).%New(..pColumnName)
	Set tNullReplacedValue=^PublishedABT(..pABTName,"QueryPiece",..pColumnName)
	Do Parser.Parse(.eqn, $Replace(..GetExpression(),"?",$Get(tNullReplacedValue,..pColumnName)))

	Merge tPreCalculate = eqn("AGGREGATE")
	Set tPreCalcList = Parser.Unparse(.tPreCalculate)
		
	For i=1:1:$ListLength(tPreCalcList)
	{
		Set tPreCalcQueryItem = $List(tPreCalcList,i)
		While $ListValid(tPreCalcQueryItem) { Set tPreCalcQueryItem = $List(tPreCalcQueryItem,1) }
		If $Find(tPreCalcQueryItem,..pColumnName_"NULLREPLACE")
		{
			Set tPreCalcQueryItem = $Replace(tPreCalcQueryItem,..pColumnName_"NULLREPLACE)",$Get(^PublishedABT(..pABTName, "NULLREPLACE",..pColumnName))_")")
		}
		
		Set $Piece(^PublishedABT(..pABTName, "ABTDefinitionQuery"),",",*+1) = tPreCalcQueryItem_" as AGGREGATE"_..pColumnName_i
	}

	Kill ^PublishedABT(..pABTName,"QueryPiece",..pColumnName)
	Merge ^PublishedABT(..pABTName,"QueryPiece",..pColumnName) = eqn("CALCULATE")

	Do ##class(ML.DataPrep.Utils).columnToDouble(..pABTName,..pColumnName)
}

Method GetExpression() [ Abstract ]
{
}

Storage Default
{
<Type>%Storage.Serial</Type>
}

}
