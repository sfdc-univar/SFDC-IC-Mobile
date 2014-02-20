@istest(SeeAllData=true)

public with sharing  class Lead_Tests{
    
    public static testMethod void testStateAndCountry_Lead(){
        
        
        //Create Lead without the "Integrated" State & Country fields. This tests how leads are created in the UI,
        //  and tests the first logic branch in getState and getCountry methods when called for Leads
       //system.debug('************************************************************************************');
       //system.debug('TEST1: Insert, with default values (US, no state)');
       Lead l1 = UnitTestHelper.createLead('Lead Co 1', 'f1', 'l1');
       System.assert(UnitTestHelper.leadSaveSuccess);       
       Lead l1a = [select id, CountryCode, StateCode from Lead where Id = :l1.Id];
       system.Assertequals(l1a.CountryCode,'US');
       system.AssertEquals(l1a.StateCode,null);
       
       //Update Integrated Country & State to valid values
        //system.debug('************************************************************************************');
        //system.debug('TEST2: Update to valid values that will be found on Custom Settings');
       l1a.IntegratedCountry__c = 'Mexico';
       l1a.IntegratedState__c = 'Colima';        
       update l1a;
       Lead l2 = [select id, CountryCode, StateCode from Lead where Id = :l1.Id];
       system.Assertequals(l2.CountryCode,'MX');
       system.AssertEquals(l2.StateCode,'CL');
              
       //Update Integrated Country & State to invalid values --> default to US, no state
       //system.debug('************************************************************************************');
       //system.debug('TEST3: Insert with invalid values --> should default to US, no state');
       Lead l3 = new Lead(FirstName = 'fn2', LastName='ln2', Company = 'Co2', 
                     IntegratedCountry__c = 'ZZZZYYYYYASDFfa');
       Database.Saveresult saveResult = Database.insert (l3);
       System.assert(saveResult.isSuccess());       
       //system.Assertequals(l3.CountryCode,'US');
       system.AssertEquals(l3.StateCode,null);
        
        //Update State back to a valid values
       //system.debug('************************************************************************************');
       //system.debug('TEST4: Update back to valid state');
       l3.IntegratedState__c = 'WA';
       update l3;
       Lead l4 = [select id, CountryCode, StateCode from Lead where Id = :l3.Id];
       system.Assertequals(l4.CountryCode,'US');
       system.AssertEquals(l4.StateCode,'WA');
       
       //Null out country & state --> defaults back to US, no state
       //system.debug('************************************************************************************');
       //system.debug('TEST5: Null out country & state --> should default to US, no state');
       l4.IntegratedCountry__c = '';
       l4.IntegratedState__c = '';
       update l4;
       Lead l5 = [select id, CountryCode, StateCode from Lead where Id = :l4.Id];
       system.Assertequals(l5.CountryCode,'US');
       system.AssertEquals(l5.StateCode,null);
        
    }

}