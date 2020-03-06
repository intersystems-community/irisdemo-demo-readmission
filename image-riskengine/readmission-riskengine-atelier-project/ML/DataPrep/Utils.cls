Include (%DeepSee, DEMOMACROS)

Class ML.DataPrep.Utils
{

ClassMethod ParsePrepListString(pDataPrep As %String)
{
	// Initial parse of full prep detail list, using the "=" sign as the marker of relevance
	Set tPrepList = ..ParseString(pDataPrep, "=")
	If $List(tPrepList,1) = "" Quit $lb(0,0)
	Quit ..Sort($List(tPrepList,1),$List(tPrepList,2))
}

ClassMethod ParseString(pDataPrep As %String, pParseUsing As %String) [ Internal ]
{
	// General string-parsing with an abstract marker. Finds the thing immediately before and everything relevant after
	// the marker; mostly ignores parentheses; treats commas as separators of items.
	Set tNumItems = $Length(pDataPrep,pParseUsing) - 1
	If tNumItems < 1 Quit $ListBuild("","")
	Set tItems = $ListBuild()
	Set tItemDetails = $ListBuild()
	For i = 1:1:tNumItems
	{
		Set $List(tItems,i) = $Piece($Piece(pDataPrep,pParseUsing,i),",",*)
		If i=tNumItems
		{
			Set $List(tItemDetails,i) = $Piece(pDataPrep,pParseUsing,(i+1))
		}
		Else
		{
			Set $List(tItemDetails,i) = $Piece($Piece(pDataPrep,pParseUsing,(i+1)),",",1,*-1)
		}
		If ($Extract($List(tItemDetails,i),1) = "(") && ($Extract($List(tItemDetails,i),*)=")")
		{
			Set $List(tItemDetails,i) = $Extract($List(tItemDetails,i),2,*-1)
		}
	}
	Quit $ListBuild(tItems,tItemDetails)
}

ClassMethod Sort(pMethods As %List, pMethodDetails As %List) [ Internal ]
{
	Set tNumMethods = $ListLength(pMethods)
	// tPriority is a list containing those methods which must be performed before (or instead of) the others, in order.
	Set tPriority = $ListBuild("Target","Drop","Skip","NaReplace")
	Set tOrder = $ListBuild()
	Set tPrioritySetting = 1
	For i = 1:1:$ListLength(tPriority)
	{
		Set tInMethodNumber = $ListFind(pMethods,$List(tPriority,i))
		If tInMethodNumber
		{
			Set $List(tOrder,tPrioritySetting) = tInMethodNumber
			Set tPrioritySetting = tPrioritySetting + 1
		}
	}
	For i = 1:1:$ListLength(pMethods)
	{
		If '$ListFind(tPriority,$List(pMethods,i))
		{
			Set $List(tOrder,tPrioritySetting) = i
			Set tPrioritySetting = tPrioritySetting + 1
		}
	}
	Quit $ListBuild(..Reorder(pMethods,tOrder),..Reorder(pMethodDetails,tOrder))
}

ClassMethod Reorder(toReorder As %List, Indices As %List) [ Internal ]
{
	If $ListLength(toReorder) '= $ListLength(Indices) $$$ThrowException("NonMatchingLists", "Length of list and index list for reordering is not the same.")
	Set tResult = $ListBuild()
	For i = 1:1:$ListLength(toReorder)
	{
		Set $List(tResult,i) = $List(toReorder,$List(Indices,i))
	}
	Quit tResult
}

ClassMethod DetailSearch(pColumn As %String, pMethodDetails As %String)
{
	Set tResult = $ListBuild(0)
	If $Length(pMethodDetails,":")>1
	{
		Set tDetails = ..ParseString(pMethodDetails,":")
		For i = 1:1:$ListLength($List(tDetails,1))
		{
			If $ListFind($ListFromString($List($List(tDetails,2),i),","),pColumn)
			{
				set tResult = $ListBuild(1,$List($List(tDetails,1),i))
			}
		}
		For i = 1:1:$ListLength($List(tDetails,1))
		{
			If $ListFind($ListFromString($List($List(tDetails,2),i),","),"*")
			{
				set tResult = $ListBuild(1,$List($List(tDetails,1),i))
			}
		}
	}
	Else
	{
		If ($Extract(pMethodDetails,1)="(") && ($Extract(pMethodDetails,*)=")")
		{
			Set tDetails = $ListFromString($Extract(pMethodDetails,2,*-1),",")
		}
		Else
		{
			Set tDetails = $ListFromString(pMethodDetails,",")
		}
		If $ListFind(tDetails,pColumn) || $ListFind(tDetails,"*")
		{
			set tResult = $ListBuild(1,"")
		}
	}
	Quit tResult
}

ClassMethod DeleteFromStringList(pString As %String, pIndex As %Integer)
{
	Set tString1 = $Piece(pString,",",1,pIndex-1)
	Set tString2 = $Piece(pString,",",pIndex+1,*)
	If $Length(tString1) && $Length(tString2)
	{
		Quit tString1_","_tString2
	}
	Else
	{
		Quit tString1_tString2
	}
}

ClassMethod DeleteFromList(pList As %List, pIndex As %Integer)
{
	If pIndex = 1
	{
		Quit $List(pList,2,*)
	}
	Set tLength = $ListLength(pList)
	If pIndex = tLength
	{
		Quit $List(pList,1,pIndex-1)
	}
	ElseIf pIndex < tLength
	{
		Quit ($List(pList,1,pIndex-1)_$List(pList,pIndex+1,*))
	}
	Else
	{
		$$$ThrowException("IndexError","Index out of bounds for list in DeleteFromList")
	}
}

ClassMethod PrepareAll(pABTName As %String, pDataPrepLists As %List)
{
	Set tSC = ##class(ML.ABT.Utils).GetExplodedColumnNamesForCube(^PublishedABT(pABTName,"CUBENAME"), 1, .columnList)
	$$$ThrowStatusExceptionIfError(tSC, "GetColumnNamesException")
	Set tFactTablePropertyName = ""
	Set ^PublishedABT(pABTName, "ABTDefinitionQuery") = ""
	For i=1:1:$ListLength(columnList)
	{
		Set lProp=$ListGet(columnList, i)
		Set tFactTablePropertyName=$ListGet(lProp,5)
		Set tStarTableName=$ListGet(lProp,6)
		// If the ith column is a dimension, it will have a non-null star table. In that case, move on to the next column.
		Continue:tStarTableName'=""

		Set ^PublishedABT(pABTName,"QueryPiece",tFactTablePropertyName) = tFactTablePropertyName
		If $ListValid($List(pDataPrepLists,1))
		{
			For tStepNumber = 1:1:$ListLength($List(pDataPrepLists,1))
			{
				Set prepObject = $ClassMethod("ML.DataPrep."_$List($List(pDataPrepLists,1),tStepNumber),"%New",pABTName, tFactTablePropertyName, $List($List(pDataPrepLists,2),tStepNumber))
			}
		}
	}

	// Check if first entry in the query is blank, and if so remove it
	If $Extract(^PublishedABT(pABTName, "ABTDefinitionQuery"),1) = ","
	{
		Set $Extract(^PublishedABT(pABTName, "ABTDefinitionQuery"),1) = ""
	}
	
	Set tQuery = "Select Top 1 "_^PublishedABT(pABTName, "ABTDefinitionQuery")_" from "_^PublishedABT(pABTName,"FACTTABLENAME")

	Set oRS = ##class(%SQL.Statement).%ExecDirect(, tQuery)
	$$$ThrowSQLExceptionIfResultError(oRS, "DefiningQueryException")
	
	Do oRS.%Next(.tSC)
	
	Set metaData = oRS.%GetMetadata()
	For i = 1:1:metaData.columnCount
	{
		Set colName = metaData.columns.GetAt(i).colName
		Set ^PublishedABT(pABTName,"Constants",colName) = oRS.%Get(colName)
		// If null replacement value is non-integer, ensure data type is double.
		If ($Extract(colName,*-10,*) = "NULLREPLACE") && (oRS.%Get(colName) \ 1 '= oRS.%Get(colName))
		{
			Do ..columnToDouble(pABTName,$Extract(colName,1,*-11))
		}
	}
}

ClassMethod columnToDouble(pABTName, pColumn)
{
	Set $Piece(^PublishedABT(pABTName,"ROWSPEC"),",",^PublishedABT(pABTName,"PMap2",pColumn)) = pColumn_":%Double"
}

}
