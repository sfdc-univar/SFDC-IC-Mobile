public with sharing class WasteStreamMethods 
{
	public static void UpdateUserAndDate(List<ChemCare__c> objects, Map<Id, ChemCare__c> oldMap, Boolean bInsert)
	{
		// When a non-SysAdmin updates a record, save their info
 
		Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
	    String ThisUser = UserInfo.getUserId();
	          
	    // Loop through the incoming records
	    for (ChemCare__c obj : objects) 
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
	
	public static void WasteStreamBeforeInsert(List<ChemCare__c> wasteStreams, Map<Id, ChemCare__c> oldMap)
	{
		UpdateUserAndDate(wasteStreams, oldMap, true);
	}
	
	public static void WasteStreamBeforeUpdate(List<ChemCare__c> wasteStreams, Map<Id, ChemCare__c> oldMap)
	{
		UpdateUserAndDate(wasteStreams, oldMap, false);
	}
}