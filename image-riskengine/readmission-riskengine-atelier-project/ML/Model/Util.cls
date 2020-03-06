Include (%DeepSee, DEMOMACROS)

Class ML.Model.Util
{

ClassMethod GetModelInstance(pPMMLModelClassName As %String, Output pModel As %DeepSee.PMML.Model.AbstractModel) As %Status
{
		Set tSC = $$$OK
		Try
		{
			Set tSC = $classmethod(pPMMLModelClassName, "%GetModelInstance", .tModelType)
			Quit:$$$ISERR(tSC)
			
			Set tModelClass = pPMMLModelClassName_"."_tModelType
			
			//Now we can create that model
			Set pModel = $classmethod(tModelClass, "%New")
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

}
