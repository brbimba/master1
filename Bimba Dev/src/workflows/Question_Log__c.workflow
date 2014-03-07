<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Question_Log_Send_Email_on_Query_Assignment_to_Reportee</fullName>
        <description>Question Log - Send Email on Query Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitter__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Question_Log_Send_Email_on_Query_Assignment</template>
    </alerts>
    <rules>
        <fullName>Question Log - Send Email on Query Assignment</fullName>
        <actions>
            <name>Question_Log_Send_Email_on_Query_Assignment_to_Reportee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status__c) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
