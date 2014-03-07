/*
    @Author         :   Accenture   IDC Team
    @Date   Created :   10/15/2012
    @Description        :   Webservice  callout class   for AddressStandardization  WSDL2ApexClass.
    @Version            :   Initial Draft
*/
public  class   AP_AddressStandardizationCallOut{
    
    
        /*  @Method <This   method  invokeWScall    invokes the stub    class   present in  the AddressStandardization(WSDL2Apex)>
        @param  <name,city,postalCode,state,streets>
        Return  <res>   
        @throws exception   -   <Exception  will    be  handled in  the place   where   the function    is  called><TBD>    
    */

        public  static  AddressStdResponse  AddStandardization( String  name,   String  street, String  city,   
                                                            String  state,  String  postalcode  )   {
            //  Variables   declaration and initialization
            
            AddressStandardizationLocation.CallerDetails    CallerDetails   =   new AddressStandardizationLocation.CallerDetails    ()  ;
            AddressStandardizationLocation.StandardizedAddressResponse  response    =   new AddressStandardizationLocation.StandardizedAddressResponse();   
            AddressStandardizationLocation.Address  reqAddressDetails   =   new AddressStandardizationLocation.Address  ()  ;
            List<String>    streetlist  =   new List<String>{street};
            
            //  Call    queryUserOwnerId    Method
            User    user    =   Utils_Integration.queryUserOwnerId(userinfo.getUserId());

                CallerDetails.caller    =   user.alias;
                CallerDetails.failover  =   True    ;
                CallerDetails.operationCenter   =   'Test'  ;
                CallerDetails.callingApplication    =   'SALESFORCE.COM';
                CallerDetails.callingArea   =   'salesforce.com';
            
            AddressStandardizationPort.StandardizedAddress  invokeWS    =   new AddressStandardizationPort.StandardizedAddress  ()  ;
            invokeWS.inputHttpHeaders_x =   new Map<String, String>();  
        
            Blob    userPwd =   Blob.valueOf('SFDC_Temp_SFICP'  +   ':' +   'JyutRt567R');
            String  encodedAuth =   EncodingUtil.base64Encode(userPwd);
            invokeWS.inputHttpHeaders_x.put (   'SR_API_KEY'    ,   '09c9fd6a-1a7f-471f-9f91-0f4244faeb8d'  );
            invokeWS.inputHttpHeaders_x.put('Authorization',    'Basic  '   +   encodedAuth);
            invokeWS.timeout_x  =   30000   ;
        
            
            
            //  Mapping request parameters  for method  arguments
            
            reqAddressDetails.firmname= name;
            reqAddressDetails.city= city;
            reqAddressDetails.postalCode=   postalcode;
            reqAddressDetails.stateProvince =   state;
            reqAddressDetails.streets   =   streetlist;
            
            
            response    =   invokeWS.getStandardizedAddress(CallerDetails,reqAddressDetails);   
            AddressStdResponse  res =   new AddressStdResponse();
            
            res.statusCode  =   response.statusCode;
            if  (   response.messages   !=  NULL    )   {
                for (AddressStandardizationLocation.Message msg:    response.messages){
                    res.messages=   res.messages+msg;
                }
            }
            
            
            /***    return  the single  standardized    address ***/

            AddressStdResponse.Addresses    tmp =   new AddressStdResponse.Addresses    ();
            
            /*Populate  response    list    only    if  statuscode  is  equal   to  zero*/
            if(response.standardizedAddress.streets !=  null    ){  
                tmp.Street  =   response.standardizedAddress.streets;
                tmp.City    =   response.standardizedAddress.City   ;
                tmp.State   =   response.standardizedAddress.stateProvince  ;
                tmp.ZipCode =   response.standardizedAddress.postalCode ;
            }/* statusCode  =06 means   the entered addres  is  invalid for statefarm   database*/
            
            res.address =   tmp ;
            
            return  res;    
    }
                    
}