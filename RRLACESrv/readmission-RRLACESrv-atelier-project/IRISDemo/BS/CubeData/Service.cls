Include DEMOMACROS

Class IRISDemo.BS.CubeData.Service Extends IRISDemo.BS.REST.Service
{
	ClassMethod GetCubeABTDataForEncounter() As %Status
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
			Set response.requestResult.data.ABTData = {}

			Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set procedureName = request.procedureName
			If procedureName = "" {
				$$$ThrowException("NullProcedureNameException","Procedure Name needs to be specified on request body")
			}
			
			Set encounterNumber = request.encounterNumber
			If encounterNumber = ""{
				$$$ThrowException("NullOperationNameException","Encounter Number needs to be specified on request body")
			}
			
			Set encounter = ##class(IRISDemo.DataLake.Encounter).EncounterNumberIndexOpen(encounterNumber)
			If encounter = ""{
				$$$ThrowException("NullOperationNameException","Encounter Does Not Exist For Encounter Number")
			}

			Set tSQL = "call PublishedABT."_procedureName_"GetFeatures("_encounter.%Id()_")"
			
			Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL)
			$$$ThrowSQLExceptionIfResultError(oRS, "FactRowSQLException")
			
			Set oResultMetadata = oRS.%GetMetadata()
			Set factRow = {}
			
			While oRS.%Next()
			{
				
				For iCol=1:1:oResultMetadata.columnCount
				{
					Set oColumn = oResultMetadata.columns.GetAt(iCol)
					Do response.requestResult.data.ABTData.%Set(oColumn.colName, oRS.%GetData(iCol))
				}
			}

			Set response.requestResult.status="OK"
		}
		Catch (oException)
		{
			//
			// Oops! Something went wrong!
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
		<Route Url="/getcubedataforencounter" Method="POST" Call="GetCubeABTDataForEncounter"/>
	</Routes>
	}
}