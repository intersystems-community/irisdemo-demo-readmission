Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

ClassMethod DisableJournalSystemWide() As %Status
{
		Set tSC = $System.Status.OK()
		
		Try
		{
            Do $System.OBJ.SetTransactionMode(0, .tSC)
            Quit:$System.Status.IsError(tSC)
            
			Set tNS=$Namespace
			Set $Namespace="%SYS"
			
			Set err=0
			
			Do INT^JRNSTOP(.err,0)
			
			If err'=0 
			{
				Set tSC = $System.Status.Error(5001,"Error when trying to disable journal system wide. INT^JRNSTOP returned err: "_err)
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		Set $Namespace=tNS
		
		Quit tSC
}

ClassMethod LoadTransactionalData(pNamespace As %String) As %Status
{
		Set tSC = $$$OK
		Try
		{
			Set tSC = ..DisableJournalSystemWide()
			Quit:$System.Status.IsError(tSC)
			
			ZN pNamespace
			
			Do ##class(IRISDemo.DataLake.Utils).LoadDemoData()
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		ZN "%SYS"
		
		Quit tSC
}

ClassMethod ExportPatients(pNamespace As %String) As %Status
{
	Set tSC = $$$OK
	Try
	{
		ZN pNamespace
		
		Do ##class(IRISDemo.DataLake.Utils).ExportPatients()
	}
	Catch (oException)
	{
		Set tSC = oException.AsStatus()
	}
	
	ZN "%SYS"
	
	Quit tSC
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
	<Namespace Name="${Namespace}" Create="no">
		<IfDef Var="SourceDir">
            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
            <Import File="${SourceDir}" Recurse="true"/>
        </IfDef>
	</Namespace>
	
	<Log Text="Loading transactional data..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="LoadTransactionalData" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>

	<Log Text="Exporting data for HIS Database..." Level="0"/>
	<Invoke Class="IRISConfig.Installer" Method="ExportPatients" CheckStatus="true">
		<Arg name="pNamespace" Value="${Namespace}"/>
	</Invoke>


</Manifest>
}

}
