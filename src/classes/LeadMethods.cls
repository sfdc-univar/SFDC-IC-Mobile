public with sharing class LeadMethods{
    
       public static void LeadProcess(List<Lead> objs, Map<Id, Lead> oldMap, Boolean bInsert){
  
        // Loop through the incoming records
        for (Lead obj : objs)  {
                    
           //FIX COUNTRY BASED ON LOOKUP TO CUSTOM SETTING      
            String oldIntegratedCountry;
            String oldIntegratedState;            
            if (!bInsert) {
                oldIntegratedCountry = oldmap.get(obj.id).IntegratedCountry__c;
                oldIntegratedState = oldmap.get(obj.id).IntegratedState__c;
            }              
            obj.CountryCode= SharedMethods.getCountry(oldIntegratedCountry,obj.IntegratedCountry__c, obj.CountryCode);              
            obj.StateCode= SharedMethods.getState(oldIntegratedState,obj.IntegratedState__c,oldIntegratedCountry,obj.IntegratedCountry__c, obj.CountryCode,obj.StateCode);  

			/*
            system.debug('Code values at end of this update:');
            system.debug('Standard Codes:' + obj.CountryCode + ', ' + obj.StateCode);
            system.debug('Integrated Values: ' + obj.IntegratedCountry__c + ', ' + obj.IntegratedState__c); 
            system.debug('Integrated Codes: ' + obj.IntegratedCountryCode__c + ', ' + obj.IntegratedStateCode__c);
            system.debug('*** DONE WITH THIS UPDATE to ' + obj.Name + ' ***');
            */
        }
   }
  
  public static void LeadBeforeInsert(List<Lead> leads, Map<Id, Lead> oldMap)
  {
    LeadProcess(leads, oldMap, true);
  }
  
  public static void LeadBeforeUpdate(List<Lead> leads, Map<Id, Lead> oldMap)
  {      
    LeadProcess(leads, oldMap, false);   
  }


}