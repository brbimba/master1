/*
    Author          : Accenture IDC Team
    Date Created    : 11/19/2012
    Description     : Test class which Implement the WebServiceMock interface and specify a fake response that the Apex runtimet should send.
    Version         : Initial Draft
*/
@isTest
global class ContractStateWebServiceMockImpl implements WebServiceMock {
  
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
            
            ContractStatesNew.bookOfBusinessTO postalcoderesponse = new ContractStatesNew.bookOfBusinessTO ();
            postalcoderesponse.postalStateCode = 'Mock_Response';
            response.put('response_x', postalcoderesponse);
            
            
                }
}