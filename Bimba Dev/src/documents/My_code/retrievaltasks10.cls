global class WS_UpdateTask {
	
	global class updateTaskResponse{
		webservice string taskid;
		webservice boolean success;
		webservice string message;
	}
	
	global class insertCustomer{
		webservice string prefix;
		webservice string FirstName;
		webservice string preferredFirst;
		webservice string middleName;
		webservice string lastName;
		webservice string suffix;
	//	webservice string designation;
		webservice string phoneType;
		webservice string phone;
		webservice string phoneExtenstion;
		webservice string Email;
	}
	
	global class updateTask{
		webservice string remark;
		webservice string associateId;
		webservice string relatedToId;
		webservice string relatedToType;
		webservice string activityIdentifier;
		
		webservice string taskId;
		webservice DateTime dueDate;
		webservice string priority;
		webservice string category;
		webservice date completionDate;
		webservice date taskDeadline;
		webservice string applicationCode;
		webservice string status;
		webservice string taskType; // we are not changing recordtype
		webservice string subject;
		webservice string callerType;
		webservice string contactMethod;
		webservice string negativeFeedback;
		webservice string activitySource;
		webservice string lineOfBusiness;
		webservice string product;		
		webservice string workItemName;
		webservice string workflowID;
		webservice string parameters;			
	}
	/*webservice static updateTaskResponse updTask (Task tsk, updateTask upd ){
		
		//tsk.ActivityIdentifier__c = upd.activityIdentifier;
		Task tsk1 = [Select WorkflowID1__c, WorkItem1__c, WhoId, WhatId, Type, TaskDeadline__c, 
		SystemModstamp, Subject, Status, Section__c, Report__c, ReminderDateTime, RecurrenceType, 
		RecurrenceTimeZoneSidKey, RecurrenceStartDateOnly, RecurrenceMonthOfYear, RecurrenceInterval, 
		RecurrenceInstance, RecurrenceEndDateOnly, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, 
		RecurrenceActivityId, RecordTypeId, Product1__c, Priority, 
		Parameters1__c, OwnerId, LastModifiedDate, LastModifiedCounter__c, LastModifiedById, IsReminderSet,
		IsRecurrence, IsDeleted, IsClosed, IsArchived, Id, GeographicLocation__c, 
		ExternalTaskIdentifier__c, Description, CreatedDate, CreatedById, CreateApplication__c, 
		ContactMethod__c, CompletionDate__c, ComplaintType__c, Category__c, CallerType__c, CallType, 
		CallObject, CallDurationInSeconds, CallDisposition, CCCPriority__c, BusinessLine__c,
		BusinessLine1__c, BOD__c, AppliedSMP__c, ApplicationCode__c, AgentOffice__c, ActivitySource__c, 
		ActivityIdentifier__c, ActivityDate, AccountId From Task where ActivityIdentifier__c =: upd.activityIdentifier];
	
		tsk1.OwnerId = upd.associateId;
		    				
		if(upd.dueDate == null){
			 tsk1.ActivityDate = tsk1.ActivityDate;
		} else {
			tsk1.ActivityDate = date.valueOf(upd.dueDate);
		}			
				
		if (upd.Priority == ''){
			tsk1.Priority = tsk1.Priority ;
		} else {
			tsk1.priority = upd.Priority;
		}
		
		if (upd.Category == ''){
			tsk1.Category__c = tsk1.Category__c;
		} else if (upd.category.trim() == ''){
			tsk1.Category__c = null;
		} else{
			tsk1.Category__c = upd.Category;
		}											
		
		if(upd.CompletionDate == null){
			tsk1.CompletionDate__c = tsk1.CompletionDate__c;	
		} else{
			tsk1.CompletionDate__c = upd.CompletionDate;
		}
		
		if(upd.taskDeadline == null){
			tsk1.TaskDeadline__c = tsk1.TaskDeadline__c;
		} else{
			tsk1.TaskDeadline__c = upd.TaskDeadline;
		}
		
		if(upd.ApplicationCode == ''){
			tsk1.ApplicationCode__c = tsk1.ApplicationCode__c;			
		} else if(upd.applicationCode.trim() == ''){
			tsk1.ApplicationCode__c = null;
		} else{
			tsk1.ApplicationCode__c = upd.ApplicationCode;
		}
		
		if(upd.Status == ''){
			tsk1.Status = tsk1.Status;
		} else{
			tsk1.Status = upd.Status;
		}
		
		if(upd.Subject == ''){
			tsk1.Subject = tsk1.Subject;
		} else{
			tsk1.Subject = upd.Subject;
		}
		
		if(upd.CallerType == ''){
			tsk1.CallerType__c = tsk1.CallerType__c;
		} else if(upd.CallerType.trim() == ''){
			tsk1.CallerType__c = null;
		} else{
			tsk1.CallerType__c = upd.CallerType;
		}
		
		if(upd.ContactMethod == ''){
			tsk1.ContactMethod__c = tsk1.ContactMethod__c;
		} else if(upd.ContactMethod.trim() == ''){
			tsk1.ContactMethod__c = null;
		} else{
			tsk1.ContactMethod__c = upd.ContactMethod;
		}
		
		if(upd.NegativeFeedback == ''){
			tsk1.ComplaintType__c = tsk1.ComplaintType__c;
		} else if (upd.negativeFeedback.trim() == ''){
			tsk1.ComplaintType__c = null;
		} else{
			tsk1.ComplaintType__c = upd.NegativeFeedback;
		}
		
		if(upd.ActivitySource == ''){
			tsk1.ActivitySource__c = tsk1.ActivitySource__c;
		} else if(upd.ActivitySource.trim() == ''){
			tsk1.ActivitySource__c = null;	
		} else{
			tsk1.ActivitySource__c = upd.ActivitySource;
		}
					
		if (upd.lineofBusiness == ''){
	    	tsk1.BusinessLine1__c = tsk1.BusinessLine1__c;         
	    } else if(upd.lineofBusiness.trim() == ''){
	    	tsk1.BusinessLine1__c = null;
	    } else{           
	    	tsk1.BusinessLine1__c = upd.lineOfBusiness;         
	    }         
	    
	    if (upd.Product == ''){            
	    	tsk1.Product1__c = tsk1.Product1__c;         
	    } else if (upd.Product.trim() == ''){
	    	tsk1.Product1__c = null;
	    } else{            
	    	tsk1.Product1__c = upd.Product;         
	    }                  	    
	    	    	               	        
	    if (upd.workItemName == ''){            
	    	tsk1.WorkItem1__c = tsk1.WorkItem1__c;         
	    } else if (upd.workItemName.trim() == '' ){
	    	tsk1.WorkItem1__c = null;
	    } else{            
	    	tsk1.WorkItem1__c = upd.workItemName;         
	    }                  
	    
	    if (upd.workflowID == ''){            
	    	tsk1.WorkflowID1__c = tsk1.WorkflowID1__c;         
	    } else if (upd.workflowID.trim() == ''){
	    	tsk1.WorkflowID1__c = null;
	    } else{            
	    	tsk1.WorkflowID1__c = upd.workflowID;         
	    }                  
	    
	    if (upd.parameters == ''){            
	    	tsk1.Parameters1__c = tsk1.Parameters1__c;         
	    } else if (upd.parameters.trim() == '') {
	    	tsk1.Parameters1__c = null;
	    } else{            
	    	tsk1.Parameters1__c = upd.parameters;         
	    }                  
	    	
	    
	   	/*tsk.OwnerId = Utils_Integration.queryUserbyAssociateId(associateId).id;
		tsk.RecordTypeId = Utils_Integration.getTaskRecordTypeIdbyName(taskType);
		tsk.WhoId = Utils_Integration.getTaskWhoId(whoId, whoType);
		tsk.WhatId = Utils_Integration.getTaskWhatid(whatId, whatType);
		*/
		
		/*//upsert tsk task.fields.ActivityIdentifier__c;
		update tsk1;
		
		if(upd.Remark != null ){
			Remark__c rem = new Remark__c();
			rem.Remark__c = upd.Remark;
			rem.TaskIdentifier__c = tsk.Id;
			rem.ExternalIdentifier__c = tsk.ExternalTaskIdentifier__c;
			insert rem;
			update tsk1;
			
		}
		
		updateTaskResponse resp = new updateTaskResponse();
		resp.taskid = tsk.ExternalTaskIdentifier__c;
		return resp;
	}*/
	
	
}