@isTest
private class Test_PMO_Task_Assignment {

    public testMethod static void testAllTriggers() {
        //Xcel_PMO_Tgr_Requirement_After
        //Xcel_PMO_Tgr_Requirement_UpdateLastTrackedChange
        
        User us = [select id from User limit 1];
         IDC_Task__c idcTask4 = new IDC_Task__c();
        idcTask4.Task_Type__c = 'Design';
        idcTask4.Planned_LOE__c = 1.00;
            idcTask4.OwnerId  = us.id;
        idcTask4.Start_Date__c = System.today();
        idcTask4.status__c = 'Re-assigned';
        insert idcTask4;
        idcTask4.End_Date__c = System.today();
        idcTask4.Actual_LOE__c = 1.00 ;
        idcTask4.Comments__c = 'Dev complete' ;
       
        idcTask4.status__c = 'Completed';
        update idcTask4; 
                
    }
    
    public testMethod static void testUpdateReleaseLOEOnRequestChangeTrigger() {
    
        Release__c rel = new Release__c();
        rel.Name = 'testRelease';
        insert rel;
        
        Request__c req = new Request__c();
        req.Request_Title__c = 'testRequest';
        req.Release__c = rel.Id;
        req.Req__c = 1;
        req.Des__c = 1;
        req.BUT__c = 1;
        req.SIT__c = 1;
        req.UAT__c = 1;
        req.TrnDep__c = 1;
        req.Adapt__c = 1;
        insert req;
        
        req.Req__c = 2;
        req.Des__c = 2;
        req.BUT__c = 2;
        req.SIT__c = 2;
        req.UAT__c = 2;
        req.TrnDep__c = 2;
        req.Adapt__c = 2;
        update req;
        
        delete req;
    
    }
    
}