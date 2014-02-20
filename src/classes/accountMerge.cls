public with sharing class accountMerge{
    
    public String searchText{
    get{
        if(searchText == null){
    //get searchText querystring param
    searchText = ApexPages.currentPage().getParameters().get('searchText');
    }
    return searchText;
    }
    set;
    }
       
    public String nextUrl{
        get{
            if(nextUrl==null) {
                nextUrl='';
            }
            return nextUrl;
        }
        set;
    }
    
    public List<AccountWrapper> results {get;set;}
      
    public void findAccounts() {
        results = new List<AccountWrapper>();
      //  String escapedSingleQuotesSearchText = String.escapeSingleQuotes(searchText);
        String escapedSingleQuotesSearchText = searchText;
        if(escapedSingleQuotesSearchText.length()<2){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.String_Too_Short));
            return;
        }
        
        List<Account>accounts = (List<Account>)[SELECT id,RecordTypeId, ShipToNumber__c ,Name,ShippingStreet,ShippingCity,CustomerNumber__c,SalesRepName__c,ShippingState,
                                                                                                            BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity,ShippingPostalCode, ShippingCountry, Owner.Name,
                                                                                                            ShipToName__c, CustomerStatus__c FROM Account WHERE NAME LIKE :('%' + escapedSingleQuotesSearchText + '%')];
        
        for(Account a : accounts) {
            AccountWrapper accountWrapper = new AccountWrapper(a);
            results.add(accountWrapper);
        }
    }   
   
    public void next() {
        List<Id> accountIdsForUrl = new List<Id>();

        for(AccountWrapper aw : results) {
            if(aw.isChecked) {
                accountIdsForUrl.add(aw.account.Id);
            }
        }
        
        if(accountIdsForUrl.size()<2) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Select_More_Accounts));
            return; 
        }
        
        else if(accountIdsForUrl.size()>3) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.Too_Many_Accounts_Selected));
            return; 
        }
        
        nextUrl = Url.getSalesforceBaseUrl().toExternalForm();
        nextUrl += createNextUrl(accountIdsForUrl);
         
  }
   
    public PageReference cancel() {
        return new PageReference('/001/o');  
    } 

    private String createNextUrl(List<Id> accountIds) {
        String url = '/merge/accmergewizard.jsp?';
        url+='&goNext=+Next+';
        for(Id id : accountIds) {
            url+='&cid='+id; 
        }
        return url;
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