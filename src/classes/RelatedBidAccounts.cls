/*
20130702 - ELD
The purpose of this Class:
Used by the Add_Related_Accounts VF Page
Adds related accounts to the Campaign

2013-11-11 Country/State Picklists - K Miller - Add State Code fields to be displayed on the page
           (kept long text version in query in case anyone needs it later)

*/
public with sharing class RelatedBidAccounts {

    Campaign c;
    ID acctSearch;
    ID campId;
     public RelatedBidAccounts(ApexPages.StandardController controller) {
       	c = (Campaign)controller.getRecord();

     	
     }
    
    //searchText is assigned to the search input on the page with id=searchText
	public String searchText{
    get{
    if(searchText == null){
    System.debug('*********** c? ' + c.id);
    //get searchText querystring param or set using account name from campaign
    List<Campaign> searchAccount = [Select ID, Account__c FROM Campaign WHERE Id =:c.Id];
    acctSearch = searchAccount[0].Account__c; 
    campId = searchAccount[0].Id;
    System.debug('************ acctSearch: ' + acctSearch);
    List<Account> accountIds = [Select Id, Name FROM Account WHERE Id =:acctSearch];
    //put the name of the Account in the search field
    searchText = accountIds[0].Name;    
    }
    return searchText;
    }
    set;
    }
          
    public List<AccountWrapper> results {get;set;}
    
    
    public void findAccounts() {
        results = new List<AccountWrapper>();
      //  String escapedSingleQuotesSearchText = String.escapeSingleQuotes(searchText);
      //commented above due to apostrophe errors
        String escapedSingleQuotesSearchText = searchText;
        if(escapedSingleQuotesSearchText.length()<2){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.String_Too_Short));
            return;
        }
        
        List<Account>accounts = (List<Account>)[SELECT id,RecordTypeId, ShipToNumber__c ,
        Name,ShippingStreet,ShippingCity,CustomerNumber__c,SalesRepName__c,ShippingState,ShippingStateCode,
        BillingStreet, BillingState,BillingStateCode, BillingPostalCode, BillingCountry, BillingCity,
        ShippingPostalCode, ShippingCountry, SalesOfficeName__c, Owner.Name,
        ShipToName__c, CustomerStatus__c FROM Account WHERE NAME LIKE :('%' + escapedSingleQuotesSearchText + '%') AND id !=:acctSearch ORDER BY ShippingCity asc];
        
        List<Related_Account__c> campAccounts = new List<Related_Account__c>([SELECT Id, Account__c, Campaign__c FROM Related_Account__c WHERE Campaign__c =: campId ]);
 
        Set<ID> accountRIDs = new Set<Id>();
    	for(Related_Account__c ra : campAccounts){
    		accountRIDs.add(ra.Account__c);
    	}  
         for(Account a : accounts) {
         	Boolean RIDresult = accountRIDs.contains(a.id);
         	System.debug('*********************** ' + RIDresult);
         	if(!RIDresult){
            AccountWrapper accountWrapper = new AccountWrapper(a);
            results.add(accountWrapper);
        }
        }
    }
    public List<Related_Account__c> related = new List<Related_Account__c>();
       
    public PageReference save(){
    	List<Id> accountIds = new List<Id>();
    	    	
        for(AccountWrapper aw : results) {
            if(aw.isChecked) {
                accountIds.add(aw.account.Id);
            }
        }       
         for(Id id : accountIds) {
         //create the related account object
          Related_Account__c campaignAccounts = new Related_Account__c(Account__c=id,
          Campaign__c = c.id);
          //add to list and insert after loop
          related.add(campaignAccounts);           
        }
    	 Database.SaveResult[] srList = Database.insert(related, false);
		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
    		if (sr.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
           // System.debug('Successfully inserted Related_Account__c. ID= ' + sr.getId());
            //set up page reference?
   		    }
    		else {
            // Operation failed, so get all errors                       
            for(Database.Error err : sr.getErrors()) {
            	System.debug('The following error has occurred.');                    
            	System.debug(err.getStatusCode() + ': ' + err.getMessage());
            	System.debug('Related Accounts fields that affected this error: ' + err.getFields());
        		}
    		} 
		} 
		PageReference p = new PageReference('/' + c.id);
		 	return p;
    }

    //wrapper class for shown accounts
    public class AccountWrapper {
        public Boolean isChecked{get;set;}
        public Account account{get; private set;}
        
        public AccountWrapper(Account account) {
            this.account = account;
            isChecked = false;
        }
    }   
}