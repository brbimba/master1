trigger checkSubjectOnCase on Case (before insert) {
    for(case cs : trigger.new){
        if(cs.subject == null) {
            cs.addError('Subject cannot be empty');
        }
    }        
}