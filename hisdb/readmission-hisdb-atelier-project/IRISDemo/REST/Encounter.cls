Include DEMOMACROS

Class IRISDemo.REST.Encounter Extends %CSP.REST
{

	Parameter UseSession = 1;
	
	Parameter CONVERTINPUTSTREAM = 1;
	
	Parameter CHARSET = "utf-8";
	
	Parameter HandleCorsRequest = 1;

	XData UrlMap
	{
		<Routes>
		  <Route Url="/resetdemo" Method="GET" Call="ResetDemo"/>
		  <Route Url="/discharge" Method="POST" Call="Discharge"/>
		  <Route Url="/list" Method="GET" Call="List"/>
		  <Route Url="/admissionslist" Method="GET" Call="AdmissionsList"/>
		  <Route Url="/calculateReadmissionPrediction" Method="GET" Call="CalculateReadmissionPrediction"/>
		  <Route Url="/updateprobabilities" Method="POST" Call="UpdateEncounterReadmissionProbabilities"/>
		</Routes>
	}
	
	ClassMethod ResetDemo() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.requestResult={}

			Do ##class(IRISDemo.Data.Utils).ResetDemo()
			
			//
			// Everything worked out OK!
			//
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
	
	ClassMethod List() As %Status
	{
		#Dim oRS As %SQL.StatementResult
		#Dim oResultMetadata As %SQL.StatementMetadata
		
		Set tSC = $$$OK
		Try
		{
		
			Set MRN = %request.Get("MRN")
			Set firstName = %request.Get("firstName")
			Set lastName = %request.Get("lastName")
			Set encounterNumber = %request.Get("encounterNumber")
			
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.encounters=[]
			Set response.requestResult={}
			
			Set tSQL="select Patient->MRN, Patient->FirstName, Patient->LastName, Patient->Gender, Patient->DoB, "_
					 "ID As EncounterID, EncounterNumber, EncounterType, EncounterStart, EncounterEnd, "_
					 "EncounterStatus, DischargeDestination, LACEScore, LACEScoreAggregate, ReadmissionProbability "_
					 " from IRISDemo_Data.Encounter"
			
			Set bHasWhereClause=0
			
			Set MRN=$Translate(MRN,"'","")
			If MRN'=""
			{
				Set tSQL=tSQL_" where Patient->MRN='"_MRN_"'"
				Set bHasWhereClause=1
			}

			Set firstName=$Translate(firstName,"'","")
			If firstName'=""
			{
				Set tSQL=tSQL_$Select(bHasWhereClause:" and ",1:" where ")_" Patient->FirstName %StartsWith '"_firstName_"'"
				Set bHasWhereClause=1
			}

			Set lastName=$Translate(lastName,"'","")
			If lastName'=""
			{
				Set tSQL=tSQL_$Select(bHasWhereClause:" and ",1:" where ")_" Patient->LastName %StartsWith '"_lastName_"'"
			}
			
			Set encounterNumber=$Translate(encounterNumber,"'","")
			If encounterNumber'=""
			{
				Set tSQL=tSQL_$Select(bHasWhereClause:" and ",1:" where ")_" EncounterNumber %StartsWith '"_encounterNumber_"'"
			}
			
			Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL)
			$$$ThrowSQLExceptionIfResultError(oRS, "ListSQLException")
			
			Set oResultMetadata = oRS.%GetMetadata()
			
			While oRS.%Next()
			{
				Set encounter={}
				
				For iCol=1:1:oResultMetadata.columnCount
				{
					Set oColumn = oResultMetadata.columns.GetAt(iCol)
					
					If oColumn.clientType=2 //DATE 
					{
						Set $property(encounter, oColumn.colName)=$ZDate(oRS.%GetData(iCol), 3)
					}
					ElseIf oColumn.clientType=8 //TIME
					{
						Set $property(encounter, oColumn.colName)=$ZTime(oRS.%GetData(iCol))
					}
					Else
					{
						Set $property(encounter, oColumn.colName)=oRS.%GetData(iCol)
					}
				}
				
				Do response.encounters.%Push(encounter)
			}
			
			//
			// Everything worked out OK!
			//
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
	
	ClassMethod AdmissionsList() As %Status
	{
		#Dim oRS As %SQL.StatementResult
		#Dim oResultMetadata As %SQL.StatementMetadata
		
		Set tSC = $$$OK
		Try
		{
			
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.encounters=[]
			Set response.requestResult={}
			
			Set tSQL="select Patient->MRN, Patient->FirstName, Patient->LastName, Patient->Gender, Patient->DoB, "_
					 "ID As EncounterID, EncounterNumber, EncounterType, EncounterStart, EncounterEnd, "_
					 "EncounterStatus, DischargeDestination, LACEScore, LACEScoreAggregate, ReadmissionProbability "_
					 " from IRISDemo_Data.Encounter WHERE EncounterStatus = 'A'"
			
			Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL)
			$$$ThrowSQLExceptionIfResultError(oRS, "ListSQLException")
			
			Set oResultMetadata = oRS.%GetMetadata()
			
			While oRS.%Next()
			{
				Set encounter={}
				
				For iCol=1:1:oResultMetadata.columnCount
				{
					Set oColumn = oResultMetadata.columns.GetAt(iCol)
					
					If oColumn.clientType=2 //DATE 
					{
						Set $property(encounter, oColumn.colName)=$ZDate(oRS.%GetData(iCol), 3)
					}
					ElseIf oColumn.clientType=8 //TIME
					{
						Set $property(encounter, oColumn.colName)=$ZTime(oRS.%GetData(iCol))
					}
					Else
					{
						Set $property(encounter, oColumn.colName)=oRS.%GetData(iCol)
					}
				}
				
				Do response.encounters.%Push(encounter)
			}
			
			//
			// Everything worked out OK!
			//
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
	
	ClassMethod Discharge() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.requestResult={}
			
			// Transform the JSON string from the POST into a dynamic object
			Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set oEncounter = ##class(IRISDemo.Data.Encounter).%OpenId(request.encounterId)
			If '$IsObject(oEncounter) $$$ThrowException("EncounterNotFoundException", "encounterId: "_request.encounterId)
			
			Set dischargeDestCode = request.dischargeDestCode
			If dischargeDestCode ="" $$$ThrowException("DischargeDestinationNotProvidedException", "dischargeDest: "_request.dischargeDestCode)
			
			Do oEncounter.Discharge(dischargeDestCode)
			
			//
			// Everything worked out OK!
			//
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
	
	ClassMethod CalculateReadmissionPrediction() As %Status
	{
		Set tSC = $$$OK
		Try
		{
			// Configuring response type to JSON
			Set %response.ContentType=..#CONTENTTYPEJSON
			
			// Creating the response object
			Set response = {}
			Set response.requestResult={}
			
			// Transform the JSON string from the POST into a dynamic object
			//Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set httprequest=##class(%Net.HttpRequest).%New()
			Set httprequest.Server="RRLACESrv"
			Set httprequest.Port=52773
			
			Do httprequest.SetParam("sourceID", 28470)
			Do httprequest.SetParam("procedureName", "MLEncounter")
			
			Do httprequest.Get("/csp/appint/rest/cube/getcubedataforid")
			
			//
			// Everything worked out OK!
			//
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
	
	ClassMethod UpdateEncounterReadmissionProbabilities() As %Status
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

			Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
			
			Set encounterId = request.EncounterID
			If encounterId = "" {
				$$$ThrowException("NullEncounterIdException","EncounterId needs to be specified on request body")
			}
			
			Set laceScoreAggregate = request.LACEScoreAggregate
			If laceScoreAggregate = ""{
				$$$ThrowException("NulllaceScoreAggregateException","laceScoreAggregate needs to be specified on request body")
			}
			
			Set laceScore = request.LACEScore
			If laceScore = ""{
				$$$ThrowException("NUlllaceScoreException","laceScore needs to be specified on request body")
			}
			
			Set mlProbability = request.MLPrediction
			If mlProbability = ""{
				$$$ThrowException("NullmlProbabilityException","mlProbability needs to be specified on request body")
			}
			
			Set tSC = ##class(IRISDemo.Data.Encounter).UpdateProbabilities(encounterId,laceScoreAggregate,laceScore,mlProbability)
			$$$ThrowStatusExceptionIfError(tSC, "UpdateEncounterProbabilitiesException")

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
}