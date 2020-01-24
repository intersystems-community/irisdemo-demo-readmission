/// 
Class IRISDemo.BP.HL7AppTrigger.Process Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='IRISDemo.BS.AppTrigger.TriggerEventReq' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='HL7Message' type='EnsLib.HL7.Message' instantiate='0' />
</context>
<sequence xend='200' yend='450' >
<code name='Transform Obj to HL7' xpos='200' ypos='250' >
	<![CDATA[
		Try
		{
			Set tEventType = $Piece(request.TriggerEvent,"_",2)
			Set tEvent = $Translate(request.TriggerEvent,"_")
	
			Set obj = ""
			Set tTransformationClass=""
			
			If ",A01,A03,A05,A08,"[(","_tEventType_",")
			{
				Set obj = ##class(IRISDemo.Data.Encounter).%OpenId(request.ObjectId)
				
				Set tTransformationClass="IRISDemo.DTL.HL7AppTrigger."_tEvent
				
			}
			
			If tTransformationClass'=""
			{
				Set status = $classmethod(tTransformationClass, "Transform", obj, .hl7)
				Quit:$$$ISERR(status)
				
				Set context.HL7Message=hl7
			}
		}
		Catch (oException)
		{
			Set status=oException.AsStatus()
		}
		
	]]>
</code>
<call name='Send HL7 to Readmission Srv' target='Readmission Risk HL7 Service' async='1' xpos='200' ypos='350' >
<request type='EnsLib.HL7.Message' >
<assign property="callrequest" value="context.HL7Message" action="set" />
</request>
<response type='Ens.Response' />
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
