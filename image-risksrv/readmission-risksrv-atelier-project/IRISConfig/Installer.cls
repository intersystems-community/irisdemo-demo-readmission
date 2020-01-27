Include %occInclude

Class IRISConfig.Installer Extends IRISConfig.InstallerBase
{

/// This method will create an Interoperability credential meant to be used on Interoperability Productions.
/// It will use the standard SuperUser/sys password for demos.
ClassMethod CreateCredentials(pNamespace As %String) As %Status
{
		Set tSC = $$$OK
		Try
		{
			Set tNS=$Namespace
			ZN pNamespace
			
			Set tSC = ##class(Ens.Config.Credentials).SetCredential("riskengine", "SuperUser", "sys", 1)
			Quit:$System.Status.IsError(tSC)		
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		ZN tNS
		
		Quit tSC
}

/// You can customize this to run code during docker build
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
		<Log Text="Configuring credentials..." Level="0"/>
		<Invoke Class="IRISConfig.Installer" Method="CreateCredentials" CheckStatus="true">
			<Arg name="pNamespace" Value="${Namespace}"/>
		</Invoke>
		
		<Namespace Name="${Namespace}" Create="no">
			<IfDef Var="SourceDir">
	            <Log Text="SourceDir defined - offline install from ${SourceDir}" Level="0"/>
	            <Import File="${SourceDir}" Recurse="true"/>
	        </IfDef>
	        
		</Namespace>
		
		<Log Text="Creating Credentials..." Level="0"/>
		<Invoke Class="IRISConfig.Installer" Method="CreateCredentials" CheckStatus="true">
			<Arg name="pNamespace" Value="${Namespace}"/>
		</Invoke>
		
		<Var Name="Password" Value="jsmith123!"/>
		<User Username="jsmith" Fullname="John Smith" Enabled="true" Roles="AppRole" PasswordVar="Password"/>
		
		<Invoke Class="IRISConfig.Installer" Method="AddWFRole" CheckStatus="true">
			<Arg name="pNamespace" Value="${Namespace}"/>
			<Arg name="pRoleName" Value="Care Team"/>
		</Invoke>
		
		<Invoke Class="IRISConfig.Installer" Method="AddWFUser" CheckStatus="true">
			<Arg name="pNamespace" Value="${Namespace}"/>
			<Arg name="pUserName" Value="jsmith"/>
			<Arg name="pFullName" Value="John Smith"/>
			<Arg name="pRoleName" Value="Care Team"/>
		</Invoke>
	
		<Invoke Class="IRISConfig.Installer" Method="AddWFUser" CheckStatus="true">
			<Arg name="pNamespace" Value="${Namespace}"/>
			<Arg name="pUserName" Value="SuperUser"/>
			<Arg name="pFullName" Value="Jane Smith"/>
			<Arg name="pRoleName" Value="Care Team"/>
		</Invoke>

	</Manifest>
}

}
