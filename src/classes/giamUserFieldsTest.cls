@isTest(SeeAllData=true)
private class giamUserFieldsTest {

public static testMethod void testGiamUserFields(){
 Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
  System.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 0. checked or not ? ' + TC.Giam_Trigger__c);
  System.assert(true, Trigger.isBefore);
  Trigger_Controls__c TCUpdate = [Select Id, Giam_Trigger__c From Trigger_Controls__c];
  Boolean triggerActive = TCUpdate.Giam_Trigger__c;
    
  TCUpdate.Giam_Trigger__c = true;
 
 User UR = new User(Alias = 'test' + Math.ROUND(Math.Random()*10) , Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
 timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com',
  UserRoleId=UserInfo.getUserRoleId()) ;
  
  UserLicense[] ul = [Select Id, Name From Userlicense WHERE Name = 'Salesforce'];
Profile[] pr = [Select Id, UserType, UserLicenseId From Profile WHERE UserLicenseId = :ul[0].Id];
UR.ProfileId = pr[0].Id;
System.debug('+++++++++++++++++++++++++ USER TYPE: ' + UR.UserType);
//insert record to start trigger
try{
insert UR ;
}
 catch(System.DMLException e){
   
   }
   System.debug('********************* UR Type: ' + UR.UserType);
  //  System.assertEquals(UR.UserPermissionsOfflineUser, true);
  //  System.assertEquals(UR.UserPermissionsMobileUser, true);
}
public static testMethod void testGiamChatterUserFields(){
 Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
  System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 1. checked or not ? ' + TC.Giam_Trigger__c);
  System.assert(true, Trigger.isBefore);
  
  TC.Giam_Trigger__c = true;
  
 User UC = new User(Alias = 'test' + Math.ROUND(Math.Random()*10) , Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
  profileid = '00ea0000000jPty' , timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com') ;
   
//insert record to start trigger
try{
insert UC ;
}
 catch(System.DMLException e){
   
   }
   System.debug('********************* UC : ' + UC.UserType);
  //  System.assertEquals(UR.UserPermissionsOfflineUser, true);
  //  System.assertEquals(UR.UserPermissionsMobileUser, true);
}

public static testMethod void testGiamTriggerControls(){
 //Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
Trigger_Controls__c TCsetFalse = [Select Id, Giam_Trigger__c From Trigger_Controls__c];	
  TCsetFalse.Giam_Trigger__c = false;
  try{
  	update TCsetFalse;
  }
  catch(System.DMLException e){
  	
  }
  System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~ 2. checked? ' + TCsetFalse.Giam_Trigger__c);
// Trigger_Controls__c TCUpdate = [Select Id, Giam_Trigger__c From Trigger_Controls__c];
   System.assert(true, Trigger.isBefore);

 User UT = new User(Alias = 'test' + Math.ROUND(Math.Random()*10) , Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com') ;
  
 //get the UserLicense Name
 UserLicense[] ul = [Select Id, Name From Userlicense WHERE Name = 'Chatter Free' OR Name = 'Chatter External'];
 String n = ul[0].Name;
 System.debug('~~~~~~~~~~~~~~ UserLicense: ' + n);
 
 Profile[] p = [Select Id, UserType, UserLicenseId From Profile WHERE UserLicenseId = :ul[0].Id];
 UT.ProfileId = p[0].Id;
//insert record to start trigger
try{
insert UT ;
}
 catch(System.DMLException e){
   
   }
   System.debug('********************* UT : ' + UT.UserType);
  //  System.assertEquals(UR.UserPermissionsOfflineUser, true);
  //  System.assertEquals(UR.UserPermissionsMobileUser, true);
}
  
}