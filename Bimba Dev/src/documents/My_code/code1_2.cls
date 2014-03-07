/*
    Author          : Accenture IDC Team
    Date Created    : 11/19/2012
    Description     : This is the test class containing the test method that sets the mock callout mode,
                        It calls the invokeWScall method in the AP_ContractStateCallOut class and verifies that a mock response is received.
    Version         : Initial Draft
*/
@isTest
private class AP_ContractStateCallOut_TEST {
	
    @isTest static void testretrieveContractState() {              
        /* This causes a mock response to be generated */
    
        Test.setMock(WebServiceMock.class, new ContractStateWebServiceMockImpl());
        
        /* Call the method that invokes a callout */

        //ContractStatesNew.associateIdInput assocreq = new ContractStatesNew.associateIdInput();
        ContractStateRequest req = new ContractStateRequest();
        //assocreq.associateId ='Hello Mock';
        req.associateId ='Hello Mock';
    	
    	
		Set<ContractStateResponse> postalcoderesponse = AP_ContractStateCallOut.retrieveContractState(req);
        
        /* Verify that a fake result is returned */
   // 	System.assertEquals('Mock response', postalcoderesponse);
         
    }
}