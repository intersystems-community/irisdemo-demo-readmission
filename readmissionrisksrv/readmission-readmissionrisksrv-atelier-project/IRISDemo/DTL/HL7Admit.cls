Class IRISDemo.DTL.HL7Admit Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, RRLACESrv.BO.AdmitRequest) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='RRLACESrv.BO.AdmitRequest' sourceDocType='2.5:ADT_A01' create='new' language='objectscript' >
<assign value='source.{PID:PatientID.IDNumber}' property='target.PatientID' action='set' />
<assign value='source.{PV1:VisitNumber.IDNumber}' property='target.EncounterNumber' action='set' />
<assign value='$zdateh($extract(source.{PV1:AdmitDateTime.Time},1,8),8)' property='target.StartDate' action='set' />
<assign value='source.{PV1:AdmissionType}' property='target.EncounterType' action='set' />
<assign value='$ztimeh($extract(source.{PV1:AdmitDateTime.Time},9,10)_":"_$extract(source.{PV1:AdmitDateTime.Time},11,12)_":"_$extract(source.{PV1:AdmitDateTime.Time},13,14))' property='target.StartTime' action='set' />
<assign value='"DEMO"' property='target.AdmissionSource' action='set' />
<assign value='source.{PV1:AdmitSource}' property='target.AdmissionSource' action='set' />
</transform>
}

}
