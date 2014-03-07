/*
    Author          : Accenture IDC Team
    Date Created    : 10/15/2012
    Description     : Webservice callout class for CustomerManagementService WSDL2ApexClass.
    Version         : Initial Draft
*/
public class CreateCustomerRelationship{
 
 /* @Method <This method invokeWScall invokes the stub class present in the CustomerManagementService(WSDL2Apex)>
        @param <CustomerId1,CustomerId2,relationshipNature>
        @return <relationshipresponse> 
        @throws exception - <Exception will be handled in the place where the function is called><TBD>   
    */ 
    public static CustomerManagementService.CreateRelationshipResponse invokeWScall(String customerId1, String customerId2, String relationshipNature){
    
	     CustomerManagementService.CreateRelationshipRequest request = new CustomerManagementService.CreateRelationshipRequest();
	     request.customerId1 = customerId1;
	     request.customerId2 = customerId2;
	     request.relationshipNature = relationshipNature;
	     
	     CustomerManagementService.CustomerManagementPort response = new  CustomerManagementService.CustomerManagementPort ();
	     
	     //string message;
	     CustomerManagementService.CreateRelationshipResponse relationshipresponse;
	     try {
	     	relationshipresponse = response.createRelationship(request);
	     	System.Debug('RelationshipResponse ==> ' + relationshipresponse);
	       //	Message = 'Success';
	     } Catch ( System.CalloutException e){
	 	 	System.Debug('CalloutException  ==> ' + e );
	     	//Message = 'Failure';  
	     }	 	
	     
     return relationshipresponse;
    
    }
 
 }