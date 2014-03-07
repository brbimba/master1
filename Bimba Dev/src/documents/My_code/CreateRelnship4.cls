/*
    Author          : Accenture IDC Team
    Date Created    : 10/24/2012
    Description     : This is the test class containing the test method that sets the mock callout mode,
    				  It calls the invokeWScall method in the CreateCustomerRelationship class and verifies that a mock response is received.
    Version         : Initial Draft
*/
@isTest
private class CreateCustomerRelationship_Test{
    @isTest static void testinvokeWScall() {              
        // This causes a fake response to be generated 
    
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        // Call the method that invokes a callout 
    
         CustomerManagementService.CreateRelationshipResponse Customer = CreateCustomerRelationship.invokeWScall('Bijay','Ajay','Brother');
        
        // Verify that a fake result is returned 
    
       System.assert(Customer!=null);   
    }
}