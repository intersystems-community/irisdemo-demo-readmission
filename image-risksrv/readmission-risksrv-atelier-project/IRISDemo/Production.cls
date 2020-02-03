Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="HIS HL7v2 File Feed Router" Category="" ClassName="EnsLib.HL7.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">IRISDemo.HISHL7v2FileFeedRoutingRule</Setting>
  </Item>
  <Item Name="LACE SOAP Operation" Category="" ClassName="RRLACESrv.BO.LACESoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">riskengine</Setting>
    <Setting Target="Adapter" Name="Credentials">riskengine</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://riskengine:52773/csp/appint/IRISDemo.SOAP.LACE.Service.cls</Setting>
  </Item>
  <Item Name="HIS HL7v2 TCP Feed" Category="" ClassName="EnsLib.HL7.Service.TCPService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Port">9999</Setting>
    <Setting Target="Host" Name="MessageSchemaCategory">2.5</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HIS HL7v2 File Feed Router</Setting>
    <Setting Target="Adapter" Name="ReadTimeout">15</Setting>
  </Item>
  <Item Name="Risk Alert Email Operation" Category="" ClassName="IRISDemo.BO.Email.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Care Team" Category="" ClassName="EnsLib.Workflow.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Readmission Risk Process" Category="" ClassName="IRISDemo.BP.ReadmissionRisk.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Readmission ML Model Consumer" Category="" ClassName="ML.Model.BO.Executor.ServiceConsumer" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">riskengine</Setting>
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">riskengine</Setting>
    <Setting Target="Adapter" Name="URL">/csp/appint/rest/predict/calculateprediction</Setting>
  </Item>
  <Item Name="HisDB Encounter Update Operation" Category="" ClassName="IRISDemo.BO.EncounterUpdate.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">riskengine</Setting>
    <Setting Target="Adapter" Name="HTTPPort">52773</Setting>
    <Setting Target="Adapter" Name="HTTPServer">hisdb</Setting>
    <Setting Target="Adapter" Name="URL">/csp/appint/rest/encounter/updateprobabilities</Setting>
  </Item>
</Production>
}

}
