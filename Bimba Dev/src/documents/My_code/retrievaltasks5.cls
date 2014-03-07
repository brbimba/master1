/*
    Author          : Anant
    Date Created    : 10/22/2012
    Description     : Webservice Class is used to generate WSDL which is exposed to Mule to Retreive Office Tasks.
*/
global class WS_RetrieveOfficeTasks{

    /*variables*/
    static Integer numOfTasks = 0;        
    static Integer countOfTaskRecord = 0;
    
    
     /*
     *   Global  Wrapper Class   containing  request parametrs   as  member  variables
     *   @Author Anant
     *   @Date   10/23/2012  
     */
    
    global class OfficeTasksRequest{
        webservice String numberOfTasks;
        webservice String countOfTasksRequired;
        webservice String associateId;
        webservice String dueDate;
        webservice String lastModifiedTimestamp;
        webservice String requestPreviousPage;
        webservice String firstTimeRequest;
    }     
    
    /*
    *   Global  Wrapper Class   containing  response parameters   as  member  variables
    *   @Author Anant
    *   @Date   10/23/2012  
    */
    global class OfficeTasksResponse{
        webservice String countOfTasks;
        webservice String moreTasksForNext;
        webservice String moreTasksForPrev;
        webservice String taskId;
        webservice String taskType;
        webservice String subject;
        webservice String category;
        webservice String dueDate;
        webservice String priority;
        webservice String lineOfBusiness;
        webservice String createTimestamp;
        webservice String completionDate;
        webservice String lastModifiedTimestamp;
        webservice String workItemPresent;
        webservice String officeOwner;
        
        webservice String associateId;
        webservice String assignedToFirstName;
        webservice String assignedToLastName;
        webservice String assignedToMiddleName;
        webservice String assignedToSuffix;
    
        webservice String customerId;
        webservice String customerFirstName;
        webservice String customerLastName;
        webservice String customerMiddleName;
        webservice String customerSuffix;
    }   
    /*
     @Method <This method retrieveOfficeTasks is used retrieve the Office Tasks>       
     @param <request - OfficeTasksRequest>  
     @return <OfficeTasksResponse[] - returns the List of Office Tasks>
    */ 
    Webservice static OfficeTasksResponse[] retrieveOfficeTasks(OfficeTasksRequest request){      
    
        /* variables */
        String associateId =  request.associateId ;
        String firstTimeRequest = request.firstTimeRequest ;
        String numberOfTasks = request.numberOfTasks ;
        String requestPreviousPage = request.requestPreviousPage ;
        String lastModifiedTimestamp  = request.lastModifiedTimestamp;  
        String countOfTasksRequired  = request.countOfTasksRequired ; 
        String moreTasksForPrev = '';
        String moreTasksForNext = '';
        String customException = '';
        String timeZone = 'GMT';
        Boolean isNull = false; 
        Date reqDueDate;
        Datetime reqLmts;   
        User user;      
        List<Task> tasks;
        List<OfficeTasksResponse> response;
        Set<Id> userOrGroupIds;
        Set<Id> contactIds = new Set<Id>();
        Set<Id> leadIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        Map<Id, Contact> contactDetails;
        Map<Id, Lead> leadDetails;
        Map<Id, User> userDetails;
        Map<Id, String> recordTypeDetails;
        
     
         /*** Data validations ***/
         
        //1.    Data    validations checks  
                
         NullCheckValidations(   associateId ,firstTimeRequest , numberOfTasks,requestPreviousPage ,lastModifiedTimestamp ,  countOfTasksRequired );
                    
        
        //2.Invalid datatype    checks
            
           // invalidCheckValidations( numberOfTasks,countOfTasksRequired,firstTimeRequest,requestPreviousPage );
          
        
        // verifying for invalid data input
        
        if(!request.numberOfTasks.isNumeric()){
            customException = '\n' + customException + 'Field: numberOfTasks must be Numeric'+'\n';
            isNull = True;
        }
        
        if(request.numberOfTasks.length() > 5 && Integer.valueof(request.numberOfTasks) > 50000){
            customException = '\n' + customException + 'Field: numberOfTasks should not be more then 5 Digit and having Max value of 50000'+'\n';
            isNull = True;
        }
        //Assigning the value to numOfTasks
        numOfTasks = Integer.valueof(request.numberOfTasks);
               
        if( (request.countOfTasksRequired != 'TRUE') && (request.countOfTasksRequired != 'FALSE') ){
            customException = '\n' + customException + 'Field: countOfTasksRequired is Invalid boolean value'+'\n';
            isNull = True;
        }
        
        if((!(request.requestPreviousPage.equalsIgnoreCase('TRUE'))) && (!(request.requestPreviousPage.equalsIgnoreCase('FALSE')))){
            customException = '\n' + customException + 'Field: requestPreviousPage is Invalid boolean value'+'\n';
            isNull = True;
        }
        
        if(!(request.firstTimeRequest.equalsIgnoreCase('TRUE')) && !(request.firstTimeRequest.equalsIgnoreCase('FALSE'))){
            customException = '\n' + customException + 'Field: firstTimeRequest is Invalid boolean value'+'\n';
            isNull = True;
        }// verifying for the requestPreviousPage and firstTimeRequest both should Not be in True condition
        
        if(request.requestPreviousPage.equalsIgnoreCase('TRUE') && request.firstTimeRequest.equalsIgnoreCase('TRUE')){
            customException = '\n' + customException + 'Field: requestPreviousPage and firstTimeRequest both should Not be in True condition'+'\n';
            isNull = True;
        }
        
        //If the IsNull set to true for any validation voilation, throwing the exception   
        if(isNull)
            throw new ApexException (customException);           
           
        /* Invoking method queryUser from Utils_Integration class to get the Details of the user's */
        user = queryUserbyAssociateId(request.associateId);
                
        //Method findAllGroupUserIds() to get the List of all userIds from the Group.       
        userOrGroupIds = new Set<Id>();
        userOrGroupIds = findAllGroupUserIds(user.Id);
        
        if(!userOrGroupIds.isEmpty()){
            tasks = new List<Task>();
            /*** First Time ***/
            if(request.firstTimeRequest == 'True' && request.requestPreviousPage == 'False')
                tasks = queryFirstTime(userOrGroupIds);
            
            /*** Previous Page ***/
            if(request.firstTimeRequest == 'False' && request.requestPreviousPage == 'True')
            {
                reqDueDate = Date.valueof(request.dueDate);
                reqLmts = Datetime.parse(request.lastModifiedTimestamp);        
                tasks = queryPreviousPage(userOrGroupIds, reqDueDate, reqLmts);
            }           
            
            /*** Next Page ***/
            if(request.firstTimeRequest == 'False' && request.requestPreviousPage == 'False')
            {
                reqDueDate = Date.parse(request.dueDate);
                reqLmts = Datetime.parse(request.lastModifiedTimestamp);        
                tasks = queryNextPage(userOrGroupIds, reqDueDate, reqLmts);
            }           
               
            //Iterating through the list of Task to know either its belong to lead or contact
            if(!tasks.isEmpty()){    
                //Iterating through the list of Task to get Ids for Lead and Contact.
                for(Task tsk : tasks){
                   if( tsk.whoId != null ) {
                        String whoId = tsk.whoId;                                        
                        /*
                            checking for the whoId, If whoId startsWith '003' then create the set of Ids for Contact
                            and if whoId startsWith '00Q' then create the set of Ids for Lead.
                        */
                        
                        if(whoId.startsWith('003')) contactIds.add(whoId);
                        else if(whoId.startsWith('00Q')) leadIds.add(whoId);
                        //adding the ownerids to the set
                        ownerIds.add(tsk.ownerId);     
                    }                
                }
            }
        
            //Iterating through the list of Contact, Lead and User to assigned the value to Maps.           
            if(!contactIds.isempty())
                contactDetails = new Map<Id,Contact> (queryContacts(contactIds));
            if(!leadIds.isempty())
                leadDetails = new Map<Id,Lead> (queryLeads(leadIds));
            if(!ownerIds.isempty())   
               userDetails = new Map<Id,User> (queryUsersOfOffice(ownerIds));
                
            //Need to get the recordTypeDetails
            recordTypeDetails =  new Map<ID, String> (Utils_Integration.taskRecordTypes()); 
        
           // Logic to determine moretasksforprev
            if ((Integer.valueOf(request.numberOfTasks) < countOfTaskRecord) && request.requestPreviousPage == 'True')
                moreTasksForPrev = 'True';
            
            // Logic to determine moretasksfornext
            if ((Integer.valueOf(request.numberOfTasks) < countOfTaskRecord) && request.requestPreviousPage == 'False')
                moreTasksForNext = 'True';            
        
    
            response = new list<OfficeTasksResponse>();
            //Iterating through the list of Task to assign the value to response object.
            for ( Task t :  tasks){
                OfficeTasksResponse tmp = new OfficeTasksResponse();
                String WhoId = t.WhoId;
        
                /*** Map the task values ***/
                tmp.countOfTasks = string.valueof(countOfTaskRecord);
                tmp.moreTasksForNext = moreTasksForNext;
                tmp.moreTasksForPrev = moreTasksForPrev;
                tmp.taskId = t.Id; 
                /* Since mentioned record Types yet to be created commented the tasktype mapping code */
                if(recordTypeDetails.get(t.recordTypeID) == 'Task') tmp.taskType = 'Follow-up'; 
                else if(recordTypeDetails.get(t.recordTypeID) == 'Interaction') tmp.taskType = 'Note'; 
                tmp.subject = t.Subject; 
                tmp.category = t.category__c;
                if(t.ActivityDate == null)
                    tmp.dueDate = null;
                else
                    tmp.dueDate = t.ActivityDate.month()+'/'+t.ActivityDate.day()+'/'+t.ActivityDate.Year();
                tmp.priority = t.priority ;
                tmp.lineOfBusiness = t.Businessline1__c ;
                if(t.CreatedDate == null)
                    tmp.createTimestamp = null;
                else
                    tmp.createTimestamp = Utils_Integration.DateConversion(t.CreatedDate, timeZone); //format the date field 
                if(t.CompletionDate__c == null)
                    tmp.completionDate = null;
                else
                    tmp.completionDate = Utils_Integration.DateConversion(t.CompletionDate__c, timeZone); //format the date field
                if(t.lastModifiedDate == null)
                    tmp.lastModifiedTimestamp = null;
                else
                    tmp.lastModifiedTimestamp = Utils_Integration.DateConversion(t.lastModifiedDate, timeZone); //format the date field 
                if( t.WorkItem1__c == Null ) tmp.workItemPresent = 'N' ; 
                    else tmp.workItemPresent = 'Y' ;
                tmp.officeOwner = 'SFDC' ; 
                   
                /*** Map the User record values ***/                
                tmp.associateId = userDetails.get(t.ownerId).AssociateIdentifier__c;            
                tmp.assignedToFirstName = userDetails.get(t.ownerId).FirstName;
                tmp.assignedToLastName = userDetails.get(t.ownerId).LastName ;
                //tmp.assignedToMiddleName; Field yet to be created
                //tmp.assignedToSuffix; Field yet to be created
                 
                /*** Map the Contact record values ***/ 
                if( WhoId != null ) {   
                    if( WhoId.StartsWith('003')){
                        //tmp.customerId = ; Field yet to be created
                        tmp.customerFirstName = contactDetails.get(WhoId).FirstName;
                        tmp.customerLastName = contactDetails.get(WhoId).LastName;
                        //tmp.customerMiddleName = contactDetails.get(WhoId).MiddleName__c;
                        //tmp.customerSuffix = contactDetails.get(WhoId).NameSuffix__c;
                    }   
                     
                    /*** Map the Lead record values ***/    
                    else if( WhoId.StartsWith('00Q')){   
                        //tmp.customerId = ; Field yet to be created
                        tmp.customerFirstName = leadDetails.get(WhoId).FirstName;
                        tmp.customerLastName = leadDetails.get(WhoId).LastName;
                        //tmp.customerMiddleName = leadDetails.get(WhoId).MiddleName__c; Field yet to be created
                        //tmp.customerSuffix = leadDetails.get(WhoId).NameSuffix__c;               
                     }
                }
             response.add(tmp);
            }
        }                         
        return response;
    }
    
    /*
     @Method <This method findAllGroupUserIds is used to retrive all users in the group>       
     @param <userId - userId as parameters>  
     @return <Method returns set of Id>
     @throws exception - <Method is not throwing any exception>
    */
    public static Set<Id> findAllGroupUserIds(String userId){
        Set<Id> userOrGroupIds = new Set<Id>();
        List<Id> groupIds = new List<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        
        //Querying on the GroupMember to get the groupId for the user
        List<GroupMember> groupIdes = [SELECT groupId FROM GroupMember WHERE UserOrGroupId =: userId];
        for(GroupMember m:groupIdes)
            groupIds.add(m.groupId);
        
        //Querying on the GroupMember to get the list of UserOrGroupId for the group.
        for (GroupMember m : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN: groupIds])
        {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType))
                userOrGroupIds.add(m.UserOrGroupId);
        }       
        return userOrGroupIds;                  
    }      
    
    /*
     @Method <This method queryFirstTime is used to get the Retrieve Office Tasks – First Time>       
     @param <userOrGroupIds - userId as parameter's>  
     @return <Method returns list of Tasks>
     @throws exception - <Method is not throwing any exception>
    */
    public static List<Task> queryFirstTime(Set<id> userOrGroupIds){       
        // Assigning the value with the total count of records
        countOfTaskRecord = [SELECT count()
        
                            FROM Task
                            
                            WHERE  OwnerId IN: userOrGroupIds //AND SectionId__c = ‘0’
                            ];
                                                          
        // List holding all the task details for the First Time
        List<Task> tasks =  [SELECT  Id, whoId, ownerId, RecordTypeId, 
                                Subject, Category__c, ActivityDate, Priority, 
                                Businessline1__c, WorkItem1__c, 
                                CreatedDate, CompletionDate__c, LastModifiedDate
                            
                            FROM Task
                            
                            WHERE  OwnerId IN: userOrGroupIds //AND SectionId__c = ‘0’ 
                            
                            ORDER BY ActivityDate ASC,  LastModifiedDate DESC, ExternalTaskIdentifier__c ASC LIMIT : numOfTasks];
        return tasks;
    }
    
    /*
     @Method <This method queryPreviousPage is used to get the Retrieve Office Tasks – Previous Page>       
     @param <userOrGroupIds, dueDate and lastModifiedTimestamp - userOrGroupIds, dueDate and lastModifiedTimestamp as parameters> 
     @return <Method returns list of Tasks>
     @throws exception - <Method is not throwing any exception>
    */
    public static List<Task> queryPreviousPage(Set<id> userOrGroupIds, Date dueDate, Datetime lastModifiedTimestamp){          
        // Assigning the value with the total count of records
        countOfTaskRecord = [SELECT count()
                            
                            FROM Task
                            
                            WHERE  OwnerId IN: userOrGroupIds //AND SectionId__c = ‘0’
                            
                            AND (ActivityDate <: dueDate OR (ActivityDate =: dueDate  OR LastModifiedDate >: lastModifiedTimestamp )
                            
                            OR (ActivityDate =: dueDate  OR LastModifiedDate =: lastModifiedTimestamp ))];
                                                          
        // List holding all the task details for the Previous Page
        List<Task> tasks =  [SELECT  Id, whoId, ownerId, RecordTypeId, 
                                Subject, Category__c, ActivityDate, Priority, 
                                Businessline1__c, WorkItem1__c, 
                                CreatedDate, CompletionDate__c, LastModifiedDate
                            
                            FROM Task
                            
                            WHERE  OwnerId IN: userOrGroupIds //AND SectionId__c = ‘0’
                            
                            AND (ActivityDate <: dueDate OR (ActivityDate =: dueDate  OR LastModifiedDate >: lastModifiedTimestamp )
                            
                            OR (ActivityDate =: dueDate  OR LastModifiedDate =: lastModifiedTimestamp ))
                            
                            ORDER BY ActivityDate ASC,  LastModifiedDate DESC, ExternalTaskIdentifier__c ASC LIMIT : numOfTasks];                        
        return tasks;
    }
    
    /*
     @Method <This method queryNextPage is used to get the Retrieve Office Tasks – Next Page>       
     @param <userOrGroupIds, dueDate and lastModifiedTimestamp - userOrGroupIds, dueDate and lastModifiedTimestamp as parameters>  
     @return <Method returns list of Tasks>
     @throws exception - <Method is not throwing any exception>
    */
    public static List<Task> queryNextPage(Set<id> userOrGroupIds, Date dueDate, Datetime lastModifiedTimestamp){          
        // Assigning the value with the total count of records
        countOfTaskRecord = [SELECT count()
                            
                            FROM Task
                            
                            WHERE  OwnerId IN: userOrGroupIds //AND SectionId__c = ‘0’
                            
                            AND (ActivityDate <: dueDate OR (ActivityDate =: dueDate  OR LastModifiedDate <: lastModifiedTimestamp )
                            
                            OR (ActivityDate =: dueDate  OR LastModifiedDate =: lastModifiedTimestamp ))];
                                                          
        // List holding all the task details for the Next Page
        List<Task> tasks =  [SELECT  Id, whoId, ownerId, RecordTypeId, 
                                Subject, Category__c, ActivityDate, Priority, 
                                Businessline1__c, WorkItem1__c, 
                                CreatedDate, CompletionDate__c, LastModifiedDate
                            
                            FROM Task
                            
                            WHERE  OwnerId IN: userOrGroupIds //AND SectionId__c = ‘0’
                            
                            AND (ActivityDate <: dueDate OR (ActivityDate =: dueDate  OR LastModifiedDate <: lastModifiedTimestamp )
                            
                            OR (ActivityDate =: dueDate  OR LastModifiedDate =: lastModifiedTimestamp ))
                            
                            ORDER BY ActivityDate ASC,  LastModifiedDate DESC, ExternalTaskIdentifier__c ASC LIMIT : numOfTasks];                          
        return tasks;
    }
 
    /* 
        @Method <This method queryUser takes string associateId as input to get the salesforce user details on User Object>
        @param <associateId - SFDC needs to translate associateId to OwnerId>
        @return User - <Method returning instance of User>
        @throws exception - <Exception will be handled in the place where the function is called>   
    */   
    public static User queryUserbyAssociateId(String associateId) {  
        User usr = [ SELECT Id,firstName,/*middleName__c,suffix__c,*/ lastName
                     FROM User
                     WHERE associateIdentifier__c =: associateId]; 
                     
        return usr;
    }

    /* 
        @Method <This method queryContactByWhoId takes string WhoId as input and retrieves contact details on Contact Object>
        @param <whoId - Client External ID>
        @return Contact - <Method returning instance of Contact>
        @throws exception - <Exception will be handled in the place where the function is called>   
    */    
     public  static  Contact[] queryContacts(Set<Id> Ids) {
        Contact[] contacts = [ SELECT Id,firstName,/* middleName,suffix__c, */lastName
                         FROM Contact
                         WHERE Id IN: Ids];
                          
        return contacts ;
    }

    /* 
        @Method <This method queryLeadByWhoId queries the Lead object to fetch the record for a particular whoId>
        @param <whoId - Client External ID>
        @return Lead - <Method returning instance of Lead>
        @throws exception - <Exception will be handled in the place where the function is called>   
    */
    public static Lead[] queryLeads(Set<Id> Ids) {
        Lead[] leads = [ SELECT Id,firstName,/* middleName,suffix__c, */lastName
                    FROM Lead
                    WHERE Id IN: Ids];
                    
        return leads;
    }

    /* 
        @Method <This method queryOfficeUsers takes string associateId as input to get the salesforce user details on User Object>
        @param <associateId - SFDC needs to translate associateId to OwnerId>
        @return User - <Method returning instance of User>
        @throws exception - <Exception will be handled in the place where the function is called>   
    */    
    public static User[] queryUsersOfOffice(Set<Id> Ids) {
        User[] usrs = [ SELECT Id, associateIdentifier__c, FirstName, LastName/*, MiddleName__c, suffix__c*/ 
                        FROM User
                        WHERE Id  IN :Ids];                     
                     
        return usrs;
    }
 /*  
        @Method <This   method  does    null    value   check>
        @param  <   customerId, numberOfTasks,  type>
        @return <void>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called  and argument    values  passed  are null    or  blank   values> 
    */  
    public  Static  void   NullCheckValidations(  String associateId ,String firstTimeRequest ,String  numberOfTasks,String  requestPreviousPage ,String lastModifiedTimestamp ,String countOfTasksRequired ){
        
        String  nullCustomException ;
        
        
        //  associateId Null    value   check
            nullCustomException =   Utils_Integration.dataNullValidationhelper  (   'associateId ',   associateId )   ;
            
        //  firstTimeRequest Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'firstTimeRequest ', firstTimeRequest )   ;       
                
        //  numberOfTasks  Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'numberOfTasks', numberOfTasks)   ;
            
         // requestPreviousPage Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'requestPreviousPage ', requestPreviousPage )   ;
            
         // lastModifiedTimestamp Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'lastModifiedTimestamp ', lastModifiedTimestamp )   ;                        
            
         // countOfTasksRequired  Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'countOfTasksRequired ', countOfTasksRequired )   ;                      
            
            
        //  Throw   custom  exception   if  any of  the request parameter   is  null    value
                    
            if  (   nullCustomException.length()    >   0   )   {   
                
                throw   new ApexException   (nullCustomException);
            
            }   
    
    }   //  End of  Method  NullCheckValidations
     
    
   
}