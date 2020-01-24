/// 
Class IRISDemo.Cube.LACEV2 Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.DataLake.Encounter, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="LACEV2" displayName="LACEV2" disabled="false" abstract="false" sourceClass="IRISDemo.DataLake.Encounter" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Readmission Risk" displayName="Readmission Risk" disabled="false" hasAll="false" allCaption="All Readmission Risk" allDisplayName="Readmission Risk" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Readmission Risk" displayName="Readmission Risk" disabled="false" sourceExpression="%expression.LACE" factName="DxReadmissionRisk" list="false" rangeExpression="[0,4]:Low;[5,9]:Moderate;[10,]:High;" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Is Emergency" disabled="false" hasAll="false" allCaption="All Is Emergency" allDisplayName="Is Emergency" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Is Emergency" displayName="Is Emergency" disabled="false" sourceExpression="$s(%expression.AScore=3:&quot;True&quot;,1:&quot;False&quot;)" factName="DxIsEmergency" list="false" useDisplayValue="false" sort="desc" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Is Emergency2" disabled="false" hasAll="false" allCaption="All Is Emergency2" allDisplayName="Is Emergency2" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Is Emergency2" displayName="Is Emergency2" disabled="false" sourceExpression="$s(%expression.AScore=3:&quot;Emergency&quot;,1:&quot;Not Emergency&quot;)" factName="DxIsEmergency2" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Discharge Date" disabled="false" hasAll="true" allCaption="All Discharge Date" allDisplayName="Discharge Date" sourceProperty="EncounterEnd" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year Discharged" displayName="Year Discharged" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Month Discharged" displayName="Month Discharged" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
      <level name="Day Discharged" displayName="Day Discharged" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Discharge Location" displayName="Discharge Location" disabled="false" hasAll="true" allCaption="All Discharge Location" allDisplayName="Discharge Location" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Discharge Location" displayName="Discharge Location" disabled="false" sourceProperty="DischargeLocation" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Encounter Type" displayName="Encounter Type" disabled="false" hasAll="true" allCaption="All Encounter Type" allDisplayName="Encounter Type" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Encounter Type" displayName="Encounter Type" disabled="false" sourceProperty="EncounterType" list="false" rangeExpression="E:Emergency;I:Inpatient;O:Outpatient;" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Age Discharged" displayName="Age Discharged" disabled="false" hasAll="true" allCaption="All Age Discharged" allDisplayName="Age Discharged" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Age Group" displayName="Age Group" disabled="false" sourceExpression="%expression.AgeDischarged" list="false" rangeExpression="[0,10]:0-10;[11,20]:11-20;[21,30]:21-30;[31,40]:31-40;[41,50]:41-50;[51,60]:51-60;[61,70]:61-70;[71,]:71+;" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
      <level name="Age Discharged" displayName="Age Discharged" disabled="false" sourceExpression="%expression.AgeDischarged" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="L Score" displayName="L Score" disabled="false" sourceExpression="%expression.LScore" factName="MxLScore" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##.##">
  </measure>
  <measure name="A Score" displayName="A Score" disabled="false" sourceExpression="%expression.AScore" factName="MxAScore" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##.##">
  </measure>
  <measure name="C Score" displayName="C Score" disabled="false" sourceExpression="%expression.CScore" factName="MxCScore" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##.##">
  </measure>
  <measure name="E Score" displayName="E Score" disabled="false" sourceExpression="%expression.EScore" factName="MxEScore" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##.##">
  </measure>
  <measure name="LACE Score" displayName="LACE Score" disabled="false" sourceExpression="%expression.LACE" factName="MxLACE" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="Length Of Stay" displayName="Length Of Stay" disabled="false" sourceProperty="LOS" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##">
  </measure>
  <measure name="Emergency Count" displayName="Emergency Count" disabled="false" sourceExpression="$s(%expression.AScore=3:1,1:0)" factName="MxEmergencyCount" aggregate="SUM" type="integer" hidden="false" searchable="false" formatString="##">
  </measure>
  <measure name="Patient ID" displayName="Patient ID" disabled="false" sourceProperty="Patient.FHIRReferenceCode" factName="MxPatientID" aggregate="COUNT" type="string" hidden="false" searchable="false">
  </measure>
  <measure name="Age Discharged" displayName="Age Discharged" disabled="false" sourceExpression="%expression.AgeDischarged" factName="MxAgeDischarged" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##">
  </measure>
  <measure name="MxWillReadmit" displayName="MxWillReadmit" disabled="false" sourceExpression="%expression.WillReadmit" factName="MxWillReadmit" aggregate="AVG" type="number" hidden="false" searchable="false">
  </measure>
  <expression name="LScore" disabled="false" sourceExpression="##class(IRISDemo.Cube.LACEV2Utils).GetLScore(%source.%ID)">
  </expression>
  <expression name="AScore" disabled="false" sourceExpression="##class(IRISDemo.Cube.LACEV2Utils).GetAScore(%source.%ID)">
  </expression>
  <expression name="CScore" disabled="false" sourceExpression="##class(IRISDemo.Cube.LACEV2Utils).GetCScore(%source.%ID)">
  </expression>
  <expression name="EScore" disabled="false" sourceExpression="##class(IRISDemo.Cube.LACEV2Utils).GetEScore(%source.%ID)">
  </expression>
  <expression name="LACE" disabled="false" sourceExpression="%expression.LScore+%expression.AScore+%expression.CScore+%expression.EScore">
  </expression>
  <expression name="AgeDischarged" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).GetAgeAtDischarge(%source.%ID, %source.EncounterEnd, %source.Patient.DateOfBirth)">
  </expression>
  <expression name="WillReadmit" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).WillReAdmit(%source.EncounterEnd, %source.Patient.%ID)">
  </expression>
</cube>
}

Parameter DOMAIN;

}
