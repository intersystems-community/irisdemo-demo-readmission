Class IRISDemo.DTL.HL7Update Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.HL7.Message, RRLACESrv.BO.UpdateEncounterRequest) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.HL7.Message' targetClass='RRLACESrv.BO.UpdateEncounterRequest' sourceDocType='2.5:ADT_A03' create='new' language='objectscript' >
<assign value='source.{PID:PatientID.IDNumber}' property='target.PatientID' action='set' />
<assign value='source.{PV1:VisitNumber.IDNumber}' property='target.EncounterNumber' action='set' />
<assign value='source.{PV1:AdmissionType}' property='target.EncounterType' action='set' />
<assign value='$extract(source.{PV1:AdmitDateTime.Time},1,4)_"-"_$extract(source.{PV1:AdmitDateTime.Time},5,6)_"-"_$extract(source.{PV1:AdmitDateTime.Time},7,8)_" "_$extract(source.{PV1:AdmitDateTime.Time},9,10)_":"_$extract(source.{PV1:AdmitDateTime.Time},11,12)_":"_$extract(source.{PV1:AdmitDateTime.Time},13,14)' property='target.EncounterStart' action='set' />
<assign value='$extract(source.{PV1:DischargeDateTime.Time},1,4)_"-"_$extract(source.{PV1:DischargeDateTime.Time},5,6)_"-"_$extract(source.{PV1:DischargeDateTime.Time},7,8)_" "_$extract(source.{PV1:DischargeDateTime.Time},9,10)_":"_$extract(source.{PV1:DischargeDateTime.Time},11,12)_":"_$extract(source.{PV1:DischargeDateTime.Time},13,14)' property='target.EncounterEnd' action='set' />
<assign value='source.{PV1:AdmitSource}' property='target.AdmissionSource' action='set' />
<assign value='source.{PV1:DischargedtoLocation}' property='target.DischargeLocation' action='set' />
</transform>
}

}
