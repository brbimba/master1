trigger checkProductSpecialtyOnCase on Case (before insert) {
/*
    Map<String,User> agentsBySpecialty = new Map<String, User>();
    
    for(User usr : [Select Id,ProductSpecialty__c from User where Profile.Name = 'Administrator']){
        agentsBySpecialty.put(usr.ProductSpecialty__c,usr);
    }
    for(Case cs : trigger.new) {
        if(cs.Product__c!=  null){
            User usr = agentsBySpecialty.get(cs.Product__c);
            cs.OwnerId = usr.Id;
        }
    } */       
}