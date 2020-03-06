Class ML.ContextSearch Extends %ZEN.Portal.ContextSearch
{

ClassMethod PMMLModels(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
        Set pParms("class")="%DeepSee.PMML.Definition"
        Set tSC = ##class(Ens.ContextSearch).SubclassOf(.pCaption, .pTopResults, .pResults, .pParms, .pSearchKey)
        Quit:$$$ISERR(tSC) tSC
        
        Set n=$Order(pResults(""),-1)+1
        Set pResults(n) = "[Based on Request]"
        
        Quit tSC
}

ClassMethod DeepSeeCubes(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
        Set tSC = ##class(%DeepSee.Utils).%GetCubeList(.vListOfCubes, "", 1)
        Quit:$$$ISERR(tSC) tSC
        
        Set tKey=""
        For
        {
            Set tKey = $Order(vListOfCubes(tKey))
            Quit:tKey=""
            
            Set pResults(tKey)=$ListGet(vListOfCubes(tKey),1)
        }
        Quit $$$OK
}

ClassMethod ABT(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String = "") As %Status
{
        Set pParms("class")="ML.ABT.AbstractABT"
        Set tSC = ##class(Ens.ContextSearch).SubclassOf(.pCaption, .pTopResults, .pResults, .pParms, .pSearchKey)
                
        Quit tSC
}

}
