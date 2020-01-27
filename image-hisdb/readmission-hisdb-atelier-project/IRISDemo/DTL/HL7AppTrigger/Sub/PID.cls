Class IRISDemo.DTL.HL7AppTrigger.Sub.PID Extends Ens.DataTransformDTL [ DependsOn = (IRISDemo.Data.Patient, EnsLib.HL7.Segment) ]
{

Parameter IGNOREMISSINGSOURCE = 0;

Parameter REPORTERRORS = 0;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='IRISDemo.Data.Patient' targetClass='EnsLib.HL7.Segment' targetDocType='2.5:PID' create='new' language='objectscript' >
<assign value='source.MRN' property='target.{PatientID}' action='set' />
<assign value='source.LastName' property='target.{PatientName().FamilyName}' action='set' />
<assign value='source.FirstName' property='target.{PatientName().GivenName}' action='set' />
<assign value='source.Gender' property='target.{AdministrativeSex}' action='set' />
<assign value='$ZDate(source.DoB,8)' property='target.{DateTimeofBirth}' action='set' />
</transform>
}

}
