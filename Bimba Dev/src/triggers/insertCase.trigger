trigger insertCase on Account (after insert) {
 Set<Id> Ids= new Set<Id>();
    for (Account acc : Trigger.new)
    {
        Ids.add(acc.Id);        
    }
 List<Account> accList = new List<Account>([Select Id,samplecopy__c From Account where Id in :Ids]);

    for(Account temp : accList )
    {
        Case cse = new Case();
        cse.samplecopy__c = temp.samplecopy__c;
        insert cse;
    }


 }