Include DEMOMACROS

Class ML.Director
{

ClassMethod PublishABT(pCubeName As %String = "", pABTName As %String = "", pFullColumnExpansion As %Boolean = 0, pDataPrep As %String = "")
{
		Set tSC = $$$OK
		Try
		{
			If pABTName="" Set pABTName=pCubeName
			If pABTName'?1A.(1A,1N)
			{
				$$$ThrowException("InvalidABTNameException", "The name '"_pABTName_"' can not be used as a valid ABT name. Please specify a valid ABT name on the pABTName parameter")
			}
			If pCubeName="" Set pCubeName=pABTName
			Set tGeneratedClassName = "PublishedABT."_pABTName
			Do ##class(%Dictionary.ClassDefinition).%DeleteId(tGeneratedClassName)
			Kill ^PublishedABT(pABTName)
			
			Set tSC = ##class(ML.ABT.Utils).GetFactSQLTableName(pCubeName,.tFACTTABLENAME)
			$$$ThrowStatusExceptionIfError(tSC, "GetFactSQLTableName")
			Set ^PublishedABT(pABTName,"FACTTABLENAME") = tFACTTABLENAME
			
			Set tDataPrepLists = ##class(ML.DataPrep.Utils).ParsePrepListString($ZStrip(pDataPrep,"*"," "))
			
			Do ##class(ML.ABT.Utils).StoreABTMetaData(pCubeName, pABTName, pFullColumnExpansion)
			Do ##class(ML.DataPrep.Utils).PrepareAll(pABTName, tDataPrepLists)
			
			//
			// CLASS
			//

			Set oGeneratedClass = ##class(%Dictionary.ClassDefinition).%New()
			Set oGeneratedClass.Name = tGeneratedClassName
			Set oGeneratedClass.IncludeCode="DEMOMACROS"
			Set oGeneratedClass.Super="ML.ABT.AbstractABT"

			//
			// QUERY
			//
			
			Set oQuery = ##class(%Dictionary.QueryDefinition).%New()
			Set oQuery.parent = oGeneratedClass
			Do oGeneratedClass.Queries.Insert(oQuery)

			Set oQuery.Name=pABTName_"GetFeatures"
			Set oQuery.FormalSpec="pSourceId:%String"
			Set oQuery.Type="%Query"
			Do oQuery.Parameters.SetAt(^PublishedABT(pABTName,"ROWSPEC"), "ROWSPEC")
			Set oQuery.SqlName=oQuery.Name
			Set oQuery.SqlProc=1
			
			//
			// METHOD CLOSE
			//
			Set oMethodClose = ##class(%Dictionary.MethodDefinition).%New()
			Set oMethodClose.parent=oGeneratedClass
			Set oMethodClose.Name=pABTName_"GetFeaturesClose"
			Set oMethodClose.ClassMethod=1
			Set oMethodClose.FormalSpec="&qHandle:%Binary,pSourceId:%String"
			Set oMethodClose.ReturnType="%Status"
			Do oMethodClose.Implementation.WriteLine(" Quit $$$OK")

			//
			// METHOD EXECUTE
			//
			Set oMethodExecute = ##class(%Dictionary.MethodDefinition).%New()
			Set oMethodExecute.parent=oGeneratedClass
			Set oMethodExecute.Name=pABTName_"GetFeaturesExecute"
			Set oMethodExecute.ClassMethod=1
			Set oMethodExecute.FormalSpec="&qHandle:%Binary,pSourceId:%String"
			Set oMethodExecute.ReturnType="%Status"
			Do oMethodExecute.Implementation.WriteLine(" Set tSC = $$$OK")
			Do oMethodExecute.Implementation.WriteLine(" Try {")
			Do oMethodExecute.Implementation.WriteLine("   Set pSourceId=$Get(pSourceId)")
			Do oMethodExecute.Implementation.WriteLine("   If pSourceId="""" {")
			Do oMethodExecute.Implementation.WriteLine("     Set qHandle(""RS"") = ##class(%SQL.Statement).%ExecDirect(,""select * from "_^PublishedABT(pABTName,"FACTTABLENAME")_""")")
			Do oMethodExecute.Implementation.WriteLine("   } Else {")
			Do oMethodExecute.Implementation.WriteLine("     Set tID = ##class(ML.ABT.Utils).GetFactIdForCubeSourceId("""_pCubeName_""", pSourceId)")
			Do oMethodExecute.Implementation.WriteLine("     Set qHandle(""RS"") = ##class(%SQL.Statement).%ExecDirect(,""select * from "_^PublishedABT(pABTName,"FACTTABLENAME")_" where ID=""_tID)")
			Do oMethodExecute.Implementation.WriteLine("   }")
			Do oMethodExecute.Implementation.WriteLine("   $$$ThrowSQLExceptionIfResultError(qHandle(""RS""), ""ABTFactTableQueryException"")")
			Do oMethodExecute.Implementation.WriteLine(" } Catch (oException) { Set tSC = oException.AsStatus() }")
			Do oMethodExecute.Implementation.WriteLine(" Quit tSC")

			//
			// METHOD FETCH
			//
			Set oMethodFetch = ##class(%Dictionary.MethodDefinition).%New()
			Set oMethodFetch.parent=oGeneratedClass
			Set oMethodFetch.Name=pABTName_"GetFeaturesFetch"
			Set oMethodFetch.ClassMethod=1
			Set oMethodFetch.FormalSpec="&qHandle:%Binary,&Row:%List,&AtEnd:%Integer=0"
			Set oMethodFetch.ReturnType="%Status"
			Do oMethodFetch.Implementation.WriteLine(" Set tSC = $$$OK")
			Do oMethodFetch.Implementation.WriteLine(" Try {")

			// FUTURE: Default values should be different accordingly to flag that defines if this ABT is for decision tress or neural networks
			//		   There is an additional one-hot-encoding to be done on single star table references.
			Do oMethodFetch.Implementation.WriteLine("   Set Row=^PublishedABT("""_pABTName_""",""DEFAULTVALUES"")")
			Do oMethodFetch.Implementation.WriteLine("   Set oRS = qHandle(""RS"")")
			Do oMethodFetch.Implementation.WriteLine("   If oRS.%Next(.tSC) {")

			//For every column I care about...
			Set tFactTablePropertyName = ""
			For
			{
				Set tFactTablePropertyName = $Order(^PublishedABT(pABTName,"PMap1",tFactTablePropertyName))
				Quit:tFactTablePropertyName=""
				
				Set tStarTableName=^PublishedABT(pABTName,"PMap1",tFactTablePropertyName)
				Do oMethodFetch.Implementation.WriteLine()
				
				Set eqnParser = ##class(ML.DataPrep.EqnParser).%New()
				
				// Is this a measure or a single star table reference?
				// FUTURE: Here is where we should consider the flag to do one-hot-encoding of single star table references
				
				If tStarTableName = ""
				{
					If '$Data(^PublishedABT(pABTName,"Dropped",tFactTablePropertyName))
					{
						Set iColumnIndex=^PublishedABT(pABTName,"PMap2",tFactTablePropertyName)
						
						If $Data(^PublishedABT(pABTName,"QueryPiece",tFactTablePropertyName)) { Merge tempEqnObject = ^PublishedABT(pABTName,"QueryPiece",tFactTablePropertyName) }
						Else { Set tempEqnObject(1) = tFactTablePropertyName }
						
						Set equation = eqnParser.Unparse(.tempEqnObject)
						While $ListValid(equation) { Set equation = $List(equation,1) }
						Kill tempEqnObject
						
						If $Find(equation,tFactTablePropertyName_"NULLREPLACE")
						{
							Set equation = $Replace($Replace(equation,tFactTablePropertyName_"NULLREPLACE",^PublishedABT(pABTName,"Constants",tFactTablePropertyName_"NULLREPLACE"),"ERROR"),"COALESCE","..COALESCE")
						}
						
						Set aggregateNumber = 1
						While $Data(^PublishedABT(pABTName,"Constants","AGGREGATE"_tFactTablePropertyName_aggregateNumber))
						{
							Set equation = $Replace(equation,"AGGREGATE"_tFactTablePropertyName_aggregateNumber,^PublishedABT(pABTName,"Constants","AGGREGATE"_tFactTablePropertyName_aggregateNumber))
							Set aggregateNumber = aggregateNumber + 1
						}
												Try
						{
							Xecute "Set tTmp ="_$Replace(equation,tFactTablePropertyName,0)
							Xecute "Set tTmp ="_$Replace(equation,tFactTablePropertyName,1)
							Set equation = $Replace(equation,tFactTablePropertyName,"oRS.%Get("""_tFactTablePropertyName_""")")
						}
						Catch oException
						{
							If oException.Name = "<DIVIDE>"
							{
								Set equation = "oRS.%Get("""_tFactTablePropertyName_""")"
							}
							Else
							{
								Throw oException
							}
						}
						
						Do oMethodFetch.Implementation.WriteLine("     Set $List(Row,"_iColumnIndex_") = "_equation)
					}
				}
				Else
				{
					Do oMethodFetch.Implementation.WriteLine("     //"_tFactTablePropertyName)
					Do oMethodFetch.Implementation.WriteLine("     Set tColumnValue = oRS.%Get("""_tFactTablePropertyName_""")")

					//tColumnValue is a list of IDs on the tStarTableName
					Do oMethodFetch.Implementation.WriteLine("     Set listRS = ##class(%SQL.Statement).%ExecDirect(,""SELECT * from "_tStarTableName_" Where ID IN ( ""_tColumnValue_"" )"")")
					Do oMethodFetch.Implementation.WriteLine("     $$$ThrowSQLExceptionIfResultError(listRS, ""StarTableFetchException"")")
					
					Do oMethodFetch.Implementation.WriteLine("     While listRS.%Next() {")
					Do oMethodFetch.Implementation.WriteLine("       Set explodedPropertySuffix = listRS.%Get("""_tFactTablePropertyName_""")")
					Do oMethodFetch.Implementation.WriteLine("       If explodedPropertySuffix '= ""<null>"" {")
					Do oMethodFetch.Implementation.WriteLine("         Set explodedPropertySuffix = ##class(ML.ABT.Utils).NormalizeColumnName(explodedPropertySuffix)")
					Do oMethodFetch.Implementation.WriteLine("         Set fullExplodedPropertyName = """_tFactTablePropertyName_"_""_explodedPropertySuffix")
					Do oMethodFetch.Implementation.WriteLine("         Set iColumnIndex = ^PublishedABT("""_pABTName_""",""PMap1"","""_tFactTablePropertyName_""", fullExplodedPropertyName)")
					//One is the positive One_Hot_Encoding Value
					Do oMethodFetch.Implementation.WriteLine("         Set $List(Row,iColumnIndex)=1")
					Do oMethodFetch.Implementation.WriteLine("       }") 
					Do oMethodFetch.Implementation.WriteLine("     }") 
				}
			}

			Do oMethodFetch.Implementation.WriteLine("   } Else {")
			Do oMethodFetch.Implementation.WriteLine("     $$$ThrowStatusExceptionIfError(tSC, ""ABTFactTableFetchException"")")
			Do oMethodFetch.Implementation.WriteLine("     Set AtEnd=1")
			Do oMethodFetch.Implementation.WriteLine("     Set Row=""""")
			Do oMethodFetch.Implementation.WriteLine("   }")

			Do oMethodFetch.Implementation.WriteLine(" } Catch (oException) { Set tSC = oException.AsStatus() }")
			Do oMethodFetch.Implementation.WriteLine(" Quit tSC")

			// If the ABT has a defined target and this version of IRIS has IntegratedML installed, create methods for directly creating and training models in IntegratedML.
			If $Data(^PublishedABT(pABTName,"Target")) && ##class(%Dictionary.CompiledClass).%ExistsId("%ML.Utils")
			{
				Set oMethodModelDrop = ##class(%Dictionary.MethodDefinition).%New()
				Set oMethodModelDrop.parent=oGeneratedClass
				Set oMethodModelDrop.Name="IntegratedMLModelDrop"
				Set oMethodModelDrop.ClassMethod=1
				Set oMethodModelDrop.FormalSpec="pModelName:%String="""_pABTName_""""
				Set oMethodModelDrop.ReturnType="%Status"
				Do oMethodModelDrop.Implementation.WriteLine(" Set tSC = $$$OK")
				Do oMethodModelDrop.Implementation.WriteLine(" Write ""Dropping model ""_pModelName_"""",!")
				Do oMethodModelDrop.Implementation.WriteLine(" Try {")
				Do oMethodModelDrop.Implementation.WriteLine("   Set mRS = ##class(%SQL.Statement).%ExecDirect(,""DROP MODEL pModelName"")")
				Do oMethodModelDrop.Implementation.WriteLine("   $$$ThrowSQLExceptionIfResultError(mRS,""ModelDropException"")")
				Do oMethodModelDrop.Implementation.WriteLine(" } Catch (oException) { Set tSC = oException.AsStatus() }")
				Do oMethodModelDrop.Implementation.WriteLine(" Quit tSC")
				
				Set oMethodModelCreate = ##class(%Dictionary.MethodDefinition).%New()
				Set oMethodModelCreate.parent=oGeneratedClass
				Set oMethodModelCreate.Name="IntegratedMLModelCreate"
				Set oMethodModelCreate.ClassMethod=1
				Set oMethodModelCreate.FormalSpec="pModelName:%String="""_pABTName_""",pParams:%String="""""
				Set oMethodModelCreate.ReturnType="%Status"
				Do oMethodModelCreate.Implementation.WriteLine(" Set tSC = $$$OK")
				Do oMethodModelCreate.Implementation.WriteLine(" Write ""Creating model ""_pModelName_"" via IntegratedML."",!")
				Do oMethodModelCreate.Implementation.WriteLine(" Try {")
				Do oMethodModelCreate.Implementation.WriteLine("   Set statement = ""CREATE MODEL ""_pModelName_"" PREDICTING ("_^PublishedABT(pABTName,"Target")_") FROM (SELECT * FROM ("_tGeneratedClassName_"GetFeatures()))""")
				Do oMethodModelCreate.Implementation.WriteLine("   If pParams '= """" {")
				Do oMethodModelCreate.Implementation.WriteLine("     Set statement = statement_"" USING {""_pParams_""}""")
				Do oMethodModelCreate.Implementation.WriteLine("   }")
				Do oMethodModelCreate.Implementation.WriteLine("   Set mRS = ##class(%SQL.Statement).%ExecDirect(,statement)")
				Do oMethodModelCreate.Implementation.WriteLine("   $$$ThrowSQLExceptionIfResultError(mRS,""ModelCreateException"")")
				Do oMethodModelCreate.Implementation.WriteLine(" } Catch (oException) { Set tSC = oException.AsStatus() }")
				Do oMethodModelCreate.Implementation.WriteLine(" Quit tSC")

				Set oMethodModelTrain = ##class(%Dictionary.MethodDefinition).%New()
				Set oMethodModelTrain.parent=oGeneratedClass
				Set oMethodModelTrain.Name="IntegratedMLModelTrain"
				Set oMethodModelTrain.ClassMethod=1
				Set oMethodModelTrain.FormalSpec="pModelName:%String="""_pABTName_""",pParams:%String="""",pASync:%Integer=0"
				Set oMethodModelTrain.ReturnType="%Status"
				Do oMethodModelTrain.Implementation.WriteLine(" Set tSC = $$$OK")
				Do oMethodModelTrain.Implementation.WriteLine(" Write ""Training model ""_pModelName_"" via IntegratedML."",!")
				Do oMethodModelTrain.Implementation.WriteLine(" Try {")
				Do oMethodModelTrain.Implementation.WriteLine("   set tSQL = ""TRAIN MODEL ""_pModelName")
				Do oMethodModelTrain.Implementation.WriteLine("   if pParams '= """" {set tSQL = tSQL_"" USING ""_pParams}")
				Do oMethodModelTrain.Implementation.WriteLine("   set tStatement = ##class(%SQL.Statement).%New()")
				Do oMethodModelTrain.Implementation.WriteLine("   set tSC = tStatement.%Prepare(tSQL)")
				Do oMethodModelTrain.Implementation.WriteLine("   If $$$ISERR(tSC) { Throw $system.Status.GetErrorText(tSC) }")
				Do oMethodModelTrain.Implementation.WriteLine("   If pASync { job ##class(%SQL.Statement).%ExecDirect("""",tSQL) }")
				Do oMethodModelTrain.Implementation.WriteLine("   Else {")
				Do oMethodModelTrain.Implementation.WriteLine("     Set mRS = ##class(%SQL.Statement).%ExecDirect("""",tSQL)")
				Do oMethodModelTrain.Implementation.WriteLine("     $$$ThrowSQLExceptionIfResultError(mRS,""ModelTrainException"")")
				Do oMethodModelTrain.Implementation.WriteLine("   }")
				Do oMethodModelTrain.Implementation.WriteLine(" } Catch (oException) { Set tSC = oException.AsStatus() }")
				Do oMethodModelTrain.Implementation.WriteLine(" Quit tSC")
				
				Set oMethodModelPredict = ##class(%Dictionary.MethodDefinition).%New()
				Set oMethodModelPredict.parent=oGeneratedClass
				Set oMethodModelPredict.Name="IntegratedMLModelPredict"
				Set oMethodModelPredict.ClassMethod=1
				Set oMethodModelPredict.FormalSpec="pSourceId:%String="""",pModelName:%String="""_pABTName_""",pCopyColumns:%String="""_^PublishedABT(pABTName,"Target")_""""
				Set oMethodModelPredict.ReturnType="%SQL.StatementResult"
				If $Piece($Extract(^PublishedABT(pABTName,"ROWSPEC"),$Find(^PublishedABT(pABTName,"ROWSPEC"),^PublishedABT(pABTName,"Target")_":"),*),",",1) = "%Double" {
					Do oMethodModelPredict.Implementation.WriteLine(" Set tQueried = ""PREDICT(""_pModelName_"") As Prediction""")
				}
				Else {
					Do oMethodModelPredict.Implementation.WriteLine(" Set tQueried = ""PREDICT(""_pModelName_"") As Prediction,PROBABILITY(""_pModelName_"") As Probability""")
				}
				Do oMethodModelPredict.Implementation.WriteLine(" If pCopyColumns '= """" { Set tQueried = tQueried_"",""_pCopyColumns }")
				Do oMethodModelPredict.Implementation.WriteLine(" zw ""SELECT ""_tQueried_"" FROM ("_tGeneratedClassName_"GetFeatures(""_pSourceId_""))""")
				Do oMethodModelPredict.Implementation.WriteLine(" Quit ##class(%SQL.Statement).%ExecDirect("""",""SELECT ""_tQueried_"" FROM ("_tGeneratedClassName_"GetFeatures(""_pSourceId_""))"")")
				
				Set mRS = ##class(%SQL.Statement).%ExecDirect(,"DROP MODEL "_pABTName)
			}
			Set tSC = oGeneratedClass.%Save()
			Quit:$$$ISERR(tSC)
			
			Set tSC = $System.OBJ.Compile(tGeneratedClassName,"ck")
			
		}
	Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

ClassMethod RunModelOnABTSourceId(pPublishedABTName As %String, pSourceID As %String, pModel As %DeepSee.PMML.Model.AbstractModel, pModelDataOutput, pSynchronizeFirst As %Boolean = 0)
{
		Set tSC = $$$OK
		
		Try{
		
			If pSynchronizeFirst
			{
				Set tCubeName=^PublishedABT(pPublishedABTName, "CUBENAME")
				Set tSC = ##class(%DeepSee.Utils).%ProcessFact(tCubeName,pSourceID, 0)
				$$$ThrowStatusExceptionIfError(tSC, "RunModelOnABTSourceIdException")
			}
	
			Set pFeaturesStmt = ##class(%SQL.Statement).%New()
			Set tSC = pFeaturesStmt.%PrepareClassQuery("PublishedABT."_pPublishedABTName, pPublishedABTName_"GetFeatures")
			$$$ThrowStatusExceptionIfError(tSC, "RunModelOnABTSourceIdException")
	
			Set oRS = pFeaturesStmt.%Execute(pSourceID)
			$$$ThrowSQLExceptionIfResultError(oRS, "StarTableFetchException")
			
			Kill tInput
			If oRS.%Next() 
			{
				Set metaData = oRS.%GetMetaData()
				For i=1:1:metaData.columns.Count() 
				{
					Set metaColumn = metaData.columns.GetAt(i)
					Set tInput(metaColumn.colName) = oRS.%Get(metaColumn.colName)
				}
				
			}
	
			Set tSC = pModel.%ExecuteModel(.tInput, .pModelDataOutput)
			$$$ThrowStatusExceptionIfError(tSC, "RunModelOnABTSourceIdException")
			
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

}
