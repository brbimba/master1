/*
    CREATED BY      CREATED DATE    DESCRIPTION
    -----------------------------------------------------------------------
    puneet aggarwal   02/04/2012    Helper class to create task based on custom setting 
                                    PMO_TaskAssignment

*/  
public  class PMO_Task_Assignment {
    
    public static void PMO_Task_Assignment(List<IDC_Task__c> lstTask){
        
        // Map to get task order vs. custom setting value               
        Map<String, PMO_TaskAssignment__c> alltasks = PMO_TaskAssignment__c.getAll();  
        
        // Map to get values to create defect               
        Map<String, PMO_CreateDefect__c> alldefects = PMO_CreateDefect__c.getAll();
        
        // Map to get task type vs completed IDC Task
        Map<String, IDC_Task__c> tasks = new Map<String, IDC_Task__c>();
        
        // List of new Task Types
        List<string> lstnewtasktype = new List<string>();
        
        // List of completed IDC Tasks
        List<IDC_Task__c> lstexistingTask = new List<IDC_Task__c>();
         
        // List of new IDC Tasks
        List<IDC_Task__c> lstnewTask = new List<IDC_Task__c>();
        
        // Creating a Map of Task type and completed IDC Task
        for(IDC_Task__c t: lstTask) {           
            
            if(alltasks.containskey(t.Task_Type__c)){
                
                tasks.put(PMO_TaskAssignment__c.getInstance(t.task_type__c).Task__c,t);
            }               
        }
        
        // Looping through all values in custom setting and creating list of new task types as well as completed tasks in same order
        for(PMO_TaskAssignment__c task : alltasks.values()) {
            
            if(tasks.containskey(PMO_TaskAssignment__c.getInstance(task.name).Preceding_Task__c)){
                                
                lstnewtasktype.add(PMO_TaskAssignment__c.getInstance(task.name).Task__c);
                lstexistingTask.add(tasks.get(PMO_TaskAssignment__c.getInstance(task.name).Preceding_Task__c));
            }
        }
        
        List<Defect__c> lstdefect = new List<Defect__c>(); 
        // Creating new tasks and adding them in the list
        for(integer counter=0;counter<lstnewtasktype.size();counter++){
            
            if(lstnewtasktype[counter] != system.label.PMO_Task_CodeReview || (lstnewtasktype[counter] == system.label.PMO_Task_CodeReview && lstexistingTask[counter].Build_Task_Type__c == system.label.PMO_TaskType_Customization)){
                IDC_Task__c IDCTask = new IDC_Task__c();
                //if(!TL.isEmpty())
                if(PMO_TaskAssignment__c.getInstance(lstnewtasktype[counter]).Owner_Queue__c != null){
        
                    IDCTask.OwnerId = PMO_TaskAssignment__c.getInstance(lstnewtasktype[counter]).Owner_Queue__c;
                }
                
                IDCTask.Assigned_Date__c = system.today();
                IDCTask.Task_Type__c = lstnewtasktype[counter];                      
                IDCTask.IDC_Task__c = lstexistingTask[counter].id;
                IDCTask.Track__c = lstexistingTask[counter].Track__c;
                IDCTask.Request__c = lstexistingTask[counter].Request__c;
                
                if((lstexistingTask[counter].Defect_Found__c == true && (lstexistingTask[counter].Task_Type__c.contains(system.label.PMO_Task_Review) || lstexistingTask[counter].Task_Type__c.contains(system.label.PMO_Task_Execution))) || (!lstexistingTask[counter].Task_Type__c.contains(system.label.PMO_Task_Review) && !lstexistingTask[counter].Task_Type__c.contains(system.label.PMO_Task_Execution)))
                lstnewtask.add(IDCTask); 
                
            }
            try{
                if( lstexistingTask[counter].Defect_Found__c == true && lstexistingTask[counter].Defect_Description__c != null
                           && PMO_CreateDefect__c.getInstance(lstexistingTask[counter].Task_Type__c).Create_Defect__c == true){
                   Defect__c dfct = new Defect__c();
                   Dfct.subject__c = system.label.PMO_Defect_Subject + lstexistingTask[counter].Request_Name__c;
                   Dfct.status__c = system.label.PMO_Defect_Open;
                   Dfct.Defect_Detected__c = lstexistingTask[counter].Task_Type__c;
                   Dfct.Detailed_Description__c = lstexistingTask[counter].Defect_Description__c;
                   if(lstexistingTask[counter].Request__c != null)
                        Dfct.Related_Request__c = lstexistingTask[counter].Request__c;
                   lstdefect.add(Dfct);
                  
                }  
           }
           catch(exception ex){
                 ex.setMessage(system.label.PMO_Task_Error);
           }
        }
        
        // insert the list 
        if(!lstnewtask.isEmpty()) {
            try {
                insert lstnewtask;
                insert lstdefect;
            }
            catch(DMLException ex){
                ex.setMessage(system.label.PMO_Task_Error);
            }
        }
        
   }
  
}