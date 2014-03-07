/*
    Author          :   Accenture   IDC Team
    Date    Created :   11/30/2012
    Description     :   Webservice  callout class   for CustomerMgmtService WSDL2ApexClass.
    Version         :   Initial Draft
*/
public  class   AP_CreateCustomerRelationshipCallOut{
    
        /*  @Method <This   method  invokeWScall    invokes the stub    class   present in  the CustomerMgmtService(WSDL2Apex)>
        @param  <CreatRelationshipRequest   req >
        @return <relationshipresponse>  
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called><TBD>    
    */  
        public  static  CreatRelationshipResponse   invokeWScall(CreatRelationshipRequest   req){
        
        /** Audit   Request **/
        
        CustomerMgmtSecurity.Audit  AuditDetails    =   new CustomerMgmtSecurity.Audit()    ;
        
        /** Invoking    method  queryUser   from    Utils_Integration   class   to  get the Details of  the users   **/ 
        User    user    =   Utils_Integration.queryUserOwnerId(userinfo.getUserId());
        //User    user    =   [Select id, alias   from    User    where   Id  =:  userinfo.getUserId()];
        
        AuditDetails.userId =   user.alias;
        AuditDetails.callingApplication =   'SALESFORCE.COM';
        AuditDetails.callingArea    =   'SALESFORCE.COM';   
                    
        CustomerMgmtService.CustomerManagementPort  invokeWS    =   new CustomerMgmtService.CustomerManagementPort();
        invokeWS.inputHttpHeaders_x =   new Map<String, String>();
        
        //Blob  userPwd =   Blob.valueOf('SFDC_Temp_SFICP'  +   ':' +   'JyutRt567R');
        //updated   Userid  and password    credentials
        //Blob  userPwd =   Blob.valueOf('WO139'    +   ':' +   'CLTAgt268' +   ':' +   'UNTAGCY');
        Blob    userPwd =   Blob.valueOf('WO139'    +   ':' +   'CLTAgt268');
        String  encodedAuth =   EncodingUtil.base64Encode(userPwd);
        //invokeWS.inputHttpHeaders_x.put   (   'SR_API_KEY'    ,   '09c9fd6a-1a7f-471f-9f91-0f4244faeb8d'  );
        //updated   API key
        invokeWS.inputHttpHeaders_x.put (   'SR_API_KEY'    ,   '07a35ce9-64c8-4104-91ac-87f74944519d'  );
        invokeWS.inputHttpHeaders_x.put('Authorization',    'Basic  '   +   encodedAuth);
        invokeWS.timeout_x  =   30000   ;

        /*  Create  Relationship    */
        /** Creating    the instance    of  the request class   of  WSDL2Apex   and Map it  to  the Request Wrapper Class.  **/
        CustomerMgmtProfile.CreateRelationshipRequest   request =   new CustomerMgmtProfile.CreateRelationshipRequest();
        request.customerId1 =   req.customerId1;
        request.customerId2 =   req.customerId2;
        request.relationshipNature  =   req.relationshipNature;
            
        CustomerMgmtProfile.CreateRelationshipResponse  relationshipresponse;
            
        CreatRelationshipResponse   custrelresponse =   new CreatRelationshipResponse   ()  ;
        CustomerMgmtSecurity.faultBean  faultmsg    =   new CustomerMgmtSecurity.faultBean();
        
        try {
            if(faultmsg.message ==  null){
                relationshipResponse    =   invokeWS.createRelationship(request);
                custrelresponse.errMessage  =   'Success'   ;
            }
            
            }   Catch   (   System.CalloutException e){
            
            custrelresponse.errMessage  =   'Fail'  ;
                
            }       
            
        return  custrelresponse ;
    
    }
    
    }
    /*  use below   code    to  make    webservice  callout 


CreatRelationshipRequest    request =   new CreatRelationshipRequest();
request.customerId1 =   '3RYPG6T12XE';//Take    some    valid   customer    id  
request.customerId2 =   'ZJLW26T1CXE';//Take    some    valid   customer    id
request.relationshipNature  =   'Sister';// Give    relationship    nature

AP_CreateCustomerRelationshipCallOut.invokeWScall(request);

*/