public with sharing class HomeController {

    public string strDocUrl{get;set;}
    public HomeController ()
    {

        try
        {
            List<Document> FirstDocument = [SELECT Id,Name FROM Document WHERE Name = 'retrievaltasks4' LIMIT 1];
            string strOrgId = UserInfo.getOrganizationId();
          strDocUrl = '/servlet/servlet.FileDownload?file='+FirstDocument[0].Id;
          
        }
        catch (Exception e) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error in getDocumentLogoUrl() ' + e.getMessage()));
            System.debug('Error: ' + e.getMessage());
          }
        System.debug('The URL is ' + strDocUrl);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The URL returned is ' + strDocUrl));   

  }
}