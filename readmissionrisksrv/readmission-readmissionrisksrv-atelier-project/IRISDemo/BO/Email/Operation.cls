Class IRISDemo.BO.Email.Operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter INVOCATION = "Queue";

/// The IP address of the SMTP server to send mail to. (Note: the timeouts for connecting and sending mail can be more than 10 minutes).
Property SMTPServer As %String(MAXLEN = 100);

/// The IP Port on the SMTP server to send mail to. If left blank, the adapter will use port 25 for plain text and port 465 for SSL/TLS.
Property SMTPPort As %Integer;

/// This is the ID name of the set of credentials values to be used to access the server
Property Credentials As %String;

Parameter SETTINGS = "SMTPServer,SMTPPort,Credentials";

Method Send(pRequest As IRISDemo.BO.Email.EmailMessage, Output pResponse As Ens.Response) As %Status
{
	set tSC = $$$OK
	Try
	{
		set objMessage = ##class(%Net.MailMessage).%New()
		set objMessage.From = pRequest.From
		set objMessage.Subject = pRequest.Subject
		set objMessage.TextData = pRequest.MessageText
		set objMessage.To = pRequest.To
		
		// Nothing to send it to yet so just ignore
		//set tSC = ..Adapter.SendMail(objMessage)
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
	<MapItem MessageType="IRISDemo.BO.Email.EmailMessage"> 
		<Method>Send</Method>
	</MapItem>
</MapItems>
}

}
