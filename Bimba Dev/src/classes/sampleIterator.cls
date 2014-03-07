global class sampleIterator implements iterable<Account>{
   global Iterator<Account> Iterator(){
      return new CustomIterable();
   }
}