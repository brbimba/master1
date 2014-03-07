/*         
 Author          : Accenture IDC Team         
 Date Created    : 11/02/2012          
 Description     : TestClass for WS_RetrieveOfficeTasks
*/   
@istest (SeeAllData=true)
public class WS_RetrieveOfficeTasks_Test{
    
    /*
     @Method <This method webserviceTestNullcheck tests the request parameters for null values>       
     @param <Not Taking any Parameter's>  
     @return <Method does not return any value>
    */    
    static testmethod void webserviceTestNullCheck(){
    
        WS_RetrieveOfficeTasks.OfficeTasksRequest request = new  WS_RetrieveOfficeTasks.OfficeTasksRequest();
        List<WS_RetrieveOfficeTasks.OfficeTasksResponse> responseList = new  List<WS_RetrieveOfficeTasks.OfficeTasksResponse>();

        request.numberOfTasks = '';
        request.countOfTasksRequired = '';
        request.associateId = '';
        request.dueDate = '';
        request.lastModifiedTimestamp = '';
        request.requestPreviousPage = '';
        request.firstTimeRequest = '';
       
        responseList = WS_RetrieveOfficeTasks.retrieveOfficeTasks(request);
    }
    
     static testmethod void webserviceTestInvalidCheck() {
         
          WS_RetrieveOfficeTasks.OfficeTasksRequest request = new  WS_RetrieveOfficeTasks.OfficeTasksRequest();
        List<WS_RetrieveOfficeTasks.OfficeTasksResponse> responseList = new  List<WS_RetrieveOfficeTasks.OfficeTasksResponse>();
    
          request.numberOfTasks = '510000';
          request.countOfTasksRequired = 'tru';
          request.associateId = '6546212a';
          request.dueDate = '445542a';
          request.lastModifiedTimestamp = '545a';
          request.requestPreviousPage = 'fals';
          request.firstTimeRequest = 'fals';
        
           responseList = WS_RetrieveOfficeTasks.retrieveOfficeTasks(request);
     }
     
     static testmethod void  webserviceTestInvalidData() {
         
        WS_RetrieveOfficeTasks.OfficeTasksRequest request = new  WS_RetrieveOfficeTasks.OfficeTasksRequest();
        List<WS_RetrieveOfficeTasks.OfficeTasksResponse> responseList = new  List<WS_RetrieveOfficeTasks.OfficeTasksResponse>();
    
          request.numberOfTasks = '500000';
          request.countOfTasksRequired = 'tru';
          request.associateId = '6546212';
          request.dueDate = '06/11/2010';
          request.lastModifiedTimestamp = '2012a';
          request.requestPreviousPage = 'True';
          request.firstTimeRequest = 'True';
        
           responseList = WS_RetrieveOfficeTasks.retrieveOfficeTasks(request);
     }
     
     static testmethod void  webserviceTestFirstTime() {
         
        WS_RetrieveOfficeTasks.OfficeTasksRequest request = new  WS_RetrieveOfficeTasks.OfficeTasksRequest();
        List<WS_RetrieveOfficeTasks.OfficeTasksResponse> responseList = new  List<WS_RetrieveOfficeTasks.OfficeTasksResponse>();
    
          request.numberOfTasks = '50';
          request.countOfTasksRequired = 'true';
          request.associateId = 'OFTA01';
          request.dueDate = '06/11/2010';
          request.lastModifiedTimestamp = '2012';
          request.requestPreviousPage = 'False';
          request.firstTimeRequest = 'True';
        
           responseList = WS_RetrieveOfficeTasks.retrieveOfficeTasks(request);
     }
     
     static testmethod void  webserviceTestPreviousPage() {
         
        WS_RetrieveOfficeTasks.OfficeTasksRequest request = new  WS_RetrieveOfficeTasks.OfficeTasksRequest();
        List<WS_RetrieveOfficeTasks.OfficeTasksResponse> responseList = new  List<WS_RetrieveOfficeTasks.OfficeTasksResponse>();
    
          request.numberOfTasks = '50';
          request.countOfTasksRequired = 'true';
          request.associateId = 'OFTA01';
          request.dueDate = '10/25/2012';
          request.lastModifiedTimestamp = '2012-10-25T08:52:14.000Z';
          request.requestPreviousPage = 'True';
          request.firstTimeRequest = 'False';
        
           responseList = WS_RetrieveOfficeTasks.retrieveOfficeTasks(request);
     }
     
     static testmethod void  webserviceTestNextPage() {
         
        WS_RetrieveOfficeTasks.OfficeTasksRequest request = new  WS_RetrieveOfficeTasks.OfficeTasksRequest();
        List<WS_RetrieveOfficeTasks.OfficeTasksResponse> responseList = new  List<WS_RetrieveOfficeTasks.OfficeTasksResponse>();
    
          request.numberOfTasks = '50';
          request.countOfTasksRequired = 'true';
          request.associateId = 'OFTA01';
          request.dueDate = '10/25/2012';
          request.lastModifiedTimestamp = '2012-10-25T08:52:14.000Z';
          request.requestPreviousPage = 'False';
          request.firstTimeRequest = 'False';
        
           responseList = WS_RetrieveOfficeTasks.retrieveOfficeTasks(request);
     }
}