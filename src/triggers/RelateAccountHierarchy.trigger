trigger RelateAccountHierarchy on Campaign (after insert) {

 private final Account acct;
 RecordType rt = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName = 'Bid_Campaigns'];
 for (Campaign camp : Trigger.new){
    if(camp.RecordTypeId == rt.Id ){
    Id campAcctId = camp.Account__c;
    Account campAcct = [SELECT Id, Name FROM Account WHERE Id =:campAcctId];
    //set up controller for accounts
   /*
    ApexPages.StandardController controller = new ApexPages.standardController(campAcct);
    System.debug('************ ' + campAcct.Name);
        acct = (Account)controller.getRecord();
       // System.debug('*************** acct : ' + acct.Name);
       */
    //invoke account hierarchy class: AccountStructure to bring in all related accounts
    AccountStructure acctStruct = new AccountStructure();
    acctStruct.setcurrentId( campAcctId );
    //call related account addition
    System.debug('***** getting Campaign Accounts ' + camp.Id);
    acctStruct.getCampaignAccounts(camp.id);
    System.debug('********* Return from CampaignAccounts');         
    }
    
 }
  
 }