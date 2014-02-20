public with sharing class EventMethods 
{
	public static void UpdateUserAndDate(List<Event> objects, Map<Id, Event> oldMap, Boolean bInsert)
	{
		// When a non-SysAdmin updates a record, save their info
 
		Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
	    String ThisUser = UserInfo.getName();
	          
	    // Loop through the incoming records
	    for (Event obj : objects) 
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
	
	public static void EventBeforeInsert(List<Event> events, Map<Id, Event> oldMap)
	{
		UpdateUserAndDate(events, oldMap, true);
	}
	
	public static void EventBeforeUpdate(List<Event> events, Map<Id, Event> oldMap)
	{
		UpdateUserAndDate(events, oldMap, false);
	}
}