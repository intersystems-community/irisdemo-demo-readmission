Include DEMOMACROS

Class ML.Model.BO.Executor.ServiceConsumer Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method GetMLPredictionForCubeSourceID(pReq As ML.Model.BO.Executor.CubeSourceScoreRequest, Output pResp As ML.Model.BO.Executor.ScoreResponse) As %Status
{
		  
		  #dim pReq as ML.Model.BO.Executor.CubeSourceScoreRequest
		  #dim pResp as ML.Model.BO.Executor.ScoreResponse
		  
		  Set tSC = $$$OK
		  
		  Try
			{
				//Create the Request Body for POST
				Set requestBody = {}
				
				//Set Values on requestBody
				Set requestBody.operationName = pReq.MLOperationName
	
				//Check if SourceID was passed in
				If pReq.CubeSourceRowID {
					Set requestBody.sourceID = pReq.CubeSourceRowID
				}		
				
				Set tResponse = ##class(%Net.HttpResponse).%New()
				Set tSC = ..Adapter.Post(.tResponse,,requestBody.%ToJSON())
				
				$$$ThrowStatusExceptionIfError(tSC, "MLPrediction REST Call Exception")
				
				set pResp = ##class(ML.Model.BO.Executor.ScoreResponse).%New()
				set JSONObj = ##class(%DynamicObject).%FromJSON(tResponse.Data)
				
				If JSONObj.requestResult.status = "OK"{
				
					Set iter = JSONObj.requestResult.data.prediction.%GetIterator()
					While iter.%GetNext(.key , .value ) {
						Do pResp.ModelOutput.SetAt(value, key)
					}
						
				} Else {
					$$$ThrowException("ML Prediction Error", "An error occured while trying to retrieve your prediction request results")
				}
			}
			Catch (oException)
			{
				Set tSC = oException.AsStatus()
			}
			
			Quit tSC
}

Method GetMLPredictionForModelData(pReq As ML.Model.BO.Executor.SimpleScoreRequest, Output pResp As ML.Model.BO.Executor.ScoreResponse) As %Status
{
		  
		  #dim pReq as ML.Model.BO.Executor.SimpleScoreRequest
		  #dim pResp as ML.Model.BO.Executor.ScoreResponse
		  
		  Set tSC = $$$OK
		  
		  Try
			{	
				//Create the Request Body for POST
				Set requestBody = {}
				
				//Set Values on requestBody
				Set requestBody.operationName = pReq.MLOperationName
				
				//Check If a datamap was passed in
				Set count = pReq.MLModelDataForPrediction.Count()
				If count '= 0 { 
					Set requestBody.dataMap = []
					
					Set tKey = ""
					For 
					{
						Set tValue = pReq.MLModelDataForPrediction.GetNext(.tKey)
						Quit:tKey=""
						Do requestBody.dataMap.%Push({"key": (tKey), "value": (tValue)})
					}
				}
						
				
				Set tResponse = ##class(%Net.HttpResponse).%New()
				Set tSC = ..Adapter.Post(.tResponse,,requestBody.%ToJSON())
				
				$$$ThrowStatusExceptionIfError(tSC, "MLPrediction REST Call Exception")
				
				set pResp = ##class(ML.Model.BO.Executor.ScoreResponse).%New()
				set JSONObj = ##class(%DynamicObject).%FromJSON(tResponse.Data)
				
				If JSONObj.requestResult.status = "OK"{
				
					Set iter = JSONObj.requestResult.data.prediction.%GetIterator()
					While iter.%GetNext(.key , .value ) {
						Do pResp.ModelOutput.SetAt(value, key)
					}
						
				} Else {
					$$$ThrowException("ML Prediction Error", "An error occured while trying to retrieve your prediction request results")
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
		<MapItem MessageType="ML.Model.BO.Executor.CubeSourceScoreRequest">
			<Method>GetMLPredictionForCubeSourceID</Method>
		</MapItem>
		<MapItem MessageType="ML.Model.BO.Executor.SimpleScoreRequest">
			<Method>GetMLPredictionForModelData</Method>
		</MapItem>
	</MapItems>
}

}
