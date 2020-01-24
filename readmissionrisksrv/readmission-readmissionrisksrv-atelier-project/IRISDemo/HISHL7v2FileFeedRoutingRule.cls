/// 
Class IRISDemo.HISHL7v2FileFeedRoutingRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.HL7.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.HL7.MsgRouter.RoutingEngine" production="IRISDemo.Production">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<constraint name="source" value="HIS HL7v2 TCP Feed"></constraint>
<constraint name="docCategory" value="2.5"></constraint>
<constraint name="docName" value="ADT_A01,ADT_A08"></constraint>
<when condition="1">
<send transform="IRISDemo.DTL.HL7Update" target="Readmission Risk Process"></send>
<return></return>
</when>
</rule>
<rule name="" disabled="false">
<constraint name="source" value="HIS HL7v2 TCP Feed"></constraint>
<constraint name="docCategory" value="2.5"></constraint>
<constraint name="docName" value="ADT_A03"></constraint>
<when condition="1">
<send transform="IRISDemo.DTL.HL7Update" target="Readmission Risk Process"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
