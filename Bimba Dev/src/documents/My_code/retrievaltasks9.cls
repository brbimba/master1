/*         
 Author          : Accenture IDC Team          
 Date Created    : 10/29/2012          
 Description     : Test Class for Webservice class WS_RetrieveTaskDetails 
*/

@istest (SeeAllData=true)
    public class WS_RetrieveTaskDetails_Test{
    
        /*  
            @Method <Method to test web service class for valid input parameters>            
            @param <Not Taking any Parameters>            
            @return <Method does not return any value>           
        */
        
        static testmethod void webservicetest_validinput(){
            
            WS_RetrieveTaskDetails.TaskDetailsRequest req = new  WS_RetrieveTaskDetails.TaskDetailsRequest();
            WS_RetrieveTaskDetails.TaskDetailsResponse resp = new  WS_RetrieveTaskDetails.TaskDetailsResponse();
            
            /* Initialising request parameters */
            req.taskId = '27974404';
            req.timeZone = 'PST';
                
            resp = WS_RetrieveTaskDetails.RetrieveTaskDetail(req);
        }
        
        /*  
            @Method <Method to test web service class for null input parameters>            
            @param <Not Taking any Parameters>            
            @return <Method does not return any value>           
        */
        
        static testmethod void webservicetest_nullinput(){
        
            WS_RetrieveTaskDetails.TaskDetailsRequest req = new  WS_RetrieveTaskDetails.TaskDetailsRequest();
            WS_RetrieveTaskDetails.TaskDetailsResponse resp = new  WS_RetrieveTaskDetails.TaskDetailsResponse();
            
            /* Initialising request parameters */    
            req.taskId = '';
            req.timeZone = '';
                
            resp = WS_RetrieveTaskDetails.RetrieveTaskDetail(req);    
        }
        
        /*  
            @Method <Method to test web service class for invalid input parameters>            
            @param <Not Taking any Parameters>            
            @return <Method does not return any value>           
        */
        
        static testmethod void webservicetest_invalidinput() {
            
            WS_RetrieveTaskDetails.TaskDetailsRequest req = new  WS_RetrieveTaskDetails.TaskDetailsRequest();
            WS_RetrieveTaskDetails.TaskDetailsResponse resp = new  WS_RetrieveTaskDetails.TaskDetailsResponse();
            
            /* Initialising request parameters */    
            req.taskId = '&**23';
            req.timeZone = 'ABC';
                
            resp = WS_RetrieveTaskDetails.RetrieveTaskDetail(req);
        
        } 
    }