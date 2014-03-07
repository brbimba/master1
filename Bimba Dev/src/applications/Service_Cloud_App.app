<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <defaultLandingTab>standard-home</defaultLandingTab>
    <description>First Service Cloud App on this org</description>
    <detailPageRefreshMethod>none</detailPageRefreshMethod>
    <isServiceCloudConsole>true</isServiceCloudConsole>
    <label>Service Cloud App</label>
    <listPlacement>
        <height>20</height>
        <location>top</location>
        <units>percent</units>
    </listPlacement>
    <listRefreshMethod>none</listRefreshMethod>
    <tab>standard-Case</tab>
    <tab>standard-Account</tab>
    <tab>standard-Contact</tab>
    <tab>standard-Opportunity</tab>
    <tab>standard-Solution</tab>
    <tab>Activities</tab>
    <tab>Position__c</tab>
    <workspaceMappings>
        <mapping>
            <tab>standard-Solution</tab>
        </mapping>
        <mapping>
            <tab>standard-Opportunity</tab>
        </mapping>
        <mapping>
            <tab>Position__c</tab>
        </mapping>
        <mapping>
            <tab>standard-Case</tab>
        </mapping>
        <mapping>
            <fieldName>AccountId</fieldName>
            <tab>standard-Contact</tab>
        </mapping>
        <mapping>
            <tab>Activities</tab>
        </mapping>
        <mapping>
            <tab>standard-Account</tab>
        </mapping>
    </workspaceMappings>
</CustomApplication>
