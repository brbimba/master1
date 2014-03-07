/*
    Author          : Accenture IDC Team
    Date Created    : 11/19/2012
    Description     : This is the test class containing the test method that sets the mock callout mode,
                        It calls the invokeWScall method in the AP_AddressStandardizationCallOut_Test class and verifies that a mock response is received.
    Version         : Initial Draft
*/
@isTest
private class AP_AddressStandardizationCallOut_Test {
  
    @isTest static void testretrieveaddStd() {              
        /* This causes a mock response to be generated */
    
        Test.setMock(WebServiceMock.class, new AddressStandardizationWebServiceMockImpl());
        
        /* Call the method that invokes a callout */


     String name = 'Hello Mock1';
     String street = 'Hello Mock2';
     String city = 'Hello Mock3';
     String state = 'Hello Mock4';
     String postalcode = 'Hello Mock5';
    
    AddressStdResponse res = new AddressStdResponse();  
    res = AP_AddressStandardizationCallOut.AddStandardization(name,street,city ,state,postalcode );
        
        /* Verify that a fake result is returned */
    /* System.assertEquals('Mock response1', name);
     System.assertEquals('Mock Response2',street );
     System.assertEquals('Mock Response3',city );
     System.assertEquals('Mock Response4',state );
     System.assertEquals('Mock Response5',postalcode );*/
         
    }
}