public with sharing class TaskMethods 
{
	public static void UpdateUserAndDate(List<Task> objects, Map<Id, Task> oldMap, Boolean bInsert)
	{
		// When a non-SysAdmin updates a record, save their info
 
		Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
	    String ThisUser = UserInfo.getName();
	          
	    // Loop through the incoming records
	    for (Task obj : objects) 
	    {
      		// System Admin 
	        if (p.name.Contains('Sys'))  
	        {
		    	if(bInsert) //Blank out the fields in case the insert was caused by a clone, 
	 	    	{ 
	 	            obj.UserLastModifiedBy__c = null;
	                obj.UserLastModifiedDate__c = null;
	            }// If SysAdmin inadvertently updated one of the fields, undo it
	            else if (obj.UserLastModifiedDate__c <> oldMap.get(obj.id).UserLastModifiedDate__c 
	                     || obj.UserLastModifiedBy__c <> oldMap.get(obj.id).UserLastModifiedBy__c)  
             	{
                    obj.UserLastModifiedBy__c = oldMap.get(obj.id).UserLastModifiedBy__c;
	                obj.UserLastModifiedDate__c = oldMap.get(obj.id).UserLastModifiedDate__c;
	            }            
	          
	      //Non-SysAdmin - always update the fields                                
	        } 
	        else 
	        {   
	            obj.UserLastModifiedBy__c = ThisUser;
	            obj.UserLastModifiedDate__c = datetime.now();
	        }
	    }
	}
	
	public static void TaskBeforeInsert(List<Task> tasks, Map<Id, Task> oldMap)
	{
		UpdateUserAndDate(tasks, oldMap, true);
	}
	
	public static void TaskBeforeUpdate(List<Task> tasks, Map<Id, Task> oldMap)
	{
		UpdateUserAndDate(tasks, oldMap, false);
	}
}