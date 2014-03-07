/*
    *   Webservice  Class   is  used    to  generate    WSDL    which   is  exposed to  Mule    to  RetreiveMostRecentTasks for a   particuler  clientid
    *   @Author Kriti   Narula
    *   @Date   10/23/2012  
  */

global  class   WS_RetrieveMostRecentTasks{     
        
        
    Static  Contact cont    =   null    ;
    Static  Account acct    =   null    ;
            
    Static  Set<Id> assignedtoIds   ;
    Static  List<Task>  tasks   ;
    Static  Map<Id,String>  mapRecTypeNames ;
    
        /*
        *   Global  Wrapper Class   containing  request parametrs   as  member  variables
        *   @Author Kriti   Narula
        *   @Date   10/23/2012  
        */
    
        global  class   MostRecentTasksRequest{

            WebService  String  numberOfTasks;
            WebService  String  type;
            WebService  String  customerId;

    }   //  End of  Class   MostRecentTasksRequest
    
    /*
        *   Global  Wrapper Class   containing  response parameters   as  member  variables
        *   @Author Kriti   Narula
        *   @Date   10/23/2012  
    */
        global  class   MostRecentTasksResponse{
    
            Webservice  String  taskId;             
            Webservice  String  taskType;
            Webservice  String  category;
            Webservice  String  subject;
            Webservice  String  dueDate;
            Webservice  String  priority;
            Webservice  String  status;
            Webservice  String  lineOfBusiness_1;
            Webservice  String  createTimestamp;
            Webservice  String  lastModifiedTimestamp;
            Webservice  String  associateId;
            Webservice  String  userfirstName;
            Webservice  String  userlastName;
            Webservice  String  customerId;
            Webservice  String  customerfirstName;
            Webservice  String  customerlastName;
            Webservice  String  customermiddleName;
            Webservice  String  customersuffix;

    }   //  End of  Class   MostRecentTasksResponse
    
        
    /*  
        @Method <This   method  retrieves   the most    recent  tasks   for the specified   number  based   on  CustomerId  and Type    >
        @param  <   MostRecentTasksRequest  request>
        @return <List<MostRecentTasksResponse>  retrieveMostRecentTasks>    
        @throws exception   -   <Not    Applicable> 
    */      
    Webservice  static  List<MostRecentTasksResponse>   retrieveMostRecentTasks (   MostRecentTasksRequest  request )   {
            List<MostRecentTasksResponse>   responseList    ;
            
        
        //  Method  Variables   Declaration and Initialization
    
        //  Mapping the request parameters  values
            String  numberOfTasks   =   request.numberOfTasks   ;
            String  type    =   request.type;
            String  customerId  =   request.customerId  ;
            String  lastModifiedDate,   createdDate =   '';
            
        //1.    Data    validations checks  
                
            NullCheckValidations(   customerId, numberOfTasks,  type    );
                    
        
        //2.Invalid datatype    checks
            
            invalidCheckValidations(    customerId, numberOfTasks,  type    );
        
            
        //3.    Query   Account,  Tasks   
            queryRecords(   customerId, numberOfTasks   );  
        
                
        //4.    Assigning   values  to  response    wrapper 
            
            responseList    =   new List<MostRecentTasksResponse>   ()  ;
            
            for (Task   t   :   tasks){ 
            
            MostRecentTasksResponse response    =   new MostRecentTasksResponse();
            
            lastModifiedDate    =   t.lastModifiedDate.format('yyyy-MM-dd   hh:mm:ss.sss');
            createdDate     =   t.CreatedDate.format('yyyy-MM-dd    hh:mm:ss.sss'); 
            //  Task    Details Assignment
            response.taskId                 =   t.ExternalTaskIdentifier__c ;
            response.taskType               =   mapRecTypeNames.get(t.RecordTypeId);
            response.category               =   t.Category__c;
            response.subject                =   t.Subject;
            response.dueDate                =   t.ActivityDate.month()+'/'+ t.ActivityDate.day()+'/'+   t.ActivityDate.year();
            response.priority               =   t.Priority  ;
            response.status                 =   t.Status;
            response.lineOfBusiness_1       =   (t.BusinessLine1__c!=   null?t.BusinessLine1__c:null);                          
            response.createTimestamp        =   t.CreatedDate.year()+'-'+t.CreatedDate.month()+'-'+t.CreatedDate.day()+'T'+createdDate.substring(11,23)+'Z';
            response.lastModifiedTimestamp  =   t.lastModifiedDate.year()+'-'+t.lastModifiedDate.month()+'-'+t.lastModifiedDate.day()+'T'+lastModifiedDate.substring(11,23)+'Z';
            response.associateId            =   t.OwnerId;
            //  Contact Details Assignment
            response.customerfirstName      =   acct.FirstName  ;
            response.customermiddleName     =   acct.MiddleName__c  ;
            response.customerlastName       =   acct.LastName   ;
            //  Account Details Assignment
            response.customersuffix         =   acct.NameSuffix__pc ;
            response.customerId             =   acct.ClientIdentifier__c    ;
            //  User    Details Assignment
            response.userfirstName          =   t.Owner.FirstName  ;
            response.userlastName           =   t.Owner.LastName   ;
            
            responseList.add(response);
        }
        
        return  responseList    ;
            
    }   //  End of  Method  retrieveMostRecentTasks 
    
    /*  
        @Method <This   method  does    null    value   check>
        @param  <   customerId, numberOfTasks,  type>
        @return <void>
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called  and argument    values  passed  are null    or  blank   values> 
    */  
    public  Static  void    NullCheckValidations(   String  customerId, String  numberOfTasks   ,   String  type    ){
        
        String  nullCustomException ;
        
        //  customerId  Null    value   check
            nullCustomException =   Utils_Integration.dataNullValidationhelper  (   'CustomerId',   customerId  )   ;
            
        //  numberOfTasks   Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'Number Of  Tasks', numberOfTasks   )   ;       
                
        //  type    Null    value   check
            nullCustomException +=  Utils_Integration.dataNullValidationhelper  (   'Type', type    )   ;
            
            
        //  Throw   custom  exception   if  any of  the request parameter   is  null    value
                    
            if  (   nullCustomException.length()    >   0   )   {   
                
                throw   new ApexException   (nullCustomException);
            
            }   
    
    }   //  End of  Method  NullCheckValidations
    
    
    /*  
        @Method <This   method  does    invalid value   check>
        @param  <   customerId  ,numberOfTasks, type>
        @return <void>
        @throws exception   -   <Exception  is  thrown  in  place   where   the function    is  called  and passed  argmets values  are invalid>    
    */  
    public  Static  void    invalidCheckValidations(    String  customerId, String  numberOfTasks   ,   String  type    )   {
        
        String  notValidCustomException ='';
        
        if  (   !customerId.isAlphaNumeric()    )   {
                
                notValidCustomException +=  'customerId is  Invalid String'+'\n';
            
            }
            
            if  (   !numberOfTasks.isNumeric()  ){
                
            notValidCustomException +=  'numberOfTasks  is  Invalid Integer'+'\n';}
            
            
            if  (type   !=  'Contact'){
                
            notValidCustomException +=  'Type   can only    be  Contact';}
            
            
        
        //  Throw   custom  exception   if  any of  the request parameter   has invalid datatype*/  
        
            if  (   notValidCustomException.length()    >   0   )   {   
            
                throw   new ApexException   (notValidCustomException);
            
            }// End of  Method  invalidCheckValidations
    
    }
    
    
    /*  
        @Method <This   method  calls   all the query   object  methods>
        @param  <   customerId  ,numberOfTasks  >
        @return <void>
        @throws exception   -   <Exception  will    be  thrown  if  no  record  are retrieved   in  SOQL>   
    */
    public  Static  void    queryRecords(   String  customerId, String  numberOfTasks   )   {
        
        try{
                
                acct    =   Utils_Integration.queryAccountBycustomerId(customerId);

                    if( acct    !=  null    )   {
                        //  Initailizing    tasks   list
                        tasks   =   new List<Task>();
                        
                        tasks   =   Utils_Integration.queryTaskList(    acct.PersonContactId,    integer.valueof(numberOfTasks)  );
                
                        for (Task   t   :   tasks){ 
                            //  Initailizing    assignedtoIds   set
                            assignedtoIds   =   new Set<Id>();
                            
                            assignedtoIds.add(t.OwnerId);
                            //  Initailizing    mapRecTypeNames map
                            mapRecTypeNames =   new Map<Id,String>();
                                
                            mapRecTypeNames =   Utils_Integration.TaskRecordTypes();
                        
                        }
                    
                 

                    }// End of  if  statement

            }   catch   (System.Queryexception  e   )   {
                
        //  Throw   custom  exception   if  no  record  found   for mentioned   customerId
                throw   new ApexException   ('No    record  found   for the mentioned   customerId');
            
            }// End of  try catch   block   
    
    }
    
    }