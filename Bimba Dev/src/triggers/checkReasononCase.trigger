trigger checkReasononCase on Case (before insert) {
    for(Case cs : trigger.new) {
        if (cs.reason == 'Feedback'){    
            cs.priority = 'Low';
        }
    }    
}