@isTest
public class CAPTests
{
     public static testMethod void testCloneCap() 
     {
       Account account = UnitTestHelper.createAccount('Test Account for CAP Testing');
       System.assert(UnitTestHelper.accountSaveSuccess);
       Customer_Account_Plan__c cap = UnitTestHelper.createCap(account);
       System.assert(UnitTestHelper.capSaveSuccess);
       cap.What_changes_are_happening__c = 'Changed Value';
       update cap;
       Customer_Account_Plan_History__c[] capHistory = [SELECT Id, Customer_Account_Plan__r.Id FROM Customer_Account_Plan_History__c WHERE Customer_Account_Plan__r.Id =: cap.Id];
       System.assert(capHistory.size() == 1);
    } 
    
     public static testMethod void testCapSMLogic() 
     {         
    
        //create the test account.  At first creation, SM fields are blank on the Account,
        //  which makes them blank on the CAP too (CAP SM fields are formula fields & come from account)
       Account account = UnitTestHelper.createAccount('Test Account for CAP Testing');
       System.assert(UnitTestHelper.accountSaveSuccess);
       
 
       //Test 1a. Insert CAP where SM Info is blank --> the 2 SM fields s/b null (tests the Insert logic branch)
       Customer_Account_Plan__c cap = UnitTestHelper.createCap(account);
       System.assert(UnitTestHelper.capSaveSuccess);
       System.assertEquals(null,cap.SMName__c);
       System.assertEquals(cap.SMLink__c,null);
       
       //Test 1b. Update CAP where SM Info is blank (tests the Update logic branch)
       cap.What_changes_are_happening__c = 'Changed Value';
       update cap;
       System.assertEquals(null,cap.SMName__c);
       System.assertEquals(cap.SMLink__c,null);
        
      //FOR TEST 2: UPDATE THE ACCOUNT SM-ID TO 'ZZZZ', SM-NAME to "BOB BOBSON",TO CREATE 'USER NOT FOUND' CONDITION
       account.SalesMgrID__c = 'ZZZZ';
       account.SalesMgrName__c = 'Bob Bobson';
       update account;
      
     //  system.debug('******* Account SMID: ******* ' + account.SalesMgrID__c);
     //  system.debug('******* Account SMName: ******* ' + account.SalesMgrName__c);

      
      //TEST 2A. Insert CAP where SM Info is not found (use above account)
      //  Assert that SMLink is null and SMName is "iZZZZ not found etc"
       Customer_Account_Plan__c cap2 = UnitTestHelper.createCap(account);
       System.assert(UnitTestHelper.capSaveSuccess);
 
       //Read the CAP just created - otherwise all field values will be null      
       Customer_Account_Plan__c c2 = [select id, Name, SMLink__c, SMName__c from Customer_Account_Plan__c where Id = :cap2.Id];
       //system.debug('c2 Name: ' + c2.Name);
       //system.debug('c2 SMName: ' + c2.SMName__c);
       System.assertEquals(c2.SMLink__c,null);
       System.assertNotEquals(null,c2.SMName__c);
       System.assertEquals('Bob Bobson (iZZZZ) - alias not in SFDC',c2.SMName__c);
             
      //TEST 2B. Update CAP where SM Info is not found (use above account)
      //  Assert that SMLink is null and SMName is "iZZZZ not found etc"
       c2.What_changes_are_happening__c = 'Changed Value';
       update c2;       
       System.assertEquals(c2.SMLink__c,null);
       System.assertNotEquals(null,c2.SMName__c);
       System.assertEquals('Bob Bobson (iZZZZ) - alias not in SFDC',c2.SMName__c);
      
      //FOR TEST 3: UPDATE THE ACCOUNT SM-ID TO 'good', which will be found
       account.SalesMgrID__c = 'good';
       account.SalesMgrName__c = 'Bob Bobson';
       update account;       
       
       //FOR TEST 3: CREATE THE USER WHO'LL BE THE SALES MANAGER THAT GETS LOOKED UP SUCCESSFULLY
       // The 'runAs' is a workaround for an SFDC/Apex bug - if you just create the user without using the RunAs,
       //  you get a MIXED_DML_EXCEPTION from executing 2 DML statements in the same context. 
        
        User myself = [SELECT id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        System.runas(myself){
       		User SMUser = UnitTestHelper.createUser('igood','Goode',UserInfo.getProfileId());
       		System.assert(UnitTestHelper.userSaveSuccess); 	
        }       
      
      //TEST 3A. Insert CAP where SM will be found
      //  Assert that SMLink is not null, that it's the id of the User created above, and SMName is "Goode"
       Customer_Account_Plan__c cap3 = UnitTestHelper.createCap(account);
       System.assert(UnitTestHelper.capSaveSuccess);
              
       Customer_Account_Plan__c c3 = [select id, Name, SMLink__c, SMName__c from Customer_Account_Plan__c where Id = :cap3.Id];
       //system.debug('c3 Name: ' + c3.Name);
       //system.debug('c3 SMName: ' + c3.SMName__c);
       System.assertNotEquals(c3.SMLink__c,null);
       System.assertEquals('Goode',c3.SMName__c);              
      
      //TEST 3B. Update CAP where SM will be found
      //  Assert that SMLink is not null, that it's the id of the User created above, and SMName is "Goode"
       c3.What_changes_are_happening__c = 'Changed Value';
       update c3;       
       System.assertNotEquals(c3.SMLink__c,null);
       System.assertEquals('Goode',c3.SMName__c);
      
    } 
}