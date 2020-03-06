Include DEMOMACROS

Class ML.DataPrep.EqnParser Extends %SerialObject
{

Parameter RESERVEDCHARACTERS As %String = "+-/*^";

Parameter FUNCTIONLIST As %String = "min,max,avg,stddev";

Parameter NONAGGREGATEFUNCTIONS As %String = "COALESCE";

Parameter STRINGNOTFOUND As %Integer = 999999999999;

Property WhichVar As %Integer;

Property Vars [ MultiDimensional ];

Property WhichFunc As %Integer;

Property Funcs [ MultiDimensional ];

Property SeparateFunctions As %Integer;

Property Prefix As %String;

Method %OnNew(pPrefix As %String = "", pSeparateFunctions As %Integer = 1) As %Library.Status
{
	Set ..SeparateFunctions = pSeparateFunctions
	Set ..Prefix = pPrefix

	Quit $$$OK
}

Method NonMatchingParentheses() [ Internal ]
{
	$$$ThrowException("NonMatchingParentheses","Parentheses in equation to be parsed do not match.")
}

Method ParenParse(Output out, str As %String) As %String [ Internal ]
{
	Set ParenLevel = 0
	For i = 1:1:$Length(str)
	{
		If $Extract(str,i) = "("
		{
			Set ParenLevel = ParenLevel + 1
		}
		ElseIf $Extract(str,i) = ")"
		{
			Set ParenLevel = ParenLevel - 1
		}
		If ParenLevel = 0
		{
			Do ..ParseInternal(.outInternal,$Extract(str,2,i-1))
			Merge out=outInternal
			Return $Extract(str,i+1,*)
		}
	}
	Do ..NonMatchingParentheses()
}

Method FindOps(str As %String, chList As %List) [ Internal ]
{
	Set position = ..#STRINGNOTFOUND + 1
	For i = 1:1:$ListLength(chList)
	{
		Set temp = $Find(str,$List(chList,i))
		If (temp > 0) && (temp < position) { Set position = temp } 
	}
	Quit position - 1
}

Method FindNextOperator(str As %String) [ Internal ]
{
	Set temp = ..FindOps(str,$ListBuild("^"))
	If temp '= ..#STRINGNOTFOUND { Quit temp }
	Set temp = ..FindOps(str,$ListBuild("*","/"))
	If temp '= ..#STRINGNOTFOUND { Quit temp }
	Set temp = ..FindOps(str,$ListBuild("+","-"))
	If temp '= ..#STRINGNOTFOUND { Quit temp }
	Quit ..#STRINGNOTFOUND
}

Method FindEdge(str As %String, startLocation As %Integer, forward As %Integer = 1) [ Internal ]
{
	If forward = 1
	{
		Set end = $Length(str)
		Set step = 1
	}
	Else
	{
		Set end = 1
		Set step = -1
	}
	For location = startLocation+step:step:end
	{
		If $Find(..#RESERVEDCHARACTERS,$Extract(str,location)) > 0
		{
			Set location = location - step
			Quit
		}
	}
	Quit location
}

Method FindFunctions(ByRef str As %String) [ Internal ]
{
	Set i = 0
	For
	{
		Set i = i+1
		Set fn = $Piece(..#NONAGGREGATEFUNCTIONS_","_..#FUNCTIONLIST,",",i)
		If fn = "" { Quit }
		Set location = $Find(str,fn)
		While (location > 0)
		{
			If $Extract(str,location) = $Char(0)
			{
				Set vnum = $Extract(str,location+1,$Find(str,$Char(2),location)-2)
				Set ..WhichVar = ..WhichVar + 1
				If (..SeparateFunctions = 0) || (i <= $Length(..#NONAGGREGATEFUNCTIONS,","))
				{
					Set ..Vars(..WhichVar) = fn
					Merge ..Vars(..WhichVar,1) = ..Vars(vnum)
				}
				Else
				{
					Set ..WhichFunc = ..WhichFunc + 1
					Set ..Vars(..WhichVar) = "AGGREGATE"_..Prefix_..WhichFunc
					Set ..Funcs(..WhichFunc) = fn
					Merge ..Funcs(..WhichFunc,1) = ..Vars(vnum)
				}
				Set $Extract(str,location - $Length(fn), location + $Length(vnum) + 1) = $Char(0)_..WhichVar_$Char(2)
			}
			Else
			{
				$$$ThrowException("FunctionFindError","Functions must be followed by parenthetical expressions.")
			}
			Set location = $Find(str,fn)
		}
	}
}

Method ParseInternal(Output out, str As %String) [ Internal ]
{
	While $Find(str,"(") > 0
	{
		Kill outInternal
		Set ..WhichVar = ..WhichVar + 1
		Set temp = $Find(str,"(") - 1
		Set trailingString = ..ParenParse(.outInternal,$Extract(str,temp,*))
		Set str = $Extract(str,1,temp-1)_$Char(0)_..WhichVar_$Char(2)_trailingString
		Merge ..Vars(..WhichVar) = outInternal
	}

	Do ..FindFunctions(.str)

	For
	{
		Set temp = ..FindNextOperator(str)
		If temp = ..#STRINGNOTFOUND
		{
			Quit
		}
		Set ..WhichVar = ..WhichVar + 1
		Set begin = ..FindEdge(str,temp,0)
		Set end = ..FindEdge(str,temp,1)
		Set ..Vars(..WhichVar) = $Extract(str,temp)
		If $Extract(str,begin) = $Char(0)
		{
			Merge ..Vars(..WhichVar,1) = ..Vars($Extract(str,begin+1,temp-2))
		}
		Else
		{
			Set ..Vars(..WhichVar,1) = $Extract(str,begin,temp-1)
		}
		If $Extract(str,temp+1) = $Char(0)
		{
			Merge ..Vars(..WhichVar,2) = ..Vars($Extract(str,temp+2,end-1))
		}
		Else
		{
			Set ..Vars(..WhichVar,2) = $Extract(str,temp+1,end)
		}
		Set $Extract(str,begin,end) = $Char(0)_..WhichVar_$Char(2)
	}

	If ($Extract(str,1) = $Char(0)) && ($Extract(str,*) = $Char(2))
	{
		Merge out = ..Vars($Extract(str,2,*-1))
	}
	Else
	{
		Set out = str
	}
}

Method Parse(Output out, str As %String)
{
	Kill out
	Set ..WhichVar = 0
	Set ..WhichFunc = 0
	Do ..ParseInternal(.outInternal,str)
	Merge out("CALCULATE",1) = outInternal
	If ..SeparateFunctions '= 0
	{
		Merge out("AGGREGATE") = ..Funcs
	}
	Kill ..Vars
	Kill ..Funcs
}

Method Unparse(ByRef toUnparse) As %List
{
	Set position = ""
	Set output = ""
	If $Data(toUnparse) = 10
	{
		For
		{
			Set position = $Order(toUnparse(position))
			If position = "" { Quit }
			Kill internalToUnparse
			Merge internalToUnparse = toUnparse(position)
			Set $List(output,*+1) = ..Unparse(.internalToUnparse)
		}
	}
	ElseIf $Data(toUnparse) = 1
	{
		Set output = $ListBuild(toUnparse)
	}
	ElseIf $Data(toUnparse) = 11
	{
		Set internalResults = ""
		For
		{
			Set position = $Order(toUnparse(position))
			If position = "" { Quit }
			Kill internalToUnparse
			Merge internalToUnparse = toUnparse(position)
			Set $List(internalResults,*+1) = $List(..Unparse(.internalToUnparse),1)
		}
		If $ListLength(internalResults) = 1
		{
			Set $List(output,*+1) = toUnparse_"("_$List(internalResults,1)_")"
		}
		ElseIf $ListLength(internalResults) = 2
		{
			Set $List(output,*+1) = "("_$List(internalResults,1)_")"_toUnparse_"("_$List(internalResults,2)_")"
		}
		Else
		{
			$$$ThrowException("FormatNotUnderstood","Branches of parsed object can have either one or two subbranches")
		}
	}
	Quit output
}

Storage Default
{
<Data name="EqnParserState">
<Value name="1">
<Value>VarName</Value>
</Value>
<Value name="2">
<Value>FnList</Value>
</Value>
<Value name="3">
<Value>WhichVar</Value>
</Value>
<Value name="4">
<Value>WhichFunc</Value>
</Value>
<Value name="5">
<Value>SeparateFunctions</Value>
</Value>
<Value name="6">
<Value>Prefix</Value>
</Value>
</Data>
<State>EqnParserState</State>
<StreamLocation>^ML.DataPrep.EqnParserS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
