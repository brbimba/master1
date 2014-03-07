/*  
        @Author         :   Ayush,  Kriti,  Bimba,  Anant,  Bijay
        @Date   Created :   10/22/2012  
        @Description        :   This    is  Reusable    class.  
                        It  contains    methods to  perform SOQL    queries of  Contact,    Lead,   Tasks,  User    objects
                        and can be  re-used in  other   webservices classes.
    

*/
    public  class   Utils_Integration   {
    
    /*  
        @Method <This   method  is  a   helper  method  for NullCheckValidations    for WS_RetrieveTaskDetails  and WS_RetrieveMostRecentTasks>
        @param  <   inputParam,inputValue   >
        @return <String>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */
    public  Static  String  dataNullValidationhelper    (   String  inputParam, String  inputValue  ){
        
        
        
        //  Once    DevMajor    is  updated to  current version the below   the commented   line    shall   be  used.
        //  Assuming    inputValue  =   'null'  can be  recieved
        //  if( inputValue.isBlank()    )   
        if( inputValue  ==  null    ||  inputValue.length() ==  0   ||  inputValue  ==  'null'  )   {
        
                return  inputParam  +   '   is  Null    or  Blank'  +   '\n'    ;
            
            }
        
        return  ''  ;
    }   //End   of  Method  dataNullValidationHelper    
    
    /*  
        @Method <This   method  returns Date    in  the given   TimeZone>
        @param  <paramDate,timeZone>
        @return <String>    
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */
    public  static  String  dateConversion(DateTime paramDate,  String  timeZone)   {
        
    
        
        String  str =   String.Valueof(paramDate);
        Datetime    dateToParse =   Datetime.Valueof(str);
        String  formatedDate    =   dateToParse.format('yyyy-MM-dd  HH:mm:ss',  timeZone);
        
        return  formatedDate;
    }   //End   of  Method  dateConversion
    
    public  static  String  recordTypeName( String  recordTypeId    )   {   
    
    /*  
        @Method <This   method  returns record  type    name    for a   particular  record  type    ID>
        @param  <recordTypeId,
        @return <String>    
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */  
        
                
        return  [SELECT Name,   Id
                        FROM    RecordType  
                        WHERE   Id  =:  recordTypeId    ].Name  ;
                                
        
    }//End  of  Method  recordTypeName
    
    
    public  static  Map<Id,String>  taskRecordTypes()   {   
        
    /*  
        @Method <This   method  returns list    of  record  type    name    for a   list    of  record  type    ID>
        @param  List<Id>,
        @return List<String>    
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */
        
        Map<Id,String>  mapRecordTypeName   =   new Map<Id,String>();
                
        RecordType[]    recordTypes =   [SELECT Name,   Id
                                        FROM    RecordType  
                                        WHERE   SobjectType =   'Task'] ;
        
        for (RecordType r:  recordTypes )   {                       
            mapRecordTypeName.put(r.Id,r.Name);
        }
        
        return  mapRecordTypeName;
    }//End  of  Method  taskRecordTypes

    //-----------For    RetrieveMostRecentTasks------------//
    
    public  static  Account queryAccountBycustomerId(   String  customerId){
    /*  
        @Method <This   method  queryAccountBycustomerId    queries the Account object  to  fetch   the record  for a   particular  customerId>
        @param  <customerId -   external    customer    ID>
        @return <Account>   -   <Method returning   instance    of  Account>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */  
            
        return  [   SELECT  Id, PersonContactId, firstName, lastName ,MiddleName__c , Account.NameSuffix__pc, Account.ClientIdentifier__c
                            FROM    Account where   Account.ClientIdentifier__c =   :customerId ]   ;
        }   //End   of  Method  queryAccountBycustomerId
        
   
                    
        
    public  static  List<Task>  queryTaskList(String    whoId,  Integer numberOfTasks)  {
        
    /*  
        @Method <This   method  queryTask   method  queries the Task    object  to  fetch   the record  for a   particular  whoId>
        @param  <whoId          -   client  external    ID>
                <>numberOfTasks -   number  of  tasks   that    should  be  retrieved   in  this    service request>
        @return <Contact>   -   <Method returning   list    of  Task>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */  

        return  [SELECT OwnerId,Owner.Firstname, Owner.LastName , ExternalTaskIdentifier__c,BusinessLine1__c,
                                    RecordTypeId, RecordType.Name, ActivityDate,LastModifiedDate, CreatedDate,category__c,
                                    subject,    priority,status,Type
                            FROM    Task    
                            WHERE   WhoId   =:  whoId   
                            ORDER   BY  LastModifiedDate    desc,ExternalTaskIdentifier__c  asc Limit   :numberOfTasks] ;
        
    }//End  of  Method  queryTaskList
        
   // public  static  Map<Id,User>    queryUserList(Set<Id>   assignedToIds)  {
    
    /*  
        @Method <This   method  queryUser   method  queries the User    object  to  fetch   the record  for a   particular  AssociateId>
        @param  <assignedToIds  -   <List   of  Ids>
        @return List<User>  -   <Map    containing  ID  and User>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */
     /*  return  new Map<Id,User>(   [SELECT Id, FirstName,  LastName
                                        FROM    User
                                        WHERE   Id  IN  :assignedToIds  ]);
        
    } */  //End   of  Method  queryUserList

    //-----------   For RetrieveTaskDetails ---------//
    
    public  static  Task    queryTask   (   String  taskId  )   {
    
    /*  
        @Method <This   method  queryTask   method  takes   string  taskId  as  input   and retrieves   task    details on  Task    Object>
        @param  <taskId -   External    Task    ID  in  SFDC>
        @return Task    -   <Method returning   instance    of  Task>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */

        return  [SELECT Id,subject,whoId,ActivityDate,priority,category__c,
                            completionDate__c,LastModifiedDate,status,
                            WorkItem1__c,WorkItem2__c,ownerId,Owner.firstName,Owner.lastName,Owner.alias,CallType,Type,
                            BusinessLine1__c,BusinessLine2__c,
                            ActivitySource__c,ComplaintType__c,Product1__c,Product2__c,
                            RecordTypeId,RecordType.Name,ExternalTaskIdentifier__c
                        FROM    Task
                        WHERE   ExternalTaskIdentifier__c   =:  taskId] ;
        
    }//End  of  Method  queryTask   
    
        
    
    public  static  Account queryAccountById    (   String  Id  )   {
    
    /*  
        @Method <This   method  queryAccountByIdmethod  queries the Account object  to  fetch   the record  for a   particular  ContactId>
        @param  <Id -   Contact ID>
        @return Account -   <Method returning   instance    of  Account>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */

        return  [SELECT Id, ClientIdentifier__c,FirstName,MiddleName__c,LastName,  NameSuffix__pc, PersonContactId
                                FROM    Account 
                                WHERE   PersonContactId =:  Id];

    }//End  of  Method  queryAccountById 
     
    
        public  static  Map<Id,User>    queryUserbyRemarkOwnerId    (Set<Id>   remarkownerId)  {
    
       /* 
        @Method <This   method  queryUser   method  queries the User    object  to  fetch   the record  for a   particular  AssociateId>
        @param  <   remarkownerId-  <List   of  Ids>
        @return List<User>  -   <Map    containing  ID  and User>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
      */
        return  new Map<Id,User>([SELECT    Id, FirstName,  LastName,   Alias,  Department
                                                        FROM    User
                                                    WHERE   Id  =:remarkownerId ]);
        
                                                            
        
    }    //End   of  Method  queryUserbyRemarkOwnerId    
    
    
    
    public  static  List<Remark__c> queryRemarkList(String  ExternalTaskIdentifier) {
    
    /*  
        @Method <This   method  queryRemark method  takes   string  task.ExternalTaskIdentifier__c  as  input   and retrieves   Remark  fields  on  Remark__c   Object>
        @param  <ExternalTaskIdentifier-    This    is  the Task    External    Id>
        @return List<Remark>    -   <List   of  Remark__c   object  with    required    fields>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */

        return  [SELECT Id, LastModifiedDate,   OwnerId,    Remark__c,  TaskIdentifier__c
        
                            FROM    Remark__c   
                                    
                            WHERE   TaskIdentifier__c   =:  ExternalTaskIdentifier
                                    
                            ORDER   BY  LastModifiedDate    desc
                            
                            Limit   2];
                            
        
    }   //End   of  Method  queryRemarkList
    
    //----------------- For RetrieveOfficeTasks ---------------//
        
    public  static  User    queryUserbyAssctId  (   String  associateId )   {
    
    /*  
        @Method <This   method  queryUser   takes   string  associateId as  input   to  get the salesforce  user    details on  User    Object>
        @param  <associateId    -   SFDC    needs   to  translate   associateId to  OwnerId>
        @return User    -   <Method returning   instance    of  User>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */

        return  [   SELECT  Id,firstName,lastName
                        FROM    User
                        WHERE   associateIdentifier__c  =:  associateId];   
                        
        
    }
    
    
    
        public  static  List<Contact>   queryContactList(Set<Id>    Ids)    {
    
    /*  
        @Method <This   method  queryContactByWhoId takes   string  WhoId   as  input   and retrieves   contact details on  Contact Object>
        @param  <whoId  -   Client  External    ID>
        @return Contact -   <Method returning   instance    of  Contact>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called> 
    */

        return  [   SELECT  Id,firstName,lastName
                            FROM    Contact
                            WHERE   Id  IN: Ids];
                            
        
    }
    
    /*----------------------- CreateUpdate Task --------------*/
    
    
        /* 
    @Method <This method returns record type Id for a particular record type ID>
    @param <recordTypeId,
    @return <String> 
    @throws exception - <Exception will be handled in the place where the function is called>   
    */ 
  
    public static String getTaskRecordTypeIdbyName( String taskType ) {
     
        RecordType recType = [select id from RecordType where RecordType.Name =: TaskType];
        
    return recType.Id;
    }
   
    /*
    @ Method <this method returns the Contact Id or Lead Id for a particular record to be used for the WhoId in Create/UpdateTask >
    @param <ContactId or LeadId>
    @return <string>
    @throws exception - <Exception will be handled in the place where the function is called>
    */

    public static String getCustId ( String customerId, String customerType ) {
        //prevent soql injection
        If(customerType == 'Contact'){
        Contact c = [select id from Contact where AccountId IN (select id from Account where ClientIdentifier__c =: customerId)];
        String CustId = c.id;
        return CustId;
        }
        else {
        Lead l = [select id from Lead where id =: customerId];
        String CustId = l.id;
        return l.id;
        }
    }

    /*
    @ Method <this method returns a list of Customers. There should be only 1 customer due to ClientId is an external id and is unique.>
    @param <CustomerId>
    @return <List>
    @throws exception - <Exception will be handled in the place where the function is called>
    */
   
    public static List<Account> queryAccount (String CustomerId) {
        List<Account> customerSize = [SELECT Id 
        FROM Account                                
        WHERE ClientIdentifier__c =: CustomerId                                  
        ];
                                 
        return customerSize;
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
}