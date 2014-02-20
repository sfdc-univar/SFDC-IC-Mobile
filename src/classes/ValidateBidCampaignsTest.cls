@isTest(SeeAllData=true)
    
public with sharing class ValidateBidCampaignsTest {

  static testMethod void ValidateBidCampaignsTestFalse(){
    Id rt = [SELECT Id FROM RecordType WHERE sObjectType='Campaign' AND DeveloperName='Bid_Campaigns'].Id;
    Account a1 = [SELECT ID FROM ACCOUNT LIMIT 1];
    Campaign c1 = [SELECT ID, Account__c, RecordTypeId, Type FROM Campaign WHERE RecordTypeId=:rt LIMIT 1];
    final List<Related_Account__c> related = [SELECT Id, Account__c, Campaign__c FROM Related_Account__c  WHERE Campaign__c !=:c1.Id  ];
    final Boolean isRelated = false;
    System.assertEquals(rt,c1.RecordTypeId);
    
    Opportunity opnew1 = new Opportunity();
    opnew1.Name='Test';
    opnew1.AccountId = a1.Id;
    opnew1.CampaignId = c1.Id;
    opnew1.Product__c='01t30000001Gpxs';
    opnew1.Annual_LBs__c=1;
    opnew1.Est_GMDollar__c=1;
    opnew1.CloseDate=Date.today();
    opnew1.Opportunity_Type__c='Developmental';
    opnew1.StageName='Negotiate';
    opnew1.Opportunity_Industry__c='General';

    try {
    insert opnew1 ;
    } catch (DMLException r) {
    //exception
    }
    System.debug('************ isRelated? ' + isRelated);
}

 static testMethod void ValidateBidCampaignsTestTrue(){
    Id rt = [SELECT Id FROM RecordType WHERE sObjectType='Campaign' AND DeveloperName='Bid_Campaigns'].Id;
    final Campaign c2 = [SELECT ID, Account__c, RecordTypeId, Type FROM Campaign WHERE RecordTypeId=:rt LIMIT 1];
    System.assertEquals(rt,c2.RecordTypeId);
    
    final Related_Account__c  related2 = new Related_Account__c(Account__c=c2.Account__c,Campaign__c=c2.Id);
         try{
            insert(related2);
            }catch (DMLException r){
        }
    Id relatedAcct = related2.Account__c;
    final List<Related_Account__c> related = [SELECT Id, Account__c, Campaign__c FROM Related_Account__c WHERE Campaign__c =:c2.Id ];
    
    Opportunity opnew2 = new Opportunity();
    opnew2.Name='Test';
    opnew2.AccountId = relatedAcct;
    opnew2.Product__c='01t30000001Gpxs';
    opnew2.CampaignId=c2.Id;
    opnew2.Annual_LBs__c=1;
    opnew2.Est_GMDollar__c=1;
    opnew2.CloseDate=Date.today();
    opnew2.Opportunity_Type__c='Developmental';
    opnew2.StageName='Negotiate';
    opnew2.Opportunity_Industry__c='General';
     
      try {
    insert opnew2 ;
    } catch (DMLException r) {
    //exception
    }   
}
   
}