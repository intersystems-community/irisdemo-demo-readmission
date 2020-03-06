/// This class is used to mark a class as a published ABT
Class ML.ABT.AbstractABT [ Abstract ]
{

ClassMethod COALESCE(pValue As %String, pReplaceValue As %String) As %String [ CodeMode = expression ]
{
$Case(pValue,"":pReplaceValue, :pValue)
}

}
