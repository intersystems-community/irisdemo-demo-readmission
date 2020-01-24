Class IRISDemo.DTL.HL7AppTrigger.Sub.MSH Extends Ens.DataTransformDTL [ DependsOn = (IRISDemo.Data.Encounter, EnsLib.HL7.Segment) ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='IRISDemo.Data.Encounter' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:MSH' create='existing' language='objectscript' >
<assign value='"IRISDEMOAPP"' property='target.{SendingApplication}' action='set' />
<assign value='"IRISDEMOFACILITY"' property='target.{SendingFacility}' action='set' />
<assign value='"READMISSIONRISKAPP"' property='target.{ReceivingApplication}' action='set' />
<assign value='..CurrentDateTime("%q")' property='target.{DateTimeOfMessage}' action='set' />
<assign value='"2.5"' property='target.{VersionID}' action='set' />
</transform>
}

}
