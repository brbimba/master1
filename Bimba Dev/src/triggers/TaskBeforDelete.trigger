trigger TaskBeforDelete on Task (before delete)
{
    for (task t : trigger.old)
    
        if(t.isClosed == true)
        {
            t.addError('Cannot delete a completed task');
        } 
    
}