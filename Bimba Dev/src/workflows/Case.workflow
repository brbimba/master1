<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TestFieldUpdate</fullName>
        <field>SLAViolation__c</field>
        <literalValue>No</literalValue>
        <name>TestFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notifywhencaseisclosed</fullName>
        <actions>
            <name>TestFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.ClosedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>tellmeafter14days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Phone</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
