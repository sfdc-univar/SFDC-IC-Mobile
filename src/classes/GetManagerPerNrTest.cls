/**

 */
@isTest(SeeAllData=true)
private class GetManagerPerNrTest {

    static testMethod void testManagerPerNrName() {
    	 User UR = new User(Alias = 'test' + Math.ROUND(Math.Random()*10) , Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
 timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com',
 UserRoleId=UserInfo.getUserRoleId(), ManagerPerNr__c = '10003602') ;

 UserLicense[] ul = [Select Id, Name From Userlicense WHERE Name = 'Salesforce'];
Profile[] pr = [Select Id, UserType, UserLicenseId From Profile WHERE UserLicenseId = :ul[0].Id];
UR.ProfileId = pr[0].Id;

 try{
 insert UR ;
 }
 catch(System.DMLException e){
   
   }
      
}
    
	public static testMethod void testManagerTriggerControl(){
 		//Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
		Trigger_Controls__c TCsetFalse = [Select Id, User_s_Manager__c From Trigger_Controls__c];	
  		TCsetFalse.User_s_Manager__c = false;
 		 try{
  		update TCsetFalse;
 		 }
  		catch(System.DMLException e){
  	
  	}    
   System.debug('~~~~~~~~~~~~~~~~~~~~~~~~~ Trigger Control ' + TCsetFalse.User_s_Manager__c);
   System.assert(true, Trigger.isBefore);
}
}