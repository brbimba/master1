/*
    *   @Class Description This class has all the queries used in retrieve office tasks to fetch user, customer etc records.
    *   @Author Munazah Manzoor
    *   @Date   01/09/2013  
  */
public class WS_RetrieveOfficeTasksHelper{
/*  
        @Method <This   method takes associateID as input and retrieves the corresponding user record and we form the userrolename and parentuserid>
        @param  <String associateId>
        @return Task[]>    
        @throws exception   -   <throws an exception when no records will be fetched> 
    */   
    public static Task[] associateIds(String associateId){
        /*
        
        Part 1
        The first part of the query takes the associate id that is passed into SFDC. 
        We then retrieve the User for that associateID and take UserRole Name.
        
        The Role Heirarchy Naming Convention will be 'AssociaiteId' + 'name of Agent' + ....
        
        We store the userRoleName in a string variable called URoleName. The URoleName will be trimmed based on the 
        naming convention of the Roles in SFDC. 
        
        The string ParentUserId is a string variable that will hold the associateId of the Agent in the office. 
        This will be trimmed from the Role Name.
        */

        User usr = [SELECT Id, UserType__c, UserRoleId, UserRole.Name, AssociateIdentifier__c 
                     FROM User 
                     WHERE AssociateIdentifier__c = :associateId];
       
        string URoleName = usr.UserRole.Name.substring(0, 11)+'%';
        string ParentUserId = usr.UserRole.Name.substring(0,11);
               
        /*
        Group users in the role heirarchy and users in shared staff into a list.
        */
        
        //find all users in the role hierarchy
        
        List<id> roleHeirarchyUser = new List <id>();
        list<User> u = [SELECT id 
                        FROM User 
                        WHERE UserRole.Name like: URoleName];
        for(User usr1:u)
        roleHeirarchyUser.add(usr1.id);
   
        //Find all shared staff querying the Hierarchy Relationship table based off the ParentUserId. 
        List<Id> childIds = new List<Id>();
        list<HierarchyRelationship__c> hr = [SELECT Child__c 
                                              FROM HierarchyRelationship__c 
                                              WHERE Parent__r.AssociateIDExternal__c =: ParentUserId AND IsPrimary__c = false ];
           
        for(HierarchyRelationship__c hr1:hr)
        childIds.add(hr1.Child__c);
        
        try{                
        //Combing all primary and shared staff users into one list.
        List <id> officeTaskUser = new List <id>();
        officeTaskUser.addall(childIds);
        officeTaskUser.addall(roleHeirarchyUser);
             
        // Find all task for the office, but do not filter out the customer yet.
        list<Task> tListPart1 = [SELECT Id, AccountId, Owner.UserRole.Name, whoId, WhatId, type, status 
                                  FROM Task 
                                  WHERE OwnerId IN: officeTaskUser ];
       
        /* Get all the customers from the tListPart1 and find all customers for the office querying the AgentRole. 
        By doing this we will not run into governor limits. An Agent can have up to 72K customers at a time.
        
        */
        
        List<id> accountId = new List <id>();
        for(Task tempTaskAccount : tListPart1){
            accountId.add(tempTaskAccount.AccountId);
        }
        if(accountId.size()==0) throw new ApexException();
                
        List<AgentRole__c> AgentRoleList = [SELECT customer__c 
                                             FROM AgentRole__c 
                                             WHERE Agent__r.UserRole.Name like :URoleName AND Customer__c IN: accountId];           
        
        list<Id> customerIdList = new list<Id>();
        for(AgentRole__c tempAgentRole: AgentRoleList){
            customerIdList.add(tempAgentRole.customer__c);
        }
        
        If (customerIdList.size()==0) throw new ApexException();
        
        // Find all tasks for the office and filter out only for customers that are owned by the office. Final Task List.
            list<Task> finalTask = [SELECT Id, AccountId, Owner.UserRole.Name, whoId, WhatId, type, status 
                                     FROM Task 
                                     WHERE OwnerId IN: officeTaskuser and AccountId in: customerIdList];              
            
            return finalTask ;
                           
        }catch(Exception e){
            throw new ApexException('No records found');
        }
        
         
    }
}