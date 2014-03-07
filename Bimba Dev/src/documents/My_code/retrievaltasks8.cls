/*
    *   Webservice  Class   is  used    to  generate    WSDL    which   is  exposed to  Mule    to  RetreiveTaskDetails for a   particular  taskExternalId
    *   @Author Bimba   Ravi
    *   @Date   10/24/2012  
    */
/***    T01:new response    parameters  added   ***/
global  class   WS_RetrieveTaskDetails{ 
    
        /*
        *   Global  Wrapper Class   containing  request parametrs   as  member  variables
        *   @Author Bimba   Ravi
        *   @Date   10/24/2012  
        */  
    
    global  class   TaskDetailsRequest{

    WebService  String  taskId; 
    WebService  String  timezone;
    }

        /*
        *   Global  Wrapper Class   containing  response    parametrs   as  member  variables
        *   @Author Bimba   Ravi
        *   @Date   10/24/2012  
        */
    global  class   TaskDetailsResponse{
    
        WebService  String  taskId; 
        WebService  String  taskType;   
        WebService  String  subject;
        WebService  String  duedate;
        WebService  String  priority;
        WebService  String  category;
        WebService  String  completiondate;
        WebService  String  lastModifiedTimestamp;
        WebService  String  lineOfBusiness;
        WebService  String  formattedRemarks;
        WebService  String  status;
        WebService  String  workItemPresent;
        WebService  String  workItemName_1;
        WebService  String  workItemName_2;
        WebService  String  workflowId_1;
        WebService  String  workflowId_2;               
        WebService  String  associateId;
        WebService  String  assignedTofirstName;
        WebService  String  assignedTomiddleName;
        WebService  String  assignedTolastName;
        WebService  String  assignedTosuffix;
        WebService  String  customerId;
        WebService  String  customerfirstName;
        WebService  String  customermiddleName;
        WebService  String  customerlastName;
        WebService  String  customersuffix;
        /***    T01:    new response    parameters  added   ***/
        Webservice  String  callerType;
        Webservice  String  contactMethod;
        Webservice  String  negativeFeedback;
        Webservice  String  activitySource;
        Webservice  String  lineOfBusiness1;
        Webservice  String  product1;
        Webservice  String  lineOfBusiness2;
        Webservice  String  product2;       

    }
    
    
    /*
    *   @MethodName retrieveTaskDetails
    *   @Description    Fetch   the details of  a   Task    for a   taskexternalId  specified
    *   @Param  TaskDetailsRequest
    *   @return TaskDetailsResponse
    *   @throws exception   -   <Not    Applicable>
    */
    
    Webservice  static  TaskDetailsResponse RetrieveTaskDetail(TaskDetailsRequest   request)    {
        
    
    /*  Method  variables   initialisation  and declaration */
        String  taskId  =   request.taskid  ;
        String  timezone    =   request.timeZone;
        String  formatted_remarks   ;
        
        Task    task    ;
        Account acct    ;
        
                    
        list<Sobject>   records ;
        
        /*
        *   Global  Wrapper Class   containing  request parametrs   as  member  variables
        *   @Author Bimba   Ravi
        *   @Date   10/24/2012  
    */
    
    

        /***    Data    Validations ***/

        //1.    Data    validations checks  
        NullCheckValidations(   taskId, timeZone    )   ;
        
        //2.    isAllowedTimeZone   check   
        isAllowedTimeZone   (   timezone    )   ;
            
    
        //3.    Query   the Account,    Contact,    Tasks   and Users   record
        records =   new list<Sobject>   (   queryRecords    (taskId)    )   ;
            
            if  (!records.isEmpty())    {
                for (Integer    i   =   0;  i   <   records.size(); i++)    {
                    sObject record  =   records[i];
                    
                                         
                    if  (record.getSObjectType()    ==  Account.sObjectType)    {
                            acct    =   (Account)   record  ;
                    }   else    
                    
                    {
                    
                            task    =   (task)  record  ;
                    }
                }       
            }   
        
            
        
        //4.    Assigning   values  to  response    wrapper and return
    
        return  assignValuestoresponsewrapper(  acct,   task,   formattedRemarks    (task.ExternalTaskIdentifier__c,    timezone    ),  timezone    )   ;
    
    }   //  End of  Method  RetrieveTaskDetail
    
    
    
    /*  
        @Method <This   method  calls   all the query   object  methods>
        @param  <   taskId  >
        @return <Sobject[]>
        @throws exception   -   <Exception  will    be  thrown  if  no  records are retrieved   in  the SOQL>   
    */
    public  Static  Sobject[]   queryRecords(   String  taskId  )   {
        
        List<Sobject>   sobjects    =   new List<Sobject>   ()  ;
        
            try {
            
            /*  Calling queryTask   */  
                Task    task    =   Utils_Integration.queryTask(taskId) ;   
                    sobjects.add(task);
                               
                Account acc =   Utils_Integration.queryAccountById(task.whoId);
                    sobjects.add(acc);
                    
            }   catch   (System.Queryexception  e   )   {
                
        //  Throw   custom  exception   if  no  record  found   for mentioned   customerId
                throw   new ApexException   ('No    record  found   for the mentioned   taskId');
            
            }// End of  try catch   block   
            
        
        
        return  sobjects    ;
    }   //  End of  Method  queryRecords
    
    /*  
        @Method <This   method  does    null    value   check>
        @param  <taskId,    timeZone>
        @return <void>
        @throws exception   -   <Exception  will    be  thrown  if  input   value   is  null>   
    */  
    public  Static  void    NullCheckValidations(   String  taskId, String  timeZone    )   {
        
        String  nullCustomException ;
        
        //  taskId  Null    value   check
            nullCustomException =   Utils_Integration.dataNullValidationhelper  (   'TaskId',   taskId  )   ;
            
        //  timeZone    Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'TimeZone', timeZone    )   ;       
                
        
        //  Throw   custom  exception   if  any of  the request parameter   is  null    value
                    
            if  (   nullCustomException.length()    >   0   )   {   
                
                throw   new ApexException   (nullCustomException);
            
            }   
    
    }   //  End of  Method  NullCheckValidations
    
    /*  
        @Method <This   method  validate    the timezone>
        @param  <   timeZone    >
        @return <void>
        @throws exception   -   <Exception  will    be  thrown  if  the timezone    is  not allowed>    
    */
    public  Static  void    isAllowedTimeZone   (   String  timeZone    )   {
    
        /*  Check   if  timezone    entered is  valid   */
        //  We  need    to  handle  below   through custom  settings    -   Sarv
        set<String> timeZones   =   new Set<String>{'EST','EDT','CST','CDT','MST','MDT','PST','PDT'};
        
        /*  Throw   custom  exception   if  any of  the request parameter   has invalid datatype*/  
        if( !timeZones.contains(timeZone)   ){
            
            throw   new ApexException   (   'Field: timezone    is  invalid'    );
        
        }
        
    }
    
    /*  
        @Method <This   method  does    the formatting  for remarks details>
        @param  <   taskExternalId  ,timeZone   >
        @return <String>
        @throws exception   -   <Not    applicable> 
    */
    public  Static  String  formattedRemarks    (   String  taskExternalId, String  timeZone    )   {
    
        /*  Formatted   remarks field   creation    */
    
        /*  Call    queryRemark to  collect all Remarks related to  the taskid  specified   */
        String  formatted_remarks   =   ''; 
        List<Remark__c> remarksfortask  =   new List<Remark__c>();
        Map<Id,String>  remarkdateMap   =   new Map<Id,String>();
        Map<Id,User>    userMap =   new Map<Id,User>(); 
        Set<Id> remarkownerId   =   new Set<Id>();
        
        remarksfortask  =   Utils_Integration.queryRemarkList(taskExternalId);
                        
        /*  For each    remark  record, convert the LastModifiedDate    as  per the timeZone    specified   in  the request */
        
        for(Remark__c   rem :remarksfortask){
            
            /*  Iterate over    each    Remark  record, convert the task    last    modified    date    to  the specified   timezone    and format  */  
            String  lastModifiedTimestamp_str   =   rem.LastModifiedDate.format('yyyy-MM-dd HH:mm:ss    a', timezone);
        
            /*  add the Remark  Id  and Remark  record  into    map */
            remarkdateMap.put(rem.Id,lastModifiedTimestamp_str);
        
            /*  add all remark  owner   Ids into    map */
            remarkownerId.add(rem.OwnerId);
        }
    
        /*  Call    queryUserbyRemarkOwnerId    to  get the required    fields  for formatted   remark  from    User    */
    
        userMap =   Utils_Integration.queryUserbyRemarkOwnerId(    remarkownerId   );
    
    
        /*  For each    remark, concatenate values  of  fields  from    remarkdateMap   and userMap to  create  FormattedFootprint  String  */
    
        for(Remark__c   rem :remarksfortask){
        
            Blob blobremark = blob.valueof(rem.Remark__c);
            if ( blobremark.size() < 21333) { 
            formatted_remarks   +=  rem.Remark__c+  ''  +   remarkdateMap.get(rem.Id)   +   ''
            
            +   timeZone    +   ''  +   userMap.get(rem.OwnerId).firstname  +   ''  +   userMap.get(rem.OwnerId).lastname+  ''  +   
                    
            userMap.get(rem.OwnerId).alias+''+  ''  +   userMap.get(rem.OwnerId).department;
        }
        }
        
        return  formatted_remarks   ;
    }
    
    /*  
        @Method <This   method  Assign  the values  to  response    wrapper class>
        @param  <   acct,   cont,   task,   usr,    formatted_remarks,  timezone>
        @return <TaskDetailsResponse>
        @throws exception   -   <Not    applicable> 
    */
    public  Static  TaskDetailsResponse assignValuestoresponsewrapper(  Account acct,  Task    task,   String  formatted_remarks,  String  timezone    )   {
        
        TaskDetailsResponse response    =   new TaskDetailsResponse();
        
        Datetime    activitydate    =   Date.Valueof(task.ActivityDate);
        Datetime    completiondate  =   Date.Valueof(task.CompletionDate__c);
        
        //  Convert timezone    of  datetime    field   lastmodifieddate    
        String  lastmodifiedtimestamp   =   task.LastModifiedDate.format('yyyy-MM-dd    HH:mm:ss.sss',  timezone);
            
        response.customerId =   acct.ClientIdentifier__c;
        response.taskId =   task.ExternalTaskIdentifier__c+'';
        response.subject    =   task.Subject+'';
        response.dueDate    =   activitydate.month()+'/'+activitydate.day()+'/'+activitydate.year();
        response.status =   task.status+'';
        response.priority   =   task.Priority+'';
        response.category   =   task.Category__c+'';
        if(completiondate   !=  NULL){
            response.completiondate =   completiondate.month()+'/'+completiondate   .day()+'/'+completiondate.year()    ;   
        }
        else{   
            response.completiondate =   NULL;
        }
        response.lastModifiedTimestamp  =   lastmodifiedtimestamp.subString(0,10)+'T'+lastmodifiedtimestamp.subString(11,23)+'Z';
        
        
        /*  If  task.WorkItem1__c   field   on  task    is  not null,   populate    task.workItemPresent    as  TRUE    else    FALSE   */
        if(task.WorkItem1__c    !=  null    )   {
            response.workItemPresent    =   'True';
        }
        else    {
            response.workItemPresent    =   'False';    
        }       
        response.workItemName_1 =   (task.WorkItem1__c!=    NULL?task.WorkItem1__c:null);
        response.workItemName_2 =   (task.WorkItem2__c!=    NULL?task.WorkItem2__c:null);
        response.customerfirstName  =   acct.firstname;
        response.customerlastName   =   acct.lastname   ;
        response.customermiddleName =   acct.middleName__c  ;
        response.customersuffix =   acct.NameSuffix__pc;
        response.associateId    =   task.ownerid;
        response.assignedTofirstName    =   task.Owner.firstname;
        response.assignedTolastName =   task.Owner.lastname;
        response.formattedRemarks   =   formatted_remarks;  
        /***    T01 ***/
        response.lineOfBusiness1    =   task.BusinessLine1__c;  
        response.lineOfBusiness2    =   task.BusinessLine2__c;
        response.callerType =   task.CallType;
        response.contactMethod  =   task.Type;
        response.negativeFeedback   =   task.ComplaintType__c;
        response.activitySource =   task.ActivitySource__c;
        response.product1   =   task.Product1__c;
        response.product2   =   task.Product2__c;
        response.tasktype   =   task.RecordType.Name ;
        
        return  response    ;
        
    }   //  End of  Method  assignValuestoresponsewrapper
        
    
}