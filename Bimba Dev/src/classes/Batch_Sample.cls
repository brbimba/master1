global class Batch_Sample implements Database.Batchable<Account>
{
   
    
    
   global Iterable<Account> start(Database.BatchableContext BC)
    {     
         return new sampleIterator() ;
    }
    
    
    global void execute(Database.BatchableContext BC,List<Account> scope)
    {    
       //execute logic
    
   }
    global void finish(Database.BatchableContext BC)
    {   
      
    }    
}