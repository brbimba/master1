global class CustomIterable 
   implements Iterator<Account>{ 

 Account acc {get; set;}
   Integer i {get; set;} 

   public CustomIterable(){ 
       /*accs = 
       [SELECT Id, Name, 
       NumberOfEmployees 
       FROM Account 
       WHERE Name = 'false']; 
       i = 0; */
   }   

   global boolean hasNext(){ 
   return true;
/*       if(i >= accs.size()) {
           return false; 
       } else {
           return true; 
       }*/
   }    

   global Account next(){ 
           
/*       if(i == 8){return null;} 
       i++; 
       return accs[i-1]; 
    */
    return acc;
    }
}