/*
    CREATED BY      CREATED DATE    DESCRIPTION
    -----------------------------------------------------------------------
    puneet aggarwal   02/04/2012    Trigger to create task based on custom setting 
                                    PMO_TaskAssignment

*/ 

trigger PMO_Task on IDC_Task__c (after update) {
    
    try {
        
        // List of IDC Task which have been completed
        List<IDC_Task__c> OA = new List<IDC_Task__c>();
        
        for(IDC_Task__c idc:Trigger.new){
            
            if(Trigger.oldMap.get(IDC.Id).Status__c != Trigger.newMap.get(idc.Id).Status__c && idc.Status__c == 'Completed') {
                
                // Adding records in the list
                OA.add(idc);
            }
        }
    
        if(!OA.isempty()) {
            
            // Calling method which creates new IDC Tasks
            PMO_Task_Assignment.PMO_Task_Assignment(OA);
        }
    }
    catch(Exception ex) {
        
        ex.setMessage('Some error occured while creating a new Task');
    }               
                            
                
        

}