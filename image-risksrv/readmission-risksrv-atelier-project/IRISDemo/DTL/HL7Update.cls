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
<assign value='..ConvertDateTime(source.{PV1:AdmitDateTime.Time},"%q")' property='target.EncounterStart' action='set' />
<assign value='..ConvertDateTime(source.{PV1:DischargeDateTime.Time},"%q")' property='target.EncounterEnd' action='set' />
<assign value='source.{PV1:AdmitSource}' property='target.AdmissionSource' action='set' />
<if condition='source.{PV1:DischargedtoLocation}&apos;=""' >
<true>
<assign value='source.{PV1:DischargedtoLocation}' property='target.DischargeLocation' action='set' />
</true>
<false>
<assign value='"H"' property='target.DischargeLocation' action='set' />
</false>
</if>
<assign value='source.{MSH:MessageType.TriggerEvent}' property='target.UpdateMessageType' action='set' />
</transform>
}

}
