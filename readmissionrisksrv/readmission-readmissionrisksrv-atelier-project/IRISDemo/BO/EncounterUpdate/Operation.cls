Include DEMOMACROS

Class IRISDemo.BO.EncounterUpdate.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method UpdatePredictionDetailsForEncounter(pReq As IRISDemo.BO.EncounterUpdate.EncounterUpdateRequest, Output pResp As IRISDemo.BO.EncounterUpdate.EncounterUpdateResponse) As %Status
{
		  
		  #dim pReq as IRISDemo.BO.EncounterUpdate.EncounterUpdateRequest
		  #dim pResp as IRISDemo.BO.EncounterUpdate.EncounterUpdateResponse
		  
		  Set tSC = $$$OK
		  
		  Try
			{
				//Create the Request Body for POST
				Set requestBody = {}
				
				//Set Values on requestBody
				Set requestBody.EncounterID = pReq.EncounterID
	
				If pReq.LACEScoreAggregate {
					Set requestBody.LACEScoreAggregate = pReq.LACEScoreAggregate
				}	
				
				If pReq.LACEScore {
					Set requestBody.LACEScore = pReq.LACEScore
				}		
				
				If pReq.MLPrediction {
					Set requestBody.MLPrediction = pReq.MLPrediction
				}		
				
				
				Set tResponse = ##class(%Net.HttpResponse).%New()
				Set tSC = ..Adapter.Post(.tResponse,,requestBody.%ToJSON())
				
				$$$ThrowStatusExceptionIfError(tSC, "Encounter Prediction REST Call Exception")
				
				Set pResp = ##class(IRISDemo.BO.EncounterUpdate.EncounterUpdateResponse).%New()
				Set JSONObj = ##class(%DynamicObject).%FromJSON(tResponse.Data)
				
				
				Set pResp.Status = JSONObj.requestResult.status
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
		<MapItem MessageType="IRISDemo.BO.EncounterUpdate.EncounterUpdateRequest">
			<Method>UpdatePredictionDetailsForEncounter</Method>
		</MapItem>
	</MapItems>
}

}
