/*
    Author          :   Bimba, Bijay 
    Date    Created :   11/30/2012
    Description     :   Webservice  callout class   for ContractStates  WSDL2ApexClass.
    Version         :   Initial Draft
*/
public  class   AP_ContractStateCallOut {   
    
    /*  @Method <This   method  invokeWScall    invokes the stub    class   present in  the ContractStates(WSDL2Apex)>
        @param  <req    -Request    as  a   Parameter>
        @return <setPostalCode> 
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called><TBD>    
    */  
    
    public  static  String[]  retrieveContractState(String associateId){   	
    	
        //  Variables   declaration and initialization
        try{
        /** Creating    the instance    of  the request class   of  WSDL2Apex   and Map it  to  the Request Wrapper Class   **/
        ContractStates.associateIdInput request =   new ContractStates.associateIdInput();
        request.associateId =   associateId ;
                
        ContractStates.AssociateBookOfBusinessInquiryPerf   invokeWS    =   new ContractStates.AssociateBookOfBusinessInquiryPerf   ()  ;
         
        /** Authentication  Details **/
        invokeWS.inputHttpHeaders_x =   new Map<String, String>(); 
        Blob    userPwd =   Blob.valueOf('SFDC_Temp_SFICP'  +   ':' +   'JyutRt567R');
        String  encodedAuth =   EncodingUtil.base64Encode(userPwd);
        invokeWS.inputHttpHeaders_x.put (   'SR_API_KEY'    ,   '6e179f25-a8c0-4bf8-bed7-09033d727875'  );
        invokeWS.timeout_x  =   30000   ;
        
        /** Creating    the instance    of  the response    class   of  the WSDl2Apex   and call    the method  retrieveBooksOfBusinessServicedByPerson by  passing the request(associateId)    **/
        ContractStates.booksServicedByPersonTO  response    =   new ContractStates.booksServicedByPersonTO();
        
        /** ContractStates.retrieveBooksOfBusinessServicedByPersonResponse  response    =   new ContractStates.retrieveBooksOfBusinessServicedByPersonResponse();   **/

        List<String> setPostalCode = new List<String> () ;
        Set<String> tmp = new Set<String> () ;
            
        
            response    =   invokeWS.retrieveBooksOfBusinessServicedByPerson(request);
             
            /*bookOfBusinessTO*/
                
                for ( ContractStates.bookOfBusinessTO a : response.booksOfBusiness ) {
                   if( a.postalStateCode != null ) {
                       tmp.add(a.postalStateCode); 
                       system.debug(response);
                   }
                }
                
                setPostalCode.addall(tmp); 
                
        return  setPostalCode;         
        } catch (System.Nullpointerexception e ) {
            System.debug('CallOut   Exception   catch:'+    e.getMessage());                    
            throw new ApexException ( e.getMessage() ) ;
        }

// System.CalloutException e 
        
    }
}



/*  use below   code    to  make    webservice  callout 


  System.Debug( ' results ==> ' +AP_ContractStateCallOut.retrieveContractState('HWLMS5BLTAK'));
 



*/