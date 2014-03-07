/*
    Author          : Accenture IDC Team
    Date Created    : 11/19/2012
    Description     : Test class which Implement the WebServiceMock interface and specify a fake response that the Apex runtimet should send.
    Version         : Initial Draft
*/
@isTest
global class AddressStandardizationWebServiceMockImpl implements WebServiceMock {
  
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
            
            AddressStandardizationLocation.StandardizedAddressResponse res = new AddressStandardizationLocation.StandardizedAddressResponse();
           
            res.standardizedAddress.firmName = 'Mock Response1';
            res.standardizedAddress.city = 'Mock Response2';
            res.standardizedAddress.postalCode = 'Mock Response3';
            res.standardizedAddress.stateProvince = 'Mock Response4';
            res.standardizedAddress.streets[0] = 'Mock Response5';
            res.statusCode = 'Mock Response6';
            res.messages[0].messageText =  'Mock Response7';
            response.put('response_x', res);
            }
}