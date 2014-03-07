public Class AddressStdResponse {
    
    public String statusCode; 
    public String messages ; 
    public Addresses address ;
    
    
    public Class Addresses{
        public String[] Street ;
        public String city ;
        public String State ;
        public String ZipCode;
    }
}