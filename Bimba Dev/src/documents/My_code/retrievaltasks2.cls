/*   
      Author          : Eric Montelibano
      Date Created    : 12/10/2012   
      Description     : This is a Web Service class that will be consumed by external system
                        to invoke the creation of a Task and/or Update Task. 
*/

global class WS_CreateUpdateTask{

      /*   Global  Wrapper Class   containing  request parametrs   as  member  variables  
       *   @Author Eric     
       *   @Date   01/09/2013      
      */   
         
        global class createUpdateTaskResponseSFDC{
        webservice string taskid;
        webservice boolean success;
        webservice string message; 
    }
    
    /*   Global  Wrapper Class   containing  request parametrs   as  member  variables  
     *   @Author Eric     
     *   @Date   01/09/2013      
    */
      
        global class createTaskReq {
        
        webservice string activityIdentifier;
        webservice string taskType;
        webservice string category;
        webservice string priority;
        webservice string status;
        webservice date taskDeadline;
        webservice Date dueDate;
        webservice string subject;
        webservice string remark;
        webservice string applicationCode;
        webservice string callerType;
        webservice string contactMethod;
        webservice string negativeFeedback;
        webservice string activitySource;
        webservice integer cccPriority;        
        webservice string lineOfBusiness1;
        webservice string product1;
        webservice string lineOfBusiness2;
        webservice string product2;
                
        //associateId
        webservice string associateId; 
               
        //relatedto
        webservice string relatedToId;
        webservice string relatedToType;
                
        //Customer
        webservice string customerType;
        webservice string customerId;
        
        //Customers
        webservice string prefix;
        webservice string firstName;
        webservice string preferredFirst;
        webservice string middleName;
        webservice string lastName;
        webservice string suffix;
        webservice string phoneType;
        webservice string phone;
        webservice string phoneExtension;
        webservice string emailAddress; 
               
        //reminder
        webservice boolean reminderRequired;
        webservice DateTime reminderDate;        
        webservice string workItemName;
        webservice string workflowID;
        webservice string parameters;        
        webservice string workItemName1;
        webservice string workflowID1;
        webservice string parameters1;
        webservice string workItemName2;
        webservice string workflowID2;
        webservice string parameters2;
                    
        //update task
        webservice string taskId;
        webservice date completionDate;
                
    }
    
    /*   Global  Wrapper Class   containing  request parametrs   as  member  variables  
     *   @Author Eric     
     *   @Date   01/09/2013      
    */
      
    
    global class updateTask{
        webservice string remark;
        webservice string associateId;
        webservice string relatedToId;
        webservice string relatedToType;
        webservice string activityIdentifier;
        
        webservice string taskId;
        webservice Date dueDate;
        webservice string priority;
        webservice string category;
        webservice date completionDate;
        webservice date taskDeadline;
        webservice string applicationCode;
        webservice string status;
        webservice string taskType; // we are not changing recordtype
        webservice string subject;
        webservice string callerType;
        webservice string contactMethod;
        webservice string negativeFeedback;
        webservice string activitySource;
        webservice string lineOfBusiness_1;
        webservice string product_1;
        webservice string lineOfBusiness_2;
        webservice string product_2;
        webservice string workItemName_1;
        webservice string workflowID_1;
        webservice string parameters_1;
        webservice string workItemName_2;
        webservice string workflowID_2;
        webservice string parameters_2;
        
    }
   
     /*          
         @Method <This   method  returns the WhatId(ID of the object record to whiich task is related to) for the given parameters >  
         @param  < String RelatedToType, String RelatedToId> 
         @return String  ReltoId> 
         @throws exception   -   <Not    Applicable> 
     */      

    public static String getReltoId (String RelatedToType, String RelatedToId) {
         
        /*
        Object_Api_Name__c O = [select id, ObjectApi__c, Object_Externa_Id__c from Object_Api_Name__c where ObjectExternalId__c =: relateToType];
        String relatedToObject = o.ObjectApi__c;
        String relatedToExternalField = o.Object_External_Id__c;
        */
        String relatedToObject = '%' +'ObjecValue' + '%' ;
        String relatedToExternalField = '%' +'ObjectExternalFieldValue' + '%' ;
        String relId = '%' +RelatedToId + '%';
        
        String relToId = 'select id from ' +relatedToObject +' where ' +relatedToExternalField +' =\'' +relId +'\'';
        Database.query(relToId);
                          
        return ReltoId;
    }
    
     /*          
         @Method <This   method  returns the OwnerId for a particular associateId >  
         @param  < String associateId > 
         @return String  OwnerId > 
         @throws exception   -   <Not Applicable> 
     */      


    public static String getOwnerId (String associateId) {
        User u = [select id from User where User.AssociateIdentifier__c =: associateId];
        String OwnerId = u.id;
        return OwnerId;
    }
    
    /*
    @ Method will createTask into SFDC>
    */
    webservice static createUpdateTaskResponseSFDC createTask (createTaskReq req){
        Task tsk = new Task();
        
        tsk.ActivityIdentifier__c = req.activityIdentifier;
        //webservice string taskType;
        tsk.Category__c = req.category;
        tsk.Priority = req.priority;
        tsk.Status = req.status;
        tsk.TaskDeadline__c = req.taskDeadline;
        tsk.ActivityDate = req.dueDate;
        tsk.Subject = req.subject;
        tsk.Description = req.remark;
        tsk.ApplicationCode__c = req.applicationCode;
        tsk.CallerType__c = req.callerType;
        //tsk.ContactMethod__c = req.contactMethod;
        tsk.ComplaintType__c = req.negativeFeedback;
        tsk.ActivitySource__c = req.activitySource;
        tsk.CCCPriority__c = req.cccPriority;
        
        tsk.BusinessLine1__c = req.lineOfBusiness1;
        tsk.Product1__c = req.product1;
        tsk.BusinessLine2__c = req.lineOfBusiness2;
        tsk.Product2__c = req.product2;
        
        tsk.WorkItem1__c = req.workItemName;
        tsk.WorkflowID1__c = req.workflowID;
        tsk.Parameters1__c = req.parameters;
        
        if(req.reminderRequired = true) {
            tsk.ReminderDateTime = req.ReminderDate;
        }
        
        tsk.RecordTypeId = Utils_Integration.getTaskRecordTypeIdbyName(req.taskType);
        
        //get Customer Size if 0 create skeletal dummy and insert whoId with skeletal dummy, else whoId = clientId.
        Integer intCustSize = Utils_Integration.queryAccount(req.CustomerId).size();
        if(intCustSize == 0){
            Account acc = new Account();
            
            acc.FirstName = req.firstName;
            acc.PreferredFirstName__c = req.preferredFirst;
            acc.MiddleName__c =  req.middleName;
            acc.LastName = req.lastName;
            acc.NameSuffix__pc = req.suffix;
            
            if(req.phoneType == ''){
                acc.Phone = req.phone;
            }
            acc.WorkPhoneExtension__c = req.phoneExtension;     
            acc.PersonEmail = req.emailAddress;
            insert acc;
            Contact c = [select id from Contact where AccountId =: acc.id];
            tsk.WhoId = c.id;
        } else {
            
        tsk.whoId = Utils_Integration.getCustId(req.customerId, req.customerType);
        
        }
        
        tsk.WhatId = getReltoId(req.relatedToType, req.relatedToId);
        tsk.OwnerId = getOwnerId(req.associateId);
        
        insert tsk;
        
        createUpdateTaskResponseSFDC resp = new createUpdateTaskResponseSFDC();
        resp.success = true;
        resp.taskid = tsk.Id;
        
        return resp;
    }
    
    
       
    /*
    @ Method will update Task into SFDC>
    */
    webservice static createUpdateTaskResponseSFDC updTask (Task tsk, updateTask upd ){
        
        //tsk.ActivityIdentifier__c = upd.activityIdentifier;
        Task tsk1 = [Select WorkflowID2__c, WorkflowID1__c, WorkItem2__c, WorkItem1__c, WhoId, WhatId, Type, TaskDeadline__c, 
        SystemModstamp, Subject, Status, Section__c, Report__c, ReminderDateTime, RecurrenceType, 
        RecurrenceTimeZoneSidKey, RecurrenceStartDateOnly, RecurrenceMonthOfYear, RecurrenceInterval, 
        RecurrenceInstance, RecurrenceEndDateOnly, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, 
        RecurrenceActivityId, RecordTypeId, Product2__c, Product1__c, Priority, Parameters2__c, 
        Parameters1__c, OwnerId, LastModifiedDate, /*LastModifiedCounter__c,*/ LastModifiedById, IsReminderSet,
        IsRecurrence, IsDeleted, IsClosed, IsArchived, Id, GeographicLocation__c, 
        ExternalTaskIdentifier__c, Description, CreatedDate, CreatedById, CreateApplication__c, 
        Category__c, CompletionDate__c, ComplaintType__c, CallerType__c, CallType, 
        CallObject, CallDurationInSeconds, CallDisposition, CCCPriority__c, BusinessLine2__c, 
        BusinessLine1__c, BOD__c, AppliedSMP__c, ApplicationCode__c, AgentOffice__c, ActivitySource__c, 
        ActivityIdentifier__c, ActivityDate, AccountId From Task where ActivityIdentifier__c =: upd.activityIdentifier];
    
        tsk1.OwnerId = upd.associateId;
    
        
        if(upd.dueDate != null){
             tsk1.ActivityDate = tsk1.ActivityDate;
        } else {
            tsk1.ActivityDate = date.valueOf(upd.dueDate);
        }           
                
        if (upd.Priority == ''){
            tsk1.Priority = tsk1.Priority ;
        } else if(upd.Priority.trim() == ''){
            tsk1.Priority = '';
        } else {
            tsk1.priority = upd.Priority;
        }
        
        if (upd.Category == ''){
            tsk1.Category__c = tsk1.Category__c;
        } else if (upd.category.trim() == ''){
            tsk1.Category__c = '';
        } else{
            tsk1.Category__c = upd.Category;
        }                                      
        
        if(upd.CompletionDate != null){
            tsk1.CompletionDate__c = tsk1.CompletionDate__c;
        } else{
            tsk1.CompletionDate__c = upd.CompletionDate;
        }
        
        if(upd.taskDeadline != null){
            tsk1.TaskDeadline__c = tsk1.TaskDeadline__c;
        } else{
            tsk1.TaskDeadline__c = upd.TaskDeadline;
        }
        
        if(upd.ApplicationCode == ''){
            tsk1.ApplicationCode__c = tsk1.ApplicationCode__c;          
        } else if(upd.applicationCode.trim() == ''){
            tsk1.ApplicationCode__c = '';
        } else{
            tsk1.ApplicationCode__c = upd.ApplicationCode;
        }
        
        if(upd.Status == ''){
            tsk1.Status = tsk1.Status;
        } else{
            tsk1.Status = upd.Status;
        }
        
        if(upd.Subject == ''){
            tsk1.Subject = tsk1.Subject;
        } else if(upd.Subject.trim() == ''){
            tsk1.Subject = '' ;         
        } else{
            tsk1.Subject = upd.Subject;
        }
        
        if(upd.CallerType == ''){
            tsk1.CallerType__c = tsk1.CallerType__c;
        } else if(upd.CallerType.trim() == ''){
            tsk1.CallerType__c = '';
        } else{
            tsk1.CallerType__c = upd.CallerType;
        }
        
        /*if(upd.ContactMethod == ''){
            tsk1.ContactMethod__c = tsk1.ContactMethod__c;
        } else if(upd.ContactMethod.trim() == ''){
            tsk1.ContactMethod__c = '';
        } else{
            tsk1.ContactMethod__c = upd.ContactMethod;
        }*/
        
        if(upd.NegativeFeedback == ''){
            tsk1.ComplaintType__c = tsk1.ComplaintType__c;
        } else if (upd.negativeFeedback.trim() == ''){
            tsk1.ComplaintType__c = '';
        } else{
            tsk1.ComplaintType__c = upd.NegativeFeedback;
        }
        
        if(upd.ActivitySource == ''){
            tsk1.ActivitySource__c = tsk1.ActivitySource__c;
        } else if(upd.ActivitySource.trim() == ''){
            tsk1.ActivitySource__c = '';    
        } else{
            tsk1.ActivitySource__c = upd.ActivitySource;
        }
                    
        if (upd.lineofBusiness_1 == ''){
            tsk1.BusinessLine1__c = tsk1.BusinessLine1__c;         
        } else if(upd.lineofBusiness_1.trim() == ''){
            tsk1.BusinessLine1__c = null;
        } else{           
            tsk1.BusinessLine1__c = upd.lineOfBusiness_1;         
        }         
        
        if (upd.Product_1 == ''){            
            tsk1.Product1__c = tsk1.Product1__c;         
        } else if (upd.Product_1.trim() == ''){
            tsk1.Product1__c = '';
        } else{            
            tsk1.Product1__c = upd.Product_1;         
        }                  
        
        if (upd.lineofBusiness_2 == ''){            
            tsk1.BusinessLine2__c = tsk1.BusinessLine2__c ;         
        } else if (upd.lineOfBusiness_2.trim() == ''){
            tsk1.BusinessLine2__c = '';
        } else{            
            tsk1.BusinessLine2__c = upd.lineofBusiness_2;         
        }              
        
        if (upd.product_2 == ''){            
            tsk1.Product2__c = tsk1.Product2__c;         
        } else if (upd.product_2.trim() == ''){
            tsk1.Product2__c = '';
        } else{            
            tsk1.Product2__c = upd.product_2;         
        }                   
        
        if (upd.workItemName_1 == ''){            
            tsk1.WorkItem1__c = tsk1.WorkItem1__c;         
        } else if (upd.workItemName_1.trim() == '' ){
            tsk1.WorkItem1__c = '';
        } else{            
            tsk1.WorkItem1__c = upd.workItemName_1;         
        }                  
        
        if (upd.workflowID_1 == ''){            
            tsk1.WorkflowID1__c = tsk1.WorkflowID1__c;         
        } else if (upd.workflowID_1.trim() == ''){
            tsk1.WorkflowID1__c = '';
        } else{            
            tsk1.WorkflowID1__c = upd.workflowID_1;         
        }                  
        
        if (upd.parameters_1 == ''){            
            tsk1.Parameters1__c = tsk1.Parameters1__c;         
        } else if (upd.parameters_1.trim() == '') {
            tsk1.Parameters1__c = '';
        } else{            
            tsk1.Parameters1__c = upd.parameters_1;         
        }                  
        
        //upsert tsk task.fields.ActivityIdentifier__c; 
        update tsk1;
        
        if(upd.Remark != null ){
            Remark__c rem = new Remark__c();
            rem.Remark__c = upd.Remark;
            rem.TaskIdentifier__c = tsk.Id;
            rem.ExternalIdentifier__c = tsk.ExternalTaskIdentifier__c;
            insert rem;
            update tsk1;
            
        }
        
        createUpdateTaskResponseSFDC resp = new createUpdateTaskResponseSFDC();
        resp.taskid = tsk.ExternalTaskIdentifier__c;
        return resp;
    }
}