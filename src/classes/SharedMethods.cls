public class SharedMethods{
    
     public static String getCountry (String oldIntCountry, String newIntCountry, String newCountryCode) {         
           
        String CountryISO;
        //system.debug('in getCountry, with newIntcountry = ' + newIntCountry + ', oldIntCountry = ' + oldIntCountry + ', newCountryCode = ' + newCountryCode);
         
         if (oldIntCountry == newIntCountry) {
             CountryISO = newCountryCode;  // API no change, or UI w/ or w/o change
             //system.debug('NO INTEGRATED COUNTRY CHANGE - says ' + oldIntCountry + ' = ' + newIntCountry );
         } else {
             //system.debug('INTEGRATED COUNTRY CHANGE - says ' + oldIntCountry + ' <> ' + newIntCountry );
             if (newIntCountry == null) {
                 //system.debug('null - setting to US');
                 CountryISO = 'US';
             } else {
                 system.debug('About to look for ' + newIntcountry.toUpperCase() + ' on CustomCountry');
                string CountryKey = newIntCountry.left(36).trim().touppercase();
                //system.debug('CountryKey: ' + CountryKey);
        	 	CustomCountry__c cc = CustomCountry__c.getValues(CountryKey);
         	 	if (cc == null) {
            		//system.debug(newIntcountry.toUpperCase() + ' not found - setting country code to US');
            		CountryISO = 'US';
         	 	} else {
            		//system.debug(newIntcountry.toUpperCase() + ' found - setting country code to: ' + cc.CountryISOCode__c);
            		CountryISO = cc.CountryISOCode__c;
                }
        	 }
         }
         
        //system.debug('CountryISO at end of getCountry: ' + CountryISO);
        return CountryISO;    
    }

     public static String getState (String oldIntState, String newIntState, String oldIntCountry, String newIntCountry, String CountryISO,  String newStateCode) {          
           
        String StateISO;        
        //system.debug('in getState, with newIntState = ' + newIntState + ', oldIntState = ' + oldIntState + ', newStateCode = ' + newStateCode);
        //system.debug(' more info: CountryISO = ' + CountryISO + ', oldIntCountry = ' + oldIntCountry + ', newIntCountry = ' + newIntCountry);
                 
         if (oldIntState == newIntState && oldIntCountry == newIntCountry) {
             StateISO = newStateCode;  // API no change, or UI w/ or w/o change
             //system.debug('NO CHANGE - says ' + oldIntState + ' = ' + newIntState + ' and '  + oldIntCountry + ' = ' + newIntCountry );
         } else {
             //system.debug('CHANGE - says ' + oldIntState + ' <> ' + newIntState + ' or ' + oldIntCountry + ' <> ' + newIntCountry );
             String StateKey = (CountryISO + '-' + newIntState).toUpperCase();
             //system.debug('StateKey: ' + StateKey);
        	 CustomState__c cs = CustomState__c.getValues(StateKey);
         	 if (cs == null) {            	
                //system.debug(StateKey + ' not found - setting state code to null');
            	StateISO = null;
         	 } else {
            	//system.debug(StateKey + ' found - setting state code to: ' + cs.StateISOCode__c);
            	StateISO = cs.StateISOCode__c;
        	 }
         }
         
        //system.debug('StateISO at end of getState: ' + StateISO);
        return StateISO;    
    }

}