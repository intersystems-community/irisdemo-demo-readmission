Include DEMOMACROS

Class ML.Model.BS.ExecutorService.Service Extends IRISDemo.BS.REST.Service
{

ClassMethod CalculatePrediction() As %Status
{
		Set tSC = $$$OK
		Try
		{
			
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.requestResult={}
			Set response.requestResult.data = {}
			Set response.requestResult.data.prediction = {}
			
			Set PMMLOperationRequest = ""

			Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set operationName = request.operationName
			If operationName = "" {
				$$$ThrowException("NullOperationNameException","Operation Name needs to be specified on request body")
			}
			
			If request.sourceID '= ""{
				Set PMMLOperationRequest = ##class(ML.Model.BO.Executor.ExecuteModelWithABTReq).%New()
				Set PMMLOperationRequest.SourceID = request.sourceID
			}
			
			If request.dataMap '= "" {
				Set PMMLOperationRequest = ##class(ML.Model.BO.Executor.ExecuteModelReq).%New()
				
				Set iter = request.dataMap.%GetIterator()
				while iter.%GetNext(.modelPropKey , .modelPropVal ) {
					Do PMMLOperationRequest.ModelData.SetAt(modelPropVal, modelPropKey)
				}
			}
			
			If PMMLOperationRequest = "" {
				$$$ThrowException("NullPMMLOperationRequest","Request Body needs a SourceID or a DataMap to be specified")
			}
			Do ..DispatchTo(operationName, PMMLOperationRequest, .pResponse)
			
			Set tKey=""
			For
			{
				Set tKey=pResponse.ModelOutput.Next(tKey)
				Quit:tKey=""
				
				Set tValue=pResponse.ModelOutput.GetAt(tKey)
				
				Do response.requestResult.data.prediction.%Set(tKey, tValue)
			}

			Set response.requestResult.status="OK"
		}
		Catch (oException)
		{
			//
			// Ops! Something went wrong!
			//
			Set response.requestResult.status="Error"
			Set response.requestResult.exception=$$$ExceptionAsJSON(oException)
		}
		
		// Whatever the response is, let's send it
		Write response.%ToJSON()
		
		Quit $$$OK
}

XData UrlMap
{
<Routes>
		<Route Url="/calculateprediction" Method="POST" Call="CalculatePrediction"/>
	</Routes>
}

}
