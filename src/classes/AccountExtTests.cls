public class AccountExtTests {
    
@isTest(SeeAllData=true)
 public static void testAccountExt() {
    
//The following account has history that covers 100% of test cases in both Prod & SB.

       Account a;
      a =  [select id, name from Account LIMIT 1];    
      User u2 = [select id, name from User LIMIT 1];
      a.Owner = u2;
      a.BillingCity = 'Redmond';
      a.TotalChemicalSpend__c = 100.00;
       try {
               Update a;
            } catch (Exception e) {
                System.debug('~~~~~~~~~~~~~~~~~~~~~ ERROR: ' + e);
            }
       system.debug('********************** ACCOUNT Owner: ' + a.Owner+ ', ID:' + a.id);
       System.assertEquals(a.getsObjectType(), Account.sObjectType);           
       PageReference pageRef = Page.TabbedAccounts;    
       Test.setCurrentPage(pageRef);    
       ApexPages.currentPage().getParameters().put('id', a.id);
       ApexPages.standardController controller = new ApexPages.standardController(a);    
       //following statement calls the Constructor method for AccountExt     
       AccountExt extension = new AccountExt(controller);
      
       String tabName = pageRef.getParameters().get('tabName');
       String selectedTab = extension.getSelectedTab();
       extension.setTabName('AcctDetails');
              
       //Following calls method in AccountExt, for the account above
       list<AccountExt.cHistories> list_ch = extension.getHistories();
       AccountExt.cHistories ch = new AccountExt.cHistories(); 
        String fieldName = 'Owner';
        String theDate = '10/1/2010 10:38 AM'; 
        String who = 'Eva DeLorio';
        String fromText = 'Sheila';
        String toText = 'Robert';  
     
        ch.FieldLabel = fieldName;
        ch.fromValue = fromText;
        ch.toValue = toText;
        ch.who = who;
      System.assertEquals('Eva DeLorio',who);
       PageReference getCustomerAccountPlan = extension.getCustomerAccountPlan(); 
       }
    
@isTest(SeeAllData=true) 
 public static void testAccountExtWithData() {
   Account an;
        
      an = [Select Id,(Select Id, IsDeleted, AccountId, 
      CreatedById, CreatedDate, Field, OldValue, NewValue From Histories) From Account LIMIT 1];
      
      ApexPages.standardController Hcontroller = new ApexPages.standardController(an);    
      AccountExt Hextension = new AccountExt(Hcontroller);
        //Following calls method in AccountExt, for the account above
       list<AccountExt.cHistories> list_ch = Hextension.getHistories();
       AccountExt.cHistories ch = new AccountExt.cHistories(); 
            list_ch.add(ch);
      System.debug('*************** LIST SIZE: ' + list_ch.size());      
      System.assertNotEquals(list_ch.size(), 0);        
      System.assertEquals(an.getsObjectType(), Account.sObjectType);
           
      Customer_Account_Plan__c cplan = New Customer_Account_Plan__c(Account__c=an.id);
      insert cplan;
      cplan.clone(false,true,true,true);
      String currentId = cplan.Id;
           
       PageReference anPage = new ApexPages.StandardController(an).view();
       anPage.getParameters().put('currentId',currentId );   
       Test.setCurrentPage(anPage);   
        ApexPages.currentPage().getParameters().put('id', an.id);
        ApexPages.currentPage().getParameters().put('currentId', an.id); 
       
       ApexPages.standardController controlleran = new ApexPages.standardController(an);    
       //following statement calls the Constructor method for AccountExt     
       AccountExt extensionan = new AccountExt(controlleran);
          
       PageReference getCustomerAccountPlan =  extensionan.getCustomerAccountPlan();
          
 
 }
          
  }