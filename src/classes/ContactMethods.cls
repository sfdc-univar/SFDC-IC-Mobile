public with sharing class ContactMethods 
{
	public static void ContactProcess(List<Contact> objects, Map<Id, Contact> oldMap, Boolean bInsert)
	{
		Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
	    String ThisUser = UserInfo.getUserId();
	          
	    // Loop through the incoming records
	    for (Contact obj : objects) 
	    {
      		//1. SAVE USER-LAST-MODIFIED INFO (When a non-SysAdmin updates a record)            
            if (p.name.Contains('Sys'))  {  //System Admin
                if(bInsert) { //Blank out the fields in case the insert was caused by a clone, 	 	    	
	 	            obj.UserLastModifiedBy__c = null;
	                obj.UserLastModifiedDate__c = null;
	            }// If SysAdmin inadvertently updated one of the fields, undo it
	            else if (obj.UserLastModifiedDate__c <> oldMap.get(obj.id).UserLastModifiedDate__c 
	                     || obj.UserLastModifiedBy__c <> oldMap.get(obj.id).UserLastModifiedBy__c)  
             	{   obj.UserLastModifiedBy__c = oldMap.get(obj.id).UserLastModifiedBy__c;
	                obj.UserLastModifiedDate__c = oldMap.get(obj.id).UserLastModifiedDate__c;
	            }            
	        //Non-SysAdmin - always update the fields                                
	        } else {   
	            obj.UserLastModifiedBy__c = ThisUser;
	            obj.UserLastModifiedDate__c = datetime.now();
	        }
            
            //2. FIX STATE & COUNTRY
            // When maintained through API --> update from alternate fields & custom settings 
            String oldIntegratedMailingCountry;
            String oldIntegratedMailingState;  
            String oldIntegratedOtherCountry;
            String oldIntegratedOtherState;  
            if (!bInsert) {
                oldIntegratedMailingCountry = oldmap.get(obj.id).IntegratedMailingCountry__c;
                oldIntegratedMailingState = oldmap.get(obj.id).IntegratedMailingState__c;
                oldIntegratedOtherCountry = oldmap.get(obj.id).IntegratedOtherCountry__c;
                oldIntegratedOtherState = oldmap.get(obj.id).IntegratedOtherState__c;
            }            
            
            obj.MailingCountryCode= SharedMethods.getCountry(oldIntegratedMailingCountry,obj.IntegratedMailingCountry__c, obj.MailingCountryCode);  
            obj.MailingStateCode= SharedMethods.getState(oldIntegratedMailingState,obj.IntegratedMailingState__c,oldIntegratedMailingCountry,obj.IntegratedMailingCountry__c, obj.MailingCountryCode,obj.MailingStateCode);  
            obj.OtherCountryCode= SharedMethods.getCountry(oldIntegratedOtherCountry,obj.IntegratedOtherCountry__c, obj.OtherCountryCode);  
            obj.OtherStateCode= SharedMethods.getState(oldIntegratedOtherState,obj.IntegratedOtherState__c,oldIntegratedOtherCountry,obj.IntegratedOtherCountry__c, obj.OtherCountryCode,obj.OtherStateCode);  

	    }
	}
	
	public static void ContactBeforeInsert(List<Contact> contacts, Map<Id, Contact> oldMap)
	{
		ContactProcess(contacts, oldMap, true);
	}
	
	public static void ContactBeforeUpdate(List<Contact> contacts, Map<Id, Contact> oldMap)
	{
		ContactProcess(contacts, oldMap, false);
	}
}