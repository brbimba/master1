public with sharing class MyExtension {
    private final Account acct;
    public MyExtension(ApexPages.StandardController controller) {
        this.acct = (Account)Controller.getrecord();
    }
    public String getTitle() {
        return 'Account:'+acct.Name+'('+acct.Id+')';
    }    

}