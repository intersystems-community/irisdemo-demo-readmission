Include Ensemble

Class ML.PMML.BS.Loader.Common Extends Ens.BusinessService [ Abstract ]
{

Property FileSpec As %String(MAXLEN = 400) [ InitialExpression = "*.pmml" ];

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As %RegisteredObject) As %Status
{
		Quit ..ProcessFile(pInput)
}

Method ProcessFile(pInput As %Stream.Object) As %Status
{
		Set tSC = $System.Status.OK()
		Try
		{
			// If the class already exists, we will overwrite it.
			// We want to be sure we do this only if the content of the file is valid
			$$$TRACE("Importing file "_pInput.Filename_"...")
			TStart
			
			Set tClassName = $Piece($Piece(pInput.Filename,"/",*),".",1,*-1)
			
			//Set tSC = ..LoadAndCompilePMML(pInput, tClassName)

			Set tSC = ##class(%DeepSee.PMML.Utils).CreateFromFile(pInput.Filename, tClassName)
			
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		If $System.Status.IsError(tSC)
		{
			TRollback
			$$$TRACE("File "_pInput.Filename_" could not be imported.")
		}
		Else
		{
			TCommit
			$$$TRACE("File "_pInput.Filename_" imported successfully into class '"_tClassName_"'.")
		}
		
		Quit tSC
}

/// DEPRECATED in favor of ##class(%DeepSee.PMML.Utils).CreateFromFile()
Method LoadAndCompilePMML(pInput As %Stream.Object, pClassName) As %Status
{
		#Dim oXData As %Dictionary.XDataDefinition
		#Dim oClassDef As %Dictionary.ClassDefinition
		
		Set tSC = $System.Status.OK()
		Try
		{
			Do ##class(%Dictionary.ClassDefinition).%DeleteId(pClassName)
			
			Set oClassDef = ##class(%Dictionary.ClassDefinition).%New()
			Set oClassDef.Name = pClassName
			Set oClassDef.Super = "%DeepSee.PMML.Definition"
			
			Set oXData = ##class(%Dictionary.XDataDefinition).%New()
			Do oClassDef.XDatas.Insert(oXData)
			
			Set oXData.Name="PMML"
			Set oXData.XMLNamespace="http://www.intersystems.com/deepsee/pmml"
			
			Set tSC = oXData.Data.CopyFrom(pInput)
			Quit:$System.Status.IsError(tSC)
			
			Set tSC = oClassDef.%Save()
			Quit:$System.Status.IsError(tSC)
			
			Set tSC = $System.OBJ.Compile(pClassName)
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Quit tSC
}

}
