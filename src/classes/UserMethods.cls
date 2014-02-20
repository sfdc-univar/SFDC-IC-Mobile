public with sharing class UserMethods{
    
     public static void UserProcess(List<User> objs, Map<Id, User> oldMap, Boolean bInsert){

         //Get Trigger control to determine which parts of code will execute
         Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
         String ManagerPerNr;
         
        // Loop through the incoming records
        for (User obj : objs)  {
                    
           // UPDATE FIELDS NOT UPDATED BY GIAM:
            
           //1. COUNTRY & STATE - GIAM has to update the "Integrated" versions since they use non-standard values. Then this code
            // looks up valid values in Custom Settings
            String oldIntegratedCountry;
            String oldIntegratedState;            
            if (!bInsert) {
                oldIntegratedCountry = oldmap.get(obj.id).IntegratedCountry__c;
                oldIntegratedState = oldmap.get(obj.id).IntegratedState__c;
            }                        
            obj.CountryCode= SharedMethods.getCountry(oldIntegratedCountry,obj.IntegratedCountry__c, obj.CountryCode);              
            obj.StateCode= SharedMethods.getState(oldIntegratedState,obj.IntegratedState__c,oldIntegratedCountry,obj.IntegratedCountry__c, obj.CountryCode,obj.StateCode);  
            
           //2. A couple permissions that GIAM doesn't update - Offline & Mobile Users            
			if (TC.Giam_Trigger__c == true) {    
           		Profile[] pr = [Select Id, UserType, UserLicenseId From Profile WHERE Id = :obj.ProfileId];
    			//Only update Standard User - Chatter Users type = CsnOnly
    			if(pr[0].UserType == 'Standard'){
        			obj.UserPermissionsOfflineUser = true;
        			obj.UserPermissionsMobileUser = true;
        		}
            }
            
            //3. Update User's Manager, from the Manager PerNr sent over from GIAM            
			if (TC.User_s_Manager__c == true) {    
          		ManagerPerNr = obj.ManagerPerNr__c;
        		if(ManagerPerNr != null){
        			User[] man = [Select PerNr__c, Id From User WHERE PerNr__c =: ManagerPerNr ];
        			if(man.size() > 0){
        				obj.ManagerId = man[0].Id;
                    } else {
                        obj.ManagerPerNr__c.addError('Invalid Manager PerNr');
                    }
                }
            }
        }
    }

 public static void UserAfterProcess(List<User> objs, Map<Id, User> oldMap, Boolean bInsert){

         //Get Trigger control to determine which parts of code will execute
         Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
                  
        // Loop through the incoming records
        for (User obj : objs)  {
            
            system.debug('trigger control: ' + TC.Check_Duplicate_Alias__c);
        	if (TC.Check_Duplicate_Alias__c == true) {    
                system.debug('says trigger control is true');
             	system.debug('Alias: ' + obj.Alias);
          		//xxxxx alias created from GIAM is OK to have duplicates. Others are not OK.
        		if(obj.Alias != 'xxxxx'){
         			//If count is greater than 1 there is a duplicate.  After insert includes the current User alias                    
       				Integer i = [ select count() from User where Alias = :obj.Alias];                   
                    system.debug('Number of users with this alias: ' + i);
                    if (i > 1){
              	  		obj.alias.addError('A User with this Alias already exists!');
               		}   
                }
         	}
        }
    }
  
  public static void UserBeforeInsert(List<User> users, Map<Id, User> oldMap)
  {
    UserProcess(users, oldMap, true);
  }
  
  public static void UserBeforeUpdate(List<User> users, Map<Id, User> oldMap)
  {
    UserProcess(users, oldMap, false);   
  }

  public static void UserAfterInsert(List<User> users, Map<Id, User> oldMap)
  {
    UserAfterProcess(users, oldMap, true);
  }
  
  public static void UserAfterUpdate(List<User> users, Map<Id, User> oldMap)
  {
    UserAfterProcess(users, oldMap, false);   
  }
}