<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IDC_Task_Send_Email_on_Task_Assignment</fullName>
        <description>IDC Task - Send Email on Task Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/IDC_Task_Send_Email_on_Task_Assignment</template>
    </alerts>
    <rules>
        <fullName>IDC Task - Send Email on Task Assignment</fullName>
        <actions>
            <name>IDC_Task_Send_Email_on_Task_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
