Include (%DeepSee, DEMOMACROS)

Class ML.ABT.Utils
{

ClassMethod StoreABTMetaData(pCubeName As %String, pABTName As %String, pFullColumnExpansion As %Boolean = 0)
{
		Set ROWSPEC=""
		Set tDefaultValues=""
		Set tPropertyMap=""
		
		If pABTName="" $$$ThrowException("StoreABTMetaDataException", "pABTName is required.")
		
		Set tSC = ..GetExplodedColumnNamesForCube(pCubeName, pFullColumnExpansion, .columnList)
		$$$ThrowStatusExceptionIfError(tSC, "GetColumnNamesException")

		// columnList:
		// 1- exploded prop name
		// 2- exposed type
		// 3- default value
		// 4- is it a list
		// 5- fact table property name
		// 6- star table name
		
		For i=1:1:$ListLength(columnList)
		{
			Set lProp=$ListGet(columnList, i)
			Set tExplodedPropertyName=..NormalizeColumnName($ListGet(lProp,1))
			Set tExplodedPropertyDT=$ListGet(lProp,2)
			Set tExplodedPropertyDefault=$ListGet(lProp,3)
			Set tFactTablePropertyName=$ListGet(lProp,5)
			Set tStarTableName=$ListGet(lProp,6)

			// ROWSPEC will hold a comma separated list of pairs of FEATURE_NAME:FEATURE_DATATYPE
			Set $Piece(ROWSPEC, ",", i)=tExplodedPropertyName_":"_tExplodedPropertyDT

			// tDefaultValues is a %List. Every element of the list represents the default value of the corresponding feature on ROWSPEC
			Set $List(tDefaultValues, i)=tExplodedPropertyDefault

			Set ^PublishedABT(pABTName,"PMap1",tFactTablePropertyName)=tStarTableName
			Set ^PublishedABT(pABTName,"PMap1",tFactTablePropertyName,tExplodedPropertyName)=i
			Set ^PublishedABT(pABTName,"PMap2",tExplodedPropertyName)=i
		}

		Set ^PublishedABT(pABTName, "ROWSPEC")=ROWSPEC
		Set ^PublishedABT(pABTName, "DEFAULTVALUES")=tDefaultValues

		Set tSC = ##class(ML.ABT.Utils).GetFactSQLTableName(pCubeName,.tFACTTABLENAME)
		$$$ThrowStatusExceptionIfError(tSC, "StoreABTMetaDataException")

		Set ^PublishedABT(pABTName, "FACTTABLENAME")=tFACTTABLENAME
		Set ^PublishedABT(pABTName, "CUBENAME")=pCubeName
}

ClassMethod GetFactIdForCubeSourceId(pCubeName As %String, pCubeSourceId As %String) As %String
{
		Try
		{
			Set tCubeFactId = ""
			
			Set tCubeName=$ZConvert(pCubeName,"U")
			
			If $Data($$$DeepSeeIndexGLVN(tCubeName,"%sourceId",pCubeSourceId))
			{
				Set tCubeFactId = $Order($$$DeepSeeIndexGLVN(tCubeName,"%sourceId",pCubeSourceId, ""))
				Quit
			}
			
			$$$ThrowException("CubeSourceNotFoundException","Source with ID "_pCubeSourceId_" not found on cube "_pCubeName)
		}
		Catch (oException)
		{
			If oException.Name'="CubeSourceNotFoundException"
			{
				$$$ThrowStatusExceptionIfError(oException.AsStatus(), "CubeSourceUnexpectedException")
			}
			Else
			{
				Throw oException
			}
		}
		
		Quit tCubeFactId
}

ClassMethod GetFactClassName(pCubeName As %String, Output pFactClassName As %String) As %Status
{
			
		Set tSC = $$$OK
		
		Try {
		
			Set pFactClassName = ##class(%DeepSee.Utils).%GetCubeFactClass(pCubeName,.tSC)
			If $$$ISERR(tSC) Quit

		}
		Catch(ex) {
			Set pFactClassName = ""
			Set tSC = ex.AsStatus()
		}
	
		Quit tSC
}

ClassMethod GetFactSQLTableName(pCubeName As %String, Output pFactTableName As %String) As %Status
{
		Set tSC = $$$OK
		Try 
		{
			Set tFactClass = ##class(%DeepSee.Utils).%GetCubeFactClass(pCubeName,.tSC)			
			Quit:$$$ISERR(tSC)
	
			Set pFactTableName = ##class(%DeepSee.Generator).%GetSQLTableName(tFactClass)
		}
		Catch(ex) {
			Set pFactTableName = ""
			Set tSC = ex.AsStatus()
		}
	
		Quit tSC
}

ClassMethod GetExplodedColumnNamesForCube(pCubeName As %String, pFullColumnExpansion As %Boolean = 0, Output pColumnList As %List) As %Status
{
		Set tSC = $$$OK
		
		Try 
		{
			Set pColumnList = ""
			
			//Get the fact class name
			Set tSC = ..GetFactClassName(pCubeName, .tFactClassName)
			Quit:$$$ISERR(tSC)
			
			Set factPackageName = $PIECE(tFactClassName,".",1,*-1)
			
			//Get the dictionary representation of this class	
			Set factClassDict = ##class(%Dictionary.ClassDefinition).%OpenId(tFactClassName, , .tSC)
			Quit:$$$ISERR(tSC)
									
			//loop through properties  	
			For propIndex=1:1:factClassDict.Properties.Count() 
			{
			
				Set propertyObj = factClassDict.Properties.GetAt(propIndex) 
				If $Extract(propertyObj.Name,1)="%" Continue //Skipping %sourceId and other system properties 
				kill tempColumnList
				
				Set isAPercentType = ($EXTRACT(propertyObj.Type, 1) = "%")
						
				Set isList = (propertyObj.Type = "%DeepSee.Datatype.list")
				
				If isList //Is a System Type 
				{ 
					Set tSC = ..GenerateColumnListForFact(.tempColumnList,factPackageName,propertyObj.Name)
					
					If $$$ISERR(tSC){
						$$$ThrowException("GenerateColumnListException", "Error Generating Column List for: "_propertyObj.Name)
					}
					
					Set pColumnList = pColumnList_tempColumnList	
				}
				ElseIf isAPercentType
				{ 
					// This is a SINGLE value native type. %String, %Integer, %Boolean, whatever.
					Set pColumnList=pColumnList_$ListBuild($ListBuild(propertyObj.Name,propertyObj.Type,"",0, propertyObj.Name))
				}
				Else
				{
					// This is a SINGLE reference to an object on the star table. So it will be exposed as an Integer
					//Set pColumnList=pColumnList_$ListBuild($ListBuild(propertyObj.Name,"%Integer","",0, propertyObj.Name))
					
					If pFullColumnExpansion 
					{
						Set tSC = ..GenerateColumnListForFact(.tempColumnList,factPackageName,propertyObj.Name)
					
						If $$$ISERR(tSC){
							$$$ThrowException("GenerateColumnListException", "Error Generating Column List for: "_propertyObj.Name)
						}
						
						Set pColumnList = pColumnList_tempColumnList
						
					}Else{
						Set pColumnList=pColumnList_$ListBuild($ListBuild(propertyObj.Name,"%Integer","",0, propertyObj.Name))	
					}
				}
			}			
		}
		Catch(oException) 
		{
			Set tSC = oException.AsStatus()
		}
	
		Quit tSC
}

ClassMethod GenerateColumnListForFact(Output tempColumnList As %List, pFactTablePackage As %String, pPropName As %String) As %Status
{
		Set tSC = $$$OK
		
		Try 
		{
			Set tempColumnList = ""
			
			Kill arModelInput
			Do ..ExplodeFactListProperty(pFactTablePackage, pPropName, .arModelInput, .tStarTableName)
			Set tExplodedPropName=""
			For
			{
				Set tExplodedPropName=$Order(arModelInput(tExplodedPropName))
				Quit:tExplodedPropName=""
				
				// This is a one-hot-encoding of ALL THE ELEMENTS on the star table. 
				// So all these properties must be created as %Integer
				Set tempColumnList=tempColumnList_$ListBuild($ListBuild(tExplodedPropName,"%Integer",0,1, pPropName,tStarTableName))
			}
		}
		Catch(oException) 
		{
			Set tSC = oException.AsStatus()
		}
	
		Quit tSC
}

ClassMethod ExplodeFactListProperty(pFactTablePackage As %String, pPropName As %String, Output pModelDataInput As %String, Output pStarTableName As %String) [ Private ]
{
		#Dim pModel As %DeepSee.PMML.Model.AbstractModel
		#Dim pValues As %DeepSee.Datatype.list
		#Dim oRS As %SQL.StatementResult
		
		Set pStarTableName = ..GetStarTableTableName(pFactTablePackage,pPropName)
		
		Set oRS = ##class(%SQL.Statement).%ExecDirect(, "select ID from "_pStarTableName)
		$$$ThrowSQLExceptionIfResultError(oRS, "ExplodeFactListPropertyException")
		
		While oRS.%Next(.tSC)
		{
			Set starId = oRS.%GetData(1)
			Do ..PopulateModelInputWithStarData(pFactTablePackage, pPropName, starId, .pModelDataInput)
		}
		$$$ThrowStatusExceptionIfError(tSC, "ExplodeFactListPropertyException")
}

ClassMethod GetStarTableClassName(pFactTablePackage As %String, pPropName As %String) As %String
{
		
		Set starClassName = pFactTablePackage_".Star"_$Extract(pPropName,3,*)
		
		Set bool = ##class(%Dictionary.ClassDefinition).%ExistsId(starClassName)
		
		If 'bool 
		{
			Set starClassName = pFactTablePackage_"."_pPropName
		}
		
		
		Quit starClassName
}

ClassMethod GetStarTableTableName(pFactTablePackage As %String, pPropName As %String) As %String
{
	
		Set starTableName = $Translate(pFactTablePackage,".","_")_".Star"_$Extract(pPropName,3,*)
		
		Set bool = $SYSTEM.SQL.TableExists(starTableName)
		
		If 'bool
		{
			Set starTableName = $Translate(pFactTablePackage,".","_")_"."_pPropName
		}
		
		Quit starTableName
}

ClassMethod PopulateModelInputWithStarData(pFactTablePackage As %String, pPropName As %String, pPropValue As %String, Output pModelDataInput As %String) [ Private ]
{
		If (pPropValue="") || (pPropValue="<null>") Quit
		
		Set starClassName = ..GetStarTableClassName(pFactTablePackage,pPropName)
		
		Set factPropObj = $classmethod(starClassName, "%OpenId", pPropValue,, .tSC)
		$$$ThrowStatusExceptionIfError(tSC, "StartObjectNotFoundException")
		
		Set suffix = $PROPERTY(factPropObj, pPropName)
		
		If suffix '="<null>"{
			Set modelPropName = ..NormalizeColumnName(pPropName_"_"_suffix)
			Set pModelDataInput(modelPropName)=1
		}
}

ClassMethod PopulateModelInputWithStarListData(pFactTablePackage As %String, pPropName As %String, pPropListValue As %DeepSee.Datatype.list, Output pModelDataInput As %String) [ Private ]
{
		#Dim pModel As %DeepSee.PMML.Model.AbstractModel
		#Dim pValues As %DeepSee.Datatype.list
				
		For listIndex=1:1:$LENGTH(pPropListValue, ",")
		{
			Set starId = $Piece(pPropListValue,",", listIndex)
			
			Do ..PopulateModelInputWithStarData(pFactTablePackage, pPropName, starId, .pModelDataInput)
			
		}
}

ClassMethod NormalizeColumnName(columnName As %String) As %String
{
		set updatedColName = ""
		set matcher=##class(%Regex.Matcher).%New("\W",columnName)
		//Turn anything not alphanumeric into underscores
		Set updatedColName = matcher.ReplaceAll("_")
		
		Quit updatedColName
}

}
