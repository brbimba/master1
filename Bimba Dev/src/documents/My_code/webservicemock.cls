/*
    Author          : Accenture IDC Team
    Date Created    : 10/24/2012
    Description     : Test class which Implement the WebServiceMock interface and specify a fake response that the Apex runtime should send.
    Version         : Initial Draft
*/
@isTest
global class WebServiceMockImpl implements WebServiceMock {

            global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
            
            CustomerManagementService.createRelationshipRes respElement =
            new CustomerManagementService.createRelationshipRes ();
 			respElement.customerResponse= new CustomerManagementService.CreateRelationshipResponse();
            response.put('response_x', respElement);
            
            }
}