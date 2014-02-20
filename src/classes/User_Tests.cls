@istest(SeeAllData=true)

public class User_Tests{
        
public static testMethod void testCheckAliasDuplicates(){
//setup user
User UR = new User(Alias = 'tesx'+ Math.ROUND(Math.Random()*100) , Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
  profileid = UserInfo.getProfileId() , timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com',
  UserRoleId=UserInfo.getUserRoleId()) ;
system.debug('testCheckAliasDuplicates #1: non-duplicate insert - alias is: ' + UR.alias);
      
//insert record to start trigger
//try{insert UR ;}
 //catch(System.DMLException e){} 
    insert UR;
User u1 = [select id from User where Id = :UR.Id];
    
  //create duplicate alias     
 User Udup = new User(Alias = 'idelg', Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
  profileid = UserInfo.getProfileId() , timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com',
  UserRoleId=UserInfo.getUserRoleId()) ;
  
 system.debug('testCheckAliasDuplicates #2: duplicate insert - alias is: ' + Udup.alias);
//insert record to start trigger
try{insert Udup;}
 catch(System.DMLException e){} 
    
}
    
public static testMethod void testStateAndCountryChanges(){    
  
//create a user
User u1 = new User(Alias = 'texx' + Math.ROUND(Math.Random()*100) , Email = 'abc9@univarusa.com' ,
 emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
  profileid = UserInfo.getProfileId() , timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com',
  UserRoleId=UserInfo.getUserRoleId(), IntegratedCountry__c = 'Mexico') ;
 system.debug('test #3 Insert user - country is Mexico; alias is: ' + U1.alias);
insert u1;
//try{insert U1 ;}
 //catch(System.DMLException e){} 
     
//Update Country to null to test changing from something to null
User u2 = [select id, IntegratedCountry__c from User where Id = :u1.Id];
u2.IntegratedCountry__c = null;
system.debug('test #4 Update user - now country is null; alias is: ' + U2.alias);
update u2;    
// Test: confirm Country has been set to 'US'
User u3 = [select id, IntegratedCountry__c, CountryCode from User where Id = :u2.Id];
System.assertEquals(u3.CountryCode, 'US');        
     
//Update Country on to a value that doesn't exist on CustomCountries setting
u3.IntegratedCountry__c = 'ZZZZYYYYYASDFfa';
system.debug('test #5 Update user - to non-existant country; alias is: ' + U3.alias);
update u3;    
// Test: confirm Country has been set to 'US'
User u4 = [select id, IntegratedCountry__c, IntegratedState__c, CountryCode from User where Id = :u3.Id];
System.assertEquals(u4.CountryCode, 'US');        

//Update State and Country to a valid values that exists on the custom settings
u4.IntegratedCountry__c = 'United States';
u4.IntegratedState__c = 'North Dakota';
system.debug('test #6 Update user - to US, ND; alias is: ' + U4.alias);
update u4;    
// Test: confirm State Code and Country Code have been converted correctly
User u5 = [select id, CountryCode, StateCode from User where Id = :u4.Id];
System.assertEquals(u5.CountryCode, 'US');    
System.assertEquals(u5.StateCode, 'ND');         
}

public static testMethod void testManagerPerNrName() {
   
    //1. User with valid Manager PerNr --> populate the manager field
    User UR = new User(Alias = 'txxx' + Math.ROUND(Math.Random()*100) , Email = 'abc9@univarusa.com' ,
     emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
     timezonesidkey = 'America/Los_Angeles', username = 'abc9@univarusa.com',
     UserRoleId=UserInfo.getUserRoleId(), ManagerPerNr__c = '10003602') ;
    
    UserLicense[] ul = [Select Id, Name From Userlicense WHERE Name = 'Salesforce'];
    Profile[] pr = [Select Id, UserType, UserLicenseId From Profile WHERE UserLicenseId = :ul[0].Id];
    UR.ProfileId = pr[0].Id;
    
    system.debug('Manager PerNr Test #1 - INSERT; alias is: ' + UR.alias);
    insert UR;
    // try{insert UR ;}
    //	catch(System.DMLException e){}
    
    //2. User with invalid Manager PerNr
	User u1 = [select id, IntegratedCountry__c from User where Id = :UR.Id];
	u1.ManagerPerNr__c = 'xxxx#$@';
    system.debug('Manager PerNr Test #1 - UPDATE; alias is: ' + U1.alias);
    try{update u1 ;}
		catch(System.DMLException e){}

}
    

public static testMethod void testCheckAliasDuplicates2(){
User UR = new User(Alias = 'xxxx' , Email = 'eva.delorio@univarusa.com' ,
  emailencodingkey = 'UTF-8' , lastname = 'LasName' , languagelocalekey = 'en_US', localesidkey = 'en_US',
  profileid = UserInfo.getProfileId() , timezonesidkey = 'America/Los_Angeles', username = 'xxxx@univarusa.com',
  UserRoleId='00E30000000rcfF') ;
  
  system.debug('testCheckAliasDuplicates2 #1: insert xxxxx - alias is: ' + UR.alias);
  try{insert UR; }
   catch(System.DMLException e){} 
    
//    User UX = [Select Id, Alias, UserRoleId From User Where Id =:UR.Id];
//    System.debug('################# User UX : ' + UX.Id);     
    UR.Alias= String.valueOf(Math.ROUND(Math.Random()*10));
    UR.UserRoleId = UserInfo.getUserRoleId();
    
    system.debug('testCheckAliasDuplicates2 #2: UPDATE alias to: ' + UR.alias);
    try{
    update UR;
    } catch(System.DMLException n){
    System.debug('~~~~~~~~~~~~~~~~~~ ERROR: ' + n);
    }
         
}
}