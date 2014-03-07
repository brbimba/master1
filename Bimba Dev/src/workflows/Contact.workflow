<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>wsdlfile</fullName>
        <apiVersion>29.0</apiVersion>
        <endpointUrl>https://ap1.salesforce.com/services/Soap/class/MyWebService</endpointUrl>
        <fields>Id</fields>
        <fields>LastName</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>bimba.dev@accenture.com</integrationUser>
        <name>wsdlfile</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>onCreate</fullName>
        <actions>
            <name>wsdlfile</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.AccountName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
