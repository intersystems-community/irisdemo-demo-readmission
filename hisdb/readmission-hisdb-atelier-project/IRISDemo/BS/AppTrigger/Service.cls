Include DEMOMACROS

Class IRISDemo.BS.AppTrigger.Service extends Ens.BusinessService {

	Parameter ADAPTER = "Ens.InboundAdapter";
	
	Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
	{
		Set tSC = $$$OK
		
		// This can't be an infinite loop. We want to push as many events on this CallInterval (100ms) 
		// cycle as possible. But we want to return control to the adapter in order to allow for the
		// production to be stopped. This method will be called at every 100ms. We are looping to a 
		// maximum of 100. If we do happen to have 100 events on the global, we will be able to send 
		// about 1 msg/milisec. Depending on the machine we can do a lot more better than that and you should
		// increase the loop to a higher value to take advantage of this 100ms window as much as possible.
		Set next=""
		For i=1:1:100
		{
			Set next = $Order(^IRISDemo.BS.AppTrigger.Service(next))
			Quit:next=""
			
			Set data = ^IRISDemo.BS.AppTrigger.Service(next)
			
			Set oTriggerEventReq = ##class(IRISDemo.BS.AppTrigger.TriggerEventReq).%New()
			Set oTriggerEventReq.TriggerEvent=$ListGet(data,1)
			Set oTriggerEventReq.ObjectId=$ListGet(data,2)
			
			// We want this to be asynchronous. Because there is nothing really we can do  here if
			// an event can't be transformed into an HL7 message. Alerts will be sent by the Business Process,
			// workflows started, and so on... But nothing to do with this business service.
			Set tSC = ..SendRequestAsync("Application HL7 Trigger Process", oTriggerEventReq)
			Quit:$$$ISERR(tSC)
			
			Kill ^IRISDemo.BS.AppTrigger.Service(next)
			
			Do ..ForceSessionId()
		}
		
		Quit tSC
	}

	/// This is a good pattern because there is not much margin for errors that would
	/// otherwise interfere with the transactional processing
	ClassMethod TriggerEvent(pTriggerEvent As %String, pObjectId As %String)
	{
		Set next=$Increment(^IRISDemo.BS.AppTrigger.Service)
		
		Set ^IRISDemo.BS.AppTrigger.Service(next)=$ListBuild(pTriggerEvent, pObjectId)
	}
}