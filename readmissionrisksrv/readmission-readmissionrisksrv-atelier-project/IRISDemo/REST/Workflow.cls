Include DEMOMACROS

Class IRISDemo.REST.Workflow Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "UTF-8";

Parameter UseSession As Integer = 1;

Parameter HandleCorsRequest = 1;

Parameter CONVERTINPUTSTREAM = 1;

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/tasks" Method="GET" Call="getTasksNew"/>
<Route Url="/tasks/clear" Method="GET" Call="clearTasks"/>
<Route Url="/tasks/forUser/:username" Method="GET" Call="getTasksForUser"/>
<Route Url="/tasks/:count" Method="GET" Call="getTasksNew"/>
<Route Url="/tasks/:count/:maxId" Method="GET" Call="getTasksNew"/>

<Route Url="/task/assign" Method="POST" Call="assignTask"/>
<Route Url="/task/unassign" Method="POST" Call="unassignTask"/>
<Route Url="/task/complete" Method="POST" Call="completeTask"/>
<Route Url="/task/discard" Method="POST" Call="discardTask"/>
<Route Url="/task/:id" Method="GET" Call="getTaskNew"/>
<Route Url="/task/:id" Method="POST" Call="postTask"/>


<Route Url="/test" Method="GET" Call="test"/>
<Route Url="/logout" Method="GET" Call="logout"/>
</Routes>
}

/// End session
ClassMethod logout() As %Status
{
	#dim %session As %CSP.Session
	set sc = %session.Logout(1)
	set %session.EndSession = 1
	quit sc
}

/// Test method
ClassMethod test() As %Status
{
    //write "{""Status"": ""OK""}"
    
    // Configuring response type to JSON
	Set %response.ContentType=..#CONTENTTYPEJSON
    Set response = {}
	Set response.requestResult={}
	
	//
	// Everything worked out OK!
	//
	Set response.requestResult.status="OK"
	// Whatever the response is, let's send it
	Write response.%ToJSON()	
	Quit $$$OK
}

ClassMethod getTaskNew(id) As %Status
{
	#Dim oTaskResponse As EnsLib.Workflow.TaskResponse
	
    // Configuring response type to JSON
	Set %response.ContentType=..#CONTENTTYPEJSON
    Set response = {}
	Set response.requestResult={}
	
	Try{
		
		Set %response.ContentType=..#CONTENTTYPEJSON
		
		// Creating the response object
		Set response = {}
		Set response.task = {}
		Set response.requestResult={}	
		
		Set tSQL="SELECT IsNew AS isNew, Task->ID AS id, Task->%Action AS action, Task->%Message As message, Task->%Priority AS priority,"_
				 "Task->%Status AS status,Task->%Subject As subject, Task->TaskStatus_AssignedTo As assignedTo,"_
				 "Task->TaskStatus_IsComplete AS isComplete,Task->TaskStatus_TimeCompleted As timeCompleted,"_
				 "Task->TaskStatus_TimeCreated AS timeCreated, Task->TaskStatus_Request AS associatedRequestID "_
				 "FROM EnsLib_Workflow.Worklist "_
				 "WHERE Task->ID=?"
				 
		Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL, id)
		$$$ThrowSQLExceptionIfResultError(oRS, "TaskNotFoundException")
		
		Set oResultMetadata = oRS.%GetMetadata()
		
		While oRS.%Next()
		{
			
			For iCol=1:1:oResultMetadata.columnCount
			{
				Set oColumn = oResultMetadata.columns.GetAt(iCol)
				
				If oColumn.clientType=2 //DATE 
				{
					Set $property(response.task, oColumn.colName)=$ZDate(oRS.%GetData(iCol), 3)
				}
				Else
				{
					Set $property(response.task, oColumn.colName)=oRS.%GetData(iCol)
				}
			}
			
		}
		
		//
		// Everything worked out OK!
		//
		Set response.requestResult.status="OK"
		
	}Catch(oException){
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

ClassMethod assignTask() As %Status
{
	#Dim response As %Library.DynamicObject
	#Dim oTaskResponse As EnsLib.Workflow.TaskResponse
	
    // Configuring response type to JSON
	Set %response.ContentType=..#CONTENTTYPEJSON
    Set response = {}
	Set response.requestResult={}
	
	Try{
		
		// Transform the JSON string from the POST into a dynamic object
		Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
		Set taskID = request.ID
		Set userName = ""
		
		If request.userName '= ""
		{
			Set userName = request.userName
		}else{
			Set userName = $username
		}
		
		Set oTaskResponse = ##class(EnsLib.Workflow.TaskResponse).%OpenId(taskID)
		If '$IsObject(oTaskResponse) $$$ThrowException("TaskNotFoundException", "taskID: "_taskID)
		
		Set status = ##class(EnsLib.Workflow.Engine).AssignTask(oTaskResponse, userName)
		
		If $$$ISERR(status)
		{
			$$$ThrowException("TaskAssignmentException", "Error Assigning task to user: "_userName)
		}
		
		//
		// Everything worked out OK!
		//
		Set response.requestResult.status="OK"
		
		
	}Catch(oException){
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

ClassMethod unassignTask() As %Status
{
    #Dim oTaskResponse As EnsLib.Workflow.TaskResponse
    
    //ClassMethod %RelinquishOwnershipForTask(pItemId As %String, pUser As %String, ByRef pMsg As %String) As %Status
    
    // Configuring response type to JSON
	Set %response.ContentType=..#CONTENTTYPEJSON
    Set response = {}
	Set response.requestResult={}
	
	Try{
		
		// Transform the JSON string from the POST into a dynamic object
		Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
		Set taskID = request.ID
		If request.userName '= ""
		{
			Set userName = request.userName
		}else{
			Set userName = $username
		}
		
		Set status = ##class(EnsLib.Workflow.Engine).%RelinquishOwnershipForTask(taskID, userName)
		
		If $$$ISERR(status)
		{
			$$$ThrowException("TaskUnassignmentException", "Error Unassigning task to user: "_userName)
		}
		
		//
		// Everything worked out OK!
		//
		Set response.requestResult.status="OK"
		
	}Catch(oException){
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

ClassMethod completeTask() As %Status
{
 
    #Dim oTaskResponse As EnsLib.Workflow.TaskResponse
    
    // Configuring response type to JSON
	Set %response.ContentType=..#CONTENTTYPEJSON
    Set response = {}
	Set response.requestResult={}
	
	Try{
		
		// Transform the JSON string from the POST into a dynamic object
		Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
		Set taskID = request.ID
		Set action = request.action
		
		If action ="" $$$ThrowException("ActionNotProvidedException", "action: "_action)
		
		Set oTaskResponse = ##class(EnsLib.Workflow.TaskResponse).%OpenId(taskID)
		If '$IsObject(oTaskResponse) $$$ThrowException("TaskNotFoundException", "taskID: "_taskID)
		
		Set status = ##class(EnsLib.Workflow.Engine).CompleteTask(oTaskResponse, action)
		
		If $$$ISERR(status)
		{
			$$$ThrowException("TaskCompletionException", "Error Completing task: "_oTaskResponse.%Subject)
		}
		
		//
		// Everything worked out OK!
		//
	Set response.requestResult.status="OK"
			
	}Catch(oException){
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

ClassMethod discardTask() As %Status
{
    #Dim oTaskRequest As EnsLib.Workflow.TaskRequest
    
    // Configuring response type to JSON
	Set %response.ContentType=..#CONTENTTYPEJSON
    Set response = {}
	Set response.requestResult={}
	
	Try{
		
		// Transform the JSON string from the POST into a dynamic object
		Set request = ##class(%DynamicObject).%FromJSON(%request.Content)
		Set taskID = request.ID
		
		Set oTaskRequest = ##class(EnsLib.Workflow.TaskRequest).%OpenId(taskID)
		If '$IsObject(oTaskRequest) $$$ThrowException("TaskNotFoundException", "taskID: "_taskID)
		
		Set status = ##class(EnsLib.Workflow.Engine).%CancelRequest(oTaskRequest)
		
		If $$$ISERR(status)
		{
			$$$ThrowException("TaskCancelationException", "Error Canceling task: "_taskID)
		}
		
		//
		// Everything worked out OK!
		//
		Set response.requestResult.status="OK"
			
	}Catch(oException){
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

/// Supports pagination.
/// count - number of records to get
/// maxId - latest id, leave empty to start from the begining
ClassMethod getTasksNew(count = 100, maxId = "") As %Status
{
	Try
	{
		// Configuring response type to JSON
		Set %response.ContentType=..#CONTENTTYPEJSON
		
		// Creating the response object
		Set response = {}
		Set response.tasks=[]
		Set response.requestResult={}
		
		Set tSQL="SELECT TOP ? %ID As id, isNew As isNew, Task->ID AS taskId, Task->%Action AS action, Task->%Message As message, Task->%Priority AS priority,"_
				 "Task->%Status AS status,Task->%Subject As subject, Task->TaskStatus_AssignedTo As assignedTo,"_
				 "Task->TaskStatus_IsComplete AS isComplete,Task->TaskStatus_TimeCompleted As timeCompleted,"_
				 "Task->TaskStatus_TimeCreated AS timeCreated, Task->TaskStatus_Request AS associatedRequestID "_
				 "FROM EnsLib_Workflow.Worklist "_
				 "WHERE UserName= ? "_
				 "AND (Task->TaskStatus_AssignedTo IS NULL OR Task->TaskStatus_AssignedTo = ?) "_
				 "AND (Task->ID < ? OR ? IS NULL)"_
				 "ORDER BY Task->ID DESC"
				 
		Set response.sql = tSQL
		Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL, count, $username, $username, maxId, maxId)
		
		Set response.tasks = ..processResultSet(oRS)
		
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

/// Supports pagination.
/// count - number of records to get
/// maxId - latest id, leave empty to start from the begining
ClassMethod getTasksForUser(username = "") As %Status
{
	Try
	{
		// Configuring response type to JSON
		Set %response.ContentType=..#CONTENTTYPEJSON
		
		// Creating the response object
		Set response = {}
		Set response.tasks=[]
		Set response.requestResult={}
		
		Set tSQL="SELECT %ID As id, isNew As isNew, Task->ID AS taskId, Task->%Action AS action, Task->%Message As message, Task->%Priority AS priority,"_
				 "Task->%Status AS status,Task->%Subject As subject, Task->TaskStatus_AssignedTo As assignedTo,"_
				 "Task->TaskStatus_IsComplete AS isComplete,Task->TaskStatus_TimeCompleted As timeCompleted,"_
				 "Task->TaskStatus_TimeCreated AS timeCreated, Task->TaskStatus_Request AS associatedRequestID "_
				 "FROM EnsLib_Workflow.Worklist "_
				 "WHERE Task->TaskStatus_AssignedTo = ? "_
				 "ORDER BY Task->ID DESC"
				 
		
		Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL, username)
		
		Set response.tasks = ..processResultSet(oRS)
		
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

ClassMethod clearTasks() As %Status
{
	Try
	{
	
		// Configuring response type to JSON
		Set %response.ContentType=..#CONTENTTYPEJSON
		
		// Creating the response object
		Set response = {}
		Set response.requestResult={}
		
		Set tSQL="DELETE FROM EnsLib_Workflow.Worklist"
				 
		Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL)
		$$$ThrowSQLExceptionIfResultError(oRS, "WorklistDeletionException")
		
		Set tSQL="DELETE FROM EnsLib_Workflow.TaskResponse"
		Set oRS = ##class(%SQL.Statement).%ExecDirect(, tSQL)
		$$$ThrowSQLExceptionIfResultError(oRS, "TaskResponseDeletionException")
		
		Set oResultMetadata = oRS.%GetMetadata()
		
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

ClassMethod processResultSet(oRS) [ Private ]
{
	$$$ThrowSQLExceptionIfResultError(oRS, "ListSQLException")
	
	Set oResultMetadata = oRS.%GetMetadata()
	Set resultArray = []
	
	While oRS.%Next()
	{
		Set obj={}
		
		For iCol=1:1:oResultMetadata.columnCount
		{
			Set oColumn = oResultMetadata.columns.GetAt(iCol)
			
			If oColumn.clientType=2 //DATE 
			{
				Set $property(obj, oColumn.colName)=$ZDate(oRS.%GetData(iCol), 3)
			}
			Else
			{
				Set $property(obj, oColumn.colName)=oRS.%GetData(iCol)
			}
		}
		
		Do resultArray.%Push(obj)
	}
	
	return resultArray
}

/********************************End OF New REST Endpoints******************************/
/// Get tasks. Supports pagination.
/// count - number of records to get
/// maxId - latest id, leave empty to start from the begining
/// set sc = ##class(isc.wf.REST).getTasks()
ClassMethod getTasks(count = 100, maxId = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim isFirst As %Boolean = $$$YES
	&sql(	DECLARE C1 CURSOR FOR
			SELECT TOP :count 
				 %ID,  IsNew,  Task->%Priority, Task->%Subject, Left(Task->%Message,25), TimeCreated,  RoleName
			INTO :id, :isNew, :priority,        :subject,       :message,                :timeCreated, :role
			FROM EnsLib_Workflow.Worklist
			WHERE (UserName = USER) 
				AND ((Task->TaskStatus_AssignedTo IS NULL) OR (Task->TaskStatus_AssignedTo = UserName))
				AND ((%ID < :maxId) OR (:maxId IS NULL))
			ORDER BY %ID DESC)
	&sql(OPEN C1)
	&sql(FETCH C1)
	write:((SQLCODE=0) || (SQLCODE=100)) "["
	while (SQLCODE = 0) {
		if isFirst {
			set isFirst = $$$NO
		} else {
			write ",",!
		}
		write "{""id"":""", id,""",",
		 			"""isNew"":",isNew,",",
		 			"""priority"":",priority,",",
		 			"""subject"":""", $zcvt(subject,"O", "JSON"),""",",
		 			"""message"":""", $zcvt(message,"O", "JSON"),""",",
		 			"""timeCreated"":""", timeCreated,""",",
		 			"""role"":""", role,"""}"
		&sql(FETCH C1)
	}
	if (SQLCODE'=100) {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
	} else {
		write "]"
	}
	&sql(CLOSE C1)
	
	quit sc
}

/// Get one task
/// set sc = ##class(isc.wf.REST).getTask("318||dev")
ClassMethod getTask(id) As %Status
{
	#dim sc As %Status = $$$OK
	&sql(	SELECT %ID,  IsNew,  Task->%Priority, Task->%Subject, Task->%Message, TimeCreated,  RoleName,  Task,  Task->%Actions, Task->%FormFields
			INTO   :id, :isNew, :priority,        :subject,       :message,       :timeCreated, :role,     :task, :actions,       :formFields
			FROM EnsLib_Workflow.Worklist
			WHERE (%ID = :id) AND (UserName = USER))
	if (SQLCODE = 0) {
		write "{""id"":""", id,""",",
		 			"""isNew"":",isNew,",",
		 			"""priority"":",priority,",",
		 			"""subject"":""",$zcvt(subject,"O", "JSON"),""",",
		 			"""message"":""",$zcvt(message,"O", "JSON"),""",",
		 			"""timeCreated"":""",timeCreated,""",",
		 			"""role"":""",role,""",",
		 			"""actions"":""",actions,""",",
		 			"""formFields"":{"
		 
		merge fieldValues = ^Ens.MessageBodyD(task, "%FormValues")	
		set fieldCount = $l(formFields, ",")
		for field = 1:1:fieldCount {
			set fieldName = $p(formFields, ",", field)
			set fieldValue = $g(fieldValues(fieldName))
			write """",$zcvt(fieldName,"O", "JSON"),""":""",$zcvt(fieldValue,"O", "JSON"),""""
			write:(field<fieldCount) ","
		 }
		 write "}}"
	} else {
		set sc = $$$ERROR($$$SQLError, SQLCODE, $g(%msg))
	}
	
	quit sc
}

/// Submit task. Works only in CSP context
/// formFields - pass all field values as json object properties
/// { "action": "action1", "formFields": {}}
ClassMethod postTask(id As %String) As %Status
{
	#dim %request As %CSP.Request
	// For EnsLib.Workflow.FormEngine compatibility
	set %request.Data("$ITEMID",1) = id
	
	set taskResponse = ##class(EnsLib.Workflow.TaskResponse).%OpenId($p(id, "||", 1), , .sc)
	quit:$$$ISERR(sc) sc
	
	set owner = taskResponse.%TaskStatus.AssignedTo
	quit:((owner'=$username) && (owner '="")) $$$ERROR($$$GeneralError, "User " _ $username _ " does not have rights to modify this task")
	
	set %request.Content = {}.%FromJSON(%request.Content)
	set taskResponse.%Action = %request.Content.action
	
	set iterator = %request.Content.formFields.%GetIterator()
	while iterator.%GetNext(.key, .value) {
		set %request.Data(key,1) = value
	}
	
	quit ##class(EnsLib.Workflow.FormEngine).%OnSubmit(taskResponse, .msq)
}

/// Only Workflow users can use this api
ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
	set pContinue = ##class(EnsLib.Workflow.UserDefinition).%ExistsId($username)
    quit $$$OK
}

/// This method takes a status, renders it as json (if requested) and outputs the result
ClassMethod outputStatus(pSC As %Status) As %Status [ Internal ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    try {
        
        #dim tJSON As %ZEN.proxyObject
    
        if ..AcceptsContentType("application/json") {
        
            set %response.ContentType = ..#CONTENTTYPEJSON
        
            #; Convert the exception to a status and render to JSON
            set tSC = ..StatusToProxyObject(pSC, .tJSON)
            set tJSON.stack = ..getDebugInfo()
            if $$$ISERR(tSC) Quit

            #; Write the JSON to the output device
            set tSC = tJSON.%ToJSON(, "aeloqutwc")
            if $$$ISERR(tSC) Quit
            
        } else {
            
            #; Set plain text
            set %response.ContentType = ..#CONTENTTYPETEXT
            
            #; Write out a simple text message
            do ##class(%Exception.StatusException).CreateFromStatus(pSC).OutputToDevice()
        }
        
    } catch ex {
        set tSC = ex.AsStatus()
    }
    quit $$$OK
}

ClassMethod getDebugInfo() As %ZEN.proxyObject
{
	set obj = ##class(%ZEN.proxyObject).%New()
	set obj.stack = ..getStackInfo()
	set obj.objlasterror = $system.Status.GetErrorText($get(%objlasterror))
	set obj.request = %request
	set obj.response = %response
	set obj.user = $username
	
	quit obj
}

ClassMethod getStackInfo() As %ListOfDataTypes
{

	set ex = ##class(%Exception.SystemException).%New()
	do ex.StackAsArray(.stack)
	set list = ##class(%ListOfObjects).%New()
	for i=1:1:stack {
		set obj = ##class(%ZEN.proxyObject).%New()
		set obj.line = stack(i,"PLACE")
		set obj.call =  stack(i)
		set obj.part = $piece($piece(stack(i,"PLACE"), "^", *), " ", 1)
		do list.Insert(obj)
	}
	
	quit list
}

}
