@istest
public with sharing class TestingUtil {
    
    //2013-11-11 Country/State Picklists - K Miller - change to update ShippingStateCode instead of ShippingState
    public String opId;
    public String scsId;
    public String scsecId;
    public String scsecItemId;
    public String actId;

    public TestingUtil(){
        opId = makeTestableOp();
        scsId = makeSalesCoachStage();
        scsecId = makeSalesCoachSections();
        scsecItemId = makeSecItem();
        actId = makeActivities();
        ApexPages.currentPage().getParameters().put('id', this.opId);
    }

    private String makeTestableOp(){
        Opportunity op = new Opportunity();
        op.Name='testOpName';
        op.CloseDate = Date.today();
        op.StageName='Build';
        op.Product__c='01ta0000001GtBT';
        op.PriceperUOM__c = 100;
        op.Annual_LBs__c =100;
        op.Opportunity_Industry__c = 'Biofuels';
        insert op;
        return op.Id;
    }

    private String makeSalesCoachStage(){
        Sales_Coach_Stage__c scs = new Sales_Coach_Stage__c();
        scs.Name='Build';
        scs.Buyer_Stage__c='Consensus';
        scs.Active__c=true;
        insert scs;
        return scs.Id;
    }
  
    private String makeSalesCoachSections(){
        Sales_Coach_Section__c scsec =  new Sales_Coach_Section__c();
        scsec.Section_Ordering__c =1.0;
        scsec.Section_Name__c='Build';
        scsec.Sales_Coach_Stage__c=scsId;
        scsec.Section_Width__c=33.0;
        insert scsec;
        return scsec.Id;
    }

  
    private String makeSecItem(){
      Sales_Coach_Section_Item__c secItem = new Sales_Coach_Section_Item__c();
       secItem.Section_Ordering__c=1.0;
        secItem.Sales_Coach_Section__c=scsecId;
        secItem.Link_to_Content__c='http://www.google.com';
        secItem.Item_Name__c='Build';
        secItem.Display__c=true;
        secItem.Products__c='';
        insert secItem;
        return secItem.Id;
    }

    private String makeActivities(){
        Sales_Coach_Activity__c sca = new Sales_Coach_Activity__c();
        sca.Sales_Coach_Stage__c=scsId;
        sca.Ordering_Number__c=1.0;
        sca.Activity_Details__c='Build';
        insert sca;
        return sca.Id;
    }

    public static Account createAccount(String name, Boolean doInsert) {
        Account account = new Account();
        account.Name = name;
        account.ShippingCity = 'city';
        account.ShippingStateCode = 'WA';
        
        if(doInsert) {
            insert account;
        }
        
        return account;
    }
    
    public static List<Account> createAccounts(Integer size, String name, Boolean doInsert) {
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i<size; i++) {
            accounts.add(createAccount(name+i,false));
        }
        
        if(doInsert) {
            insert accounts;
        }
        
        return accounts;
    }

}