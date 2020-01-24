Class IRISDemo.Production Extends IRISDemo.BaseProduction
{

XData ProductionDefinition
{
<Production Name="IRISDemo.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="PMML File Loader" Category="" ClassName="ML.PMML.BS.Loader.File.Service" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">/common_shared/pmml/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.pmml</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/common_shared/imported_pmml/</Setting>
    <Setting Target="Adapter" Name="ConfirmComplete">8</Setting>
  </Item>
  <Item Name="Readmission Model Executor Service" Category="" ClassName="ML.Model.BS.ExecutorService.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Readmission Model Executor" Category="" ClassName="ML.Model.BO.Executor.Operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="ABT">MLEncounter</Setting>
    <Setting Target="PMML" Name="PMML">IRISDemo.ImportedModel.DecisionTreeClassifier</Setting>
    <Setting Target="Host" Name="PMML">IRISDemo.ImportedModel.RandomForest</Setting>
  </Item>
  <Item Name="Java Gateway Service" Category="Datalake" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
