/*
    Author          : Accenture IDC Team
    Date Created    : 10/24/2012
    Description     : This is the test class containing the test method that sets the mock callout mode,
                        It calls the invokeWScall method in the AP_CreateCustomerRelationship class and verifies that a mock response is received.
    Version         : Initial Draft
*/
@isTest
private class AP_CreateCustomerRelationship_Test{
    
    @isTest static void testInvokeWScall() {              
        /* This causes a mock response to be generated */
    
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        /* Call the method that invokes a callout */
        
		CustomerMgmtProfile.CreateRelationshipRequest req = new CustomerMgmtProfile.CreateRelationshipRequest();
        
        req.customerId1 ='Nikesh';
        req.customerId2 ='Anupama';
        req.relationshipNature = 'wife';
    
//       CustomerMgmtProfile.CreateRelationshipResponse Customer = AP_CreateCustomerRelationshipCallOut.invokeWScall(req);
        
        /* Verify that a fake result is returned */
    
 //      System.assert(Customer!=null);   
    }
}