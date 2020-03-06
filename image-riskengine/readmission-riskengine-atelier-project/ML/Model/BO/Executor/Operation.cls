Include %PMML

Class ML.Model.BO.Executor.Operation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

/// This setting is required only if you are using the simple Execute() method. 
Property PMML As %String(MAXLEN = "") [ InitialExpression = "[Based on Request]" ];

Property ABT As %String(MAXLEN = "");

/// Internal array of model instances to (re)use
Property ModelInstances As array Of %DeepSee.PMML.Model.AbstractModel [ Internal, Private ];

Parameter SETTINGS = "PMML:Basic:selector?context={ML.ContextSearch/PMMLModels?targets=1&productionName=@productionId},CubeDataSource:Basic:selector?context={ML.ContextSearch/ABT?targets=1&productionName=@productionId}";

Method Execute(pInput As ML.Model.BO.Executor.ExecuteModelReq, Output pOutput As ML.Model.BO.Executor.ExecuteModelResp) As %Status
{
		#Dim oModel As %DeepSee.PMML.Model.AbstractModel
		
		Set tSC = $System.Status.OK()
		Try
		{			
			// Obtain an instance of the requested model
			Set tSC = ..GetModelInstance(.oModel)
			Quit:$$$ISERR(tSC)
			
			// Provide ModelData as an array
			Kill aModelData
			Set tKey = ""
			For 
			{
				Set tValue = pInput.ModelData.GetNext(.tKey)
				Quit:tKey=""
				
				Set aModelData(tKey) = tValue
			}
			
			// Now, let's execute the model...
			Set tSC = oModel.%ExecuteModel(.aModelData, .oModelDataOutput)
			Quit:$System.Status.IsError(tSC)
			
			
			//Now we have to convert the data output into an array so we can then copy the values into pOutput.ModelOutput
			//Unfortunately, the DataOutput model has no %GetAsArray to help us with. 
			
			Set pOutput = ##class(ML.Model.BO.Executor.ExecuteModelResp).%New()
			
			Do oModelDataOutput.%GetFields(.aFields)
			set tFieldName = ""
			For 
			{
				Set tFieldName = $order(aFields(tFieldName))
				Quit:tFieldName=""
				
				Set tPropName = $$$PROPERTYNAME(tFieldName)
				
				Do pOutput.ModelOutput.SetAt($property(oModelDataOutput, tPropName), tPropName)
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

Method ExecuteParam(pInput As ML.Model.BO.Executor.ExecuteParamModelReq, Output pOutput As ML.Model.BO.Executor.ExecuteModelResp) As %Status
{
		Set ..PMML = pInput.ModelClassName
		Quit ..Execute(pInput, .pOutput)
}

Method GetModelInstance(Output pModel As %DeepSee.PMML.Model.AbstractModel) As %Status [ Private ]
{
		Set tSC = $$$OK
		Try
		{
			If ..PMML="[Based on Request]"
			{
				Set tSC = $System.Status.DisplayError(5001, "Specify the PMML parameter or use ExecuteParamModelReq instead of ExecuteModelReq.")
				Quit
			}
			
			// Is this model on the cache?
			Set pModel = ..ModelInstances.GetAt(..PMML)
			Quit:$isobject(pModel)
			
			// No, so let's instantiate it:
			Set tSC = ##class(ML.Model.Util).GetModelInstance(..PMML, .pModel)
			Quit:$$$ISERR(tSC)
			
			// And add the model to the cache...
			Do ..ModelInstances.SetAt(pModel, ..PMML)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

Method ExecuteModelWithABT(pInput As ML.Model.BO.Executor.ExecuteModelWithABTReq, Output pOutput As ML.Model.BO.Executor.ExecuteModelResp) As %Status
{
		#Dim oModel As %DeepSee.PMML.Model.AbstractModel
		
		Set tSC = $System.Status.OK()
		Try
		{			
			Set tSC = ..GetModelInstance(.oModel)
			Quit:$$$ISERR(tSC)
			
			Set tSC = ##class(ML.Director).RunModelOnABTSourceId(..ABT,  pInput.SourceID, oModel, .oModelDataOutput, 1)
			Quit:$$$ISERR(tSC)	
			
			Set pOutput = ##class(ML.Model.BO.Executor.ExecuteModelResp).%New()
			
			Do oModelDataOutput.%GetFields(.aFields)
			set tFieldName = ""
			For 
			{
				Set tFieldName = $order(aFields(tFieldName))
				Quit:tFieldName=""
				
				Set tPropName = $$$PROPERTYNAME(tFieldName)
				
				Do pOutput.ModelOutput.SetAt($property(oModelDataOutput, tPropName), tPropName)
			}
			 
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

XData MessageMap
{
<MapItems>
		<MapItem MessageType="ML.Model.BO.Executor.ExecuteParamModelReq">
			<Method>ExecuteParam</Method>
		</MapItem>
		<MapItem MessageType="ML.Model.BO.Executor.ExecuteModelReq">
			<Method>Execute</Method>
		</MapItem>
		<MapItem MessageType="ML.Model.BO.Executor.ExecuteModelWithABTReq">
			<Method>ExecuteModelWithABT</Method>
		</MapItem>
	</MapItems>
}

}
