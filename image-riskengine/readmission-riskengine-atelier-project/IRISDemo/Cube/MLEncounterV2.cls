/// 
Class IRISDemo.Cube.MLEncounterV2 Extends %DeepSee.CubeDefinition [ DependsOn = IRISDemo.DataLake.Encounter, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="MLEncounterV2" displayName="MLEncounterV2" disabled="false" abstract="false" sourceClass="IRISDemo.DataLake.Encounter" buildRestriction="EncounterType=&apos;I&apos;" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="AdmitReason" disabled="false" hasAll="false" allCaption="All AdmitReason" allDisplayName="AdmitReason" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AdmitReason" disabled="false" sourceProperty="AdmitReason" factName="AdmitReason" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Gender" disabled="false" hasAll="false" allCaption="All Gender" allDisplayName="Gender" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Gender" disabled="false" sourceProperty="Patient.Gender" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Discharge Location" displayName="Discharge Location" disabled="false" hasAll="false" allCaption="All Discharge Location" allDisplayName="Discharge Location" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Discharge Location" displayName="Discharge Location" disabled="false" sourceProperty="DischargeLocation" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Encounter Type" disabled="false" hasAll="false" allCaption="All Encounter Type" allDisplayName="Encounter Type" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Encounter Type" displayName="Encounter Type" disabled="false" sourceProperty="EncounterType" list="false" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Age Discharged" disabled="false" hasAll="false" allCaption="All Age Discharged" allDisplayName="Age Discharged" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Age Group" displayName="Age Group" disabled="false" sourceExpression="%expression.AgeDischarged" factName="DxAgeGroup" list="false" rangeExpression="[0,11):0-10;[11,21):11-20;[21,31):21-30;[31,41):31-40;[41,51):41-50;[51,61):51-60;[61,71):61-70;[71,):71+;" useDisplayValue="false" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Comorbidities" disabled="false" hasAll="false" allCaption="All New_dataDimension1" allDisplayName="New_dataDimension1" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Comorbidities" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).Comorbidities(%source.%ID,0,%source.EncounterStart, %source.EncounterEnd,%source.Patient.%ID)" factName="Com" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Current Comorbidities" disabled="false" hasAll="false" allCaption="All Current Comorbidities" allDisplayName="Current Comorbidities" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Current Comorbidities" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).Comorbidities(%source.%ID,1,%source.EncounterStart, %source.EncounterEnd,%source.Patient.%ID)" factName="CurCom" list="true" listDelimiter="," useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <measure name="LOS" disabled="false" sourceProperty="LOS" factName="LOS" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="Smoker" displayName="Smoker" disabled="false" sourceExpression="$piece(%expression.Smoking,&quot;,&quot;,3)" factName="MxSmoker" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="Ex Smoker" displayName="Ex Smoker" disabled="false" sourceExpression="$piece(%expression.Smoking,&quot;,&quot;,2)" factName="MxExSmoker" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="Never Smoked" displayName="Never Smoked" disabled="false" sourceExpression="$piece(%expression.Smoking,&quot;,&quot;,1)" factName="MxNeverSmoked" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="Age Discharged" displayName="Age Discharged" disabled="false" sourceExpression="%expression.AgeDischarged" factName="MxAgeDischarged" aggregate="AVG" type="integer" hidden="false" searchable="false" formatString="##">
  </measure>
  <measure name="Patient ID" displayName="Patient ID" disabled="false" sourceProperty="Patient.FHIRReferenceCode" factName="MxPatientID" aggregate="COUNT" type="string" hidden="false" searchable="false">
  </measure>
  <measure name="NumAdmitsOneMonth" displayName="NumAdmitsOneMonth" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).NumAdmitsInXMonths(%source.%ID, 1,%source.EncounterStart, %source.Patient.%ID)" factName="MxNumAdmitsOneMonth" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="NumAdmitsThreeMonth" displayName="NumAdmitsThreeMonth" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).NumAdmitsInXMonths(%source.%ID, 3,%source.EncounterStart, %source.Patient.%ID)" factName="MxNumAdmitsThreeMonth" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="NumAdmitsSixMonth" displayName="NumAdmitsSixMonth" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).NumAdmitsInXMonths(%source.%ID, 6,%source.EncounterStart, %source.Patient.%ID)" factName="MxNumAdmitsSixMonth" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="NumAdmitsTwelveMonth" displayName="NumAdmitsTwelveMonth" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).NumAdmitsInXMonths(%source.%ID, 12,%source.EncounterStart, %source.Patient.%ID)" factName="MxNumAdmitsTwelveMonth" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="NumDiagOneMonth" displayName="NumDiagOneMonth" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).NumDiagnosisInXMonths(%source.%ID, 1,%source.EncounterStart, %source.Patient.%ID)" factName="MxNumDiagOneMonth" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="NumDiagTwelveMonth" displayName="NumDiagTwelveMonth" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).NumDiagnosisInXMonths(%source.%ID, 12,%source.EncounterStart, %source.Patient.%ID)" factName="MxNumDiagTwelveMonth" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="WillReAdmit" displayName="WillReAdmit" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).WillReAdmit(%source.EncounterEnd, %source.Patient.%ID)" factName="MxWillReAdmit" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="Alcohol" displayName="Alcohol" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).Alcohol(%source.Patient)" factName="MxAlcohol" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="Drugs" displayName="Drugs" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).Drugs(%source.Patient)" factName="MxDrugs" aggregate="SUM" hidden="false" searchable="false">
  </measure>
  <measure name="EncounterStartYear" disabled="false" sourceExpression="$system.SQL.YEAR(%source.EncounterStart)" factName="MxEncounterStartYear" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="EncounterEndYear" disabled="false" sourceExpression="$system.SQL.YEAR(%source.EncounterEnd)" factName="MxEncounterEndYear" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="StartDateDoW" disabled="false" sourceExpression="$system.SQL.DAYOFWEEK(%source.EncounterStart)" factName="MxStartDateDayOfWeek" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="StartDateDoM" disabled="false" sourceExpression="$system.SQL.DAYOFMONTH(%source.EncounterStart)" factName="MxStartDateDayOfMonth" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="StartDateMonth" disabled="false" sourceExpression="$system.SQL.MONTH(%source.EncounterStart)" factName="MxStartDateMonth" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="EndDateDoW" disabled="false" sourceExpression="$system.SQL.DAYOFWEEK(%source.EncounterEnd)" factName="MxEndDateDayOfWeek" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="EndDateDoM" disabled="false" sourceExpression="$system.SQL.DAYOFMONTH(%source.EncounterEnd)" factName="MxEndDateDayOfMonth" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <measure name="EndDateMonth" disabled="false" sourceExpression="$system.SQL.MONTH(%source.EncounterEnd)" factName="MxEndDateMonth" aggregate="AVG" type="integer" hidden="false" searchable="false">
  </measure>
  <expression name="Smoking" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).Smoking(%source.Patient)">
  </expression>
  <expression name="AgeDischarged" disabled="false" sourceExpression="##class(IRISDemo.Cube.MLEncounterV2Utils).GetAgeAtDischarge(%source.EncounterStart, %source.EncounterEnd, %source.Patient.DateOfBirth)">
  </expression>
  <listing name="Listing" disabled="false" listingType="table" fieldList="ID,AdmitReason,DischargeLocation,EncounterNumber,EncounterType,LOS">
  </listing>
</cube>
}

Parameter DOMAIN;

}
