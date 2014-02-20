public with sharing class AccountMethods 
{
	public static void AccountProcess(List<Account> objects, Map<Id, Account> oldMap, Boolean bInsert)
	{
		Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
	    String ThisUser = UserInfo.getUserId();        
	          
	    // Loop through the incoming records
	    for (Account obj : objects)       {
            
            //1. UPDATE OWNER LINK IF OWNER HAS CHANGED           
        	if (obj.OwnerID != obj.OwnerLink__c) {
            	obj.OwnerLink__c = obj.OwnerId;
        	}
            
            //2. SAVE USER-LAST-MODIFIED INFO (When a non-SysAdmin updates a record)
            
     	    if (p.name.Contains('Sys')) { // System Admin           
             if(bInsert)  { //Blank out the fields in case the insert was caused by a clone, 
            	obj.UserLastModifiedBy__c = null;
            	obj.UserLastModifiedDate__c = null;
             }// If SysAdmin inadvertently updated one of the fields, undo it
              else if (obj.UserLastModifiedDate__c <> oldMap.get(obj.id).UserLastModifiedDate__c 
                       || obj.UserLastModifiedBy__c <> oldMap.get(obj.id).UserLastModifiedBy__c)  
               { obj.UserLastModifiedBy__c = oldMap.get(obj.id).UserLastModifiedBy__c;
                 obj.UserLastModifiedDate__c = oldMap.get(obj.id).UserLastModifiedDate__c;
               }            
        		//Non-SysAdmin - always update the fields                                
          	} else {   
                obj.UserLastModifiedBy__c = ThisUser;
              	obj.UserLastModifiedDate__c = datetime.now();
          	}
                        
            //3. FIX STATE & COUNTRY
            // When Account maintained through API --> update from alternate fields & custom settings
            //system.debug('******************************');
            //system.debug('*** STARTING UPDATE ***');
            String oldBillingCountryCode;
            String oldShippingCountryCode;
            String oldBillingStateCode;
            String oldShippingStateCode;
            String oldIntegratedBillingCtry;
            String oldIntegratedBillingState;  
            String oldIntegratedShippingCtry;
            String oldIntegratedShippingState;  
            String oldIntegratedBillingCtryCd;
            String oldIntegratedBillingStateCd;  
            String oldIntegratedShippingCtryCd;
            String oldIntegratedShippingStateCd; 
            if (!bInsert) {   //on an Insert these fields remain null. This lets us compare old & new on Inserts as well as Updates.
                oldBillingCountryCode = oldmap.get(obj.id).BillingCountryCode;
                oldBillingStateCode = oldmap.get(obj.id).BillingStateCode;
                oldShippingCountryCode = oldmap.get(obj.id).ShippingCountryCode;
                oldShippingStateCode = oldmap.get(obj.id).ShippingStateCode;
                oldIntegratedBillingCtry = oldmap.get(obj.id).IntegratedBillingCtry__c;
                oldIntegratedBillingCtryCd = oldmap.get(obj.id).IntegratedBillingCtryCd__c;
                oldIntegratedBillingState = oldmap.get(obj.id).IntegratedBillingState__c;
                oldIntegratedBillingStateCd = oldmap.get(obj.id).IntegratedBillingStateCd__c;
                oldIntegratedShippingCtry = oldmap.get(obj.id).IntegratedShippingCtry__c;
                oldIntegratedShippingCtryCd = oldmap.get(obj.id).IntegratedShippingCtryCd__c;
                oldIntegratedShippingState = oldmap.get(obj.id).IntegratedShippingState__c;
                oldIntegratedShippingStateCd = oldmap.get(obj.id).IntegratedShippingStateCd__c;
            }  
            
            //On all the following:  
            // - If Integration provides the actual code value, use it (from nightly integration only)
            // - Otherwise, if any other integration maps country to the Integrated Country field, then use the Custom Settings lookup
            //     (could apply to DataLoader or DemandTools that uses this mapping; Lead conversion to Prospect; etc)
            //system.debug('oldBillingCountryCode: ' + oldBillingCountryCode + ', OldIntBCC: ' + oldIntegratedBillingCtryCd + ', IntBCC: ' + obj.IntegratedBillingCtryCd__c);
            if (oldIntegratedBillingCtryCd <> obj.IntegratedBillingCtryCd__c) { 
               if (obj.IntegratedBillingCtryCd__c == null) {                    
               		obj.BillingCountryCode = 'US';  //Integration blanking out country
               } else {                    
            		obj.BillingCountryCode = obj.IntegratedBillingCtryCd__c;  //Integration changing to another country
               }
            } else {                
                obj.BillingCountryCode= SharedMethods.getCountry(oldIntegratedBillingCtry,obj.IntegratedBillingCtry__c, obj.BillingCountryCode);  
            }
            
            if(oldBillingStateCode <> obj.IntegratedBillingStateCd__c) {
                obj.BillingStateCode = obj.IntegratedBillingStateCd__c;
            } else {
                obj.BillingStateCode= SharedMethods.getState(oldIntegratedBillingState,obj.IntegratedBillingState__c,oldIntegratedBillingCtry,obj.IntegratedBillingCtry__c, obj.BillingCountryCode,obj.BillingStateCode);  
            }

            //Shipping Country            
            //system.debug('oldShippingCountryCode: ' + oldShippingCountryCode + ',  OldIntSCC: ' + oldIntegratedShippingCtryCd + ', IntSCC: ' + obj.IntegratedShippingCtryCd__c);
            if (oldIntegratedShippingCtryCd <> obj.IntegratedShippingCtryCd__c) {
               if (obj.IntegratedShippingCtryCd__c == null) {
               		obj.ShippingCountryCode = 'US';  //Integration blanking out country
               } else {                    
            		obj.ShippingCountryCode = obj.IntegratedShippingCtryCd__c;  //Integration changing to another country
               }
            } else {                
                obj.ShippingCountryCode= SharedMethods.getCountry(oldIntegratedShippingCtry,obj.IntegratedShippingCtry__c, obj.ShippingCountryCode);  
            }
            
        	// Shipping State
            if(oldIntegratedShippingStateCd <> obj.IntegratedShippingStateCd__c) {
                obj.ShippingStateCode = obj.IntegratedShippingStateCd__c;
            } else {
                obj.ShippingStateCode= SharedMethods.getState(oldIntegratedShippingState,obj.IntegratedShippingState__c,oldIntegratedShippingCtry,obj.IntegratedShippingCtry__c, obj.ShippingCountryCode,obj.ShippingStateCode);  
            }
            /*
            system.debug('Code values at end of this update:');
            system.debug('Billing Codes, Std:' + obj.BillingCountryCode + ', ' + obj.BillingStateCode);
            system.debug('Shipping Codes, Std: ' + obj.ShippingCountryCode + ', ' + obj.ShippingStateCode);
            system.debug('Integrated Billing Values: ' + obj.IntegratedBillingCtry__c + ', ' + obj.IntegratedBillingState__c);            
            system.debug('Integrated Shipping Values: ' + obj.IntegratedShippingCtry__c + ', ' + obj.IntegratedShippingState__c);
            system.debug('Integrated Billing Codes: ' + obj.IntegratedBillingCtryCd__c + ', ' + obj.IntegratedBillingStateCd__c);
            system.debug('Integrated Shipping Codes: ' + obj.IntegratedShippingCtryCd__c + ', ' + obj.IntegratedShippingStateCd__c);
            system.debug('*** DONE WITH THIS UPDATE to ' + obj.Name + ' ***');
            */
	    }
	}
	
	public static void AccountBeforeInsert(List<Account> accounts, Map<Id, Account> oldMap)
	{
		AccountProcess(accounts, oldMap, true);
	}
	
	public static void AccountBeforeUpdate(List<Account> accounts, Map<Id, Account> oldMap)
	{
		AccountProcess(accounts, oldMap, false);
	}
}