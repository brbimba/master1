global class WS_CreateTask {

	global class createTaskResponseSFDC{
		webservice string taskid;
		webservice boolean success;
		webservice string message; 
	}
	
	global class createTaskReq {
		webservice string taskType;
		webservice string associateId;
		webservice string customerId;
		webservice string customerType;
		webservice string relatedToId;
		webservice string relatedToType;
		webservice string relatedToTypeExternalField;
		
	}
	
	 public static String getTaskRecordTypeIdbyName( String taskType ) { 
    
   /* 
	@Method <This method returns record type Id for a particular record type ID>
	@param <recordTypeId,
	@return <String> 
	@throws exception - <Exception will be handled in the place where the function is called>   
   */ 
		
		RecordType recType = [select id from RecordType where RecordType.Name =: TaskType];
		return recType.Id;
   }
   
   /*
	@ Method <this method returns the Contact Id or Lead Id for a particular record to be used for the WhoId in Create/UpdateTask >
	@param <ContactId or LeadId>
	@return <string>
	@throws exception - <Exception will be handled in the place where the function is called>
   */

	public static String getCustId ( String customerId, String customerType ) { 
		//prevent soql injection
		If(customerType == 'Contact'){
			Contact c = [select id from Contact where AccountId IN (select id from Account where ClientIdentifier__c =: customerId)];
			String CustId = c.id;
			return CustId;
		} else {
			Lead l = [select id from Lead where id =: customerId];
			String CustId = l.id;
			return l.id;
		}
		
   }
   
   
   /*
	@ Method <this method returns a list of Customers. There should be only 1 customer due to ClientId is an external id and is unique.>
	@param <CustomerId>
	@return <List>
	@throws exception - <Exception will be handled in the place where the function is called>
   */
   
   public static List<Account> queryAccount (String CustomerId) {
       	List<Account> customerSize = [SELECT Id 
    					FROM Account                                
                        WHERE ClientIdentifier__c =: CustomerId                                  
						];
                          
        return customerSize;
    }
    
    public static String getReltoId (String RelatedToType, String RelatedToId) {
       	
		/*
		Object_Api_Name__c O = [select id, ObjectApi__c, Object_Externa_Id__c from Object_Api_Name__c where ObjectExternalId__c =: relateToType];
		String relatedToObject = o.ObjectApi__c;
		String relatedToExternalField = o.Object_External_Id__c;
		*/
		String relatedToObject = '%' +'ObjecValue' + '%' ;
		String relatedToExternalField = '%' +'ObjectExternalFieldValue' + '%' ;
		String relId = '%' +RelatedToId + '%';
		
		String relToId = 'select id from ' +relatedToObject +' where ' +relatedToExternalField +' =\'' +relId +'\'';
		Database.query(relToId);
		                  
        return ReltoId;
    }
    
    public static String getOwnerId (String associateId) {
       	User u = [select id from User where User.AssociateIdentifier__c =: associateId];
       	String OwnerId = u.id;
        return OwnerId;
            }
	webservice static createTaskResponseSFDC createTaskReq (Task tsk, Account acc, createTaskReq req){
		
		tsk.RecordTypeId = getTaskRecordTypeIdbyName(req.taskType);
		
		//get Customer Size if 0 create skeletal dummy and insert whoId with skeletal dummy, else whoId = clientId.
		Integer intCustSize = Utils_Integration_OnShore.queryAccount(req.CustomerId).size();
		if(intCustSize == 0){
			insert acc;
			Contact c = [select id from Contact where AccountId =: acc.id];
			tsk.WhoId = c.id;
		} else {
			tsk.whoId = getCustId(req.customerId, req.customerType);
		}
		
		tsk.WhatId = getReltoId(req.relatedToType, req.relatedToId);
		tsk.OwnerId = getOwnerId(req.associateId);
		
		insert tsk;
		
		createTaskResponseSFDC resp = new createTaskResponseSFDC();
		resp.success = true;
		resp.taskid = tsk.Id;
		
		return resp;
	}
}