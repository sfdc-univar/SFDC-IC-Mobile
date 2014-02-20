public class AccountRecordTypeSelectTest {

@isTest(SeeAllData=true)
  
 public static void testAccountRecordTypeSelect1() {
   RecordType r1 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'ShipTo'];  
   Account a1;
   //2013-11-11 Country/State Picklists - K Miller - change to update ShippingStateCode instead of ShippingState
     a1 =  new Account(Name='test1',ShippingStateCode = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r1.Id);
        System.assertEquals(a1.getsObjectType(), Account.sObjectType);
        
   ApexPages.standardController controller1 = new ApexPages.standardController(a1);
   AccountRecordTypeSelect extension1 = new AccountRecordTypeSelect(controller1);  
    
    PageReference pageRef1 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef1);
    ApexPages.currentPage().getParameters().put('id', a1.id);
    pageRef1 = extension1.redirectSelect();  
    
    }
    
    
  public static testMethod void testAccountRecordTypeSelect2() {  
   RecordType r2 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'Prospect'];
  
   Account a2;
  
   a2 = new Account(Name='test1',ShippingState = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r2.Id);
   
   ApexPages.standardController controller2 = new ApexPages.standardController(a2);
   AccountRecordTypeSelect extension2 = new AccountRecordTypeSelect(controller2);  
    
    PageReference pageRef2 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef2);
    ApexPages.currentPage().getParameters().put('id', a2.id);  
    pageRef2 = extension2.redirectSelect();         

   }
   
  public static testMethod void testAccountrecordTypeSelect3(){
    RecordType r3 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'Corporate'];
    Account
      a3 =  new Account(Name='test1',ShippingState = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r3.Id);
   
       
   
   ApexPages.standardController controller3 = new ApexPages.standardController(a3);
   AccountRecordTypeSelect extension3 = new AccountRecordTypeSelect(controller3);  
    
    PageReference pageRef3 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef3);
    ApexPages.currentPage().getParameters().put('id', a3.id);  
    pageRef3 = extension3.redirectSelect();         

   }
   
   public static testMethod void testAccountrecordTypeSelect4(){
    RecordType r4 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'CorporateChemCare'];
     
    Account a4;
   
     a4 =  new Account(Name='test1',ShippingState = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r4.Id);
   
   ApexPages.standardController controller4 = new ApexPages.standardController(a4);
   AccountRecordTypeSelect extension4 = new AccountRecordTypeSelect(controller4);  
    
    PageReference pageRef4 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef4);
    ApexPages.currentPage().getParameters().put('id', a4.id);  
    pageRef4 = extension4.redirectSelect();         
   }
   
   public static testMethod void testAccountrecordTypeSelect5(){
    RecordType r5 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'Consultant_Marketing'];
    Account a5;
   
   a5 =  new Account(Name='test5',ShippingState = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r5.Id);
   
        
   ApexPages.standardController controller5 = new ApexPages.standardController(a5);
   AccountRecordTypeSelect extension5 = new AccountRecordTypeSelect(controller5);  
    
    PageReference pageRef5 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef5);
    ApexPages.currentPage().getParameters().put('id', a5.id);  
    pageRef5 = extension5.redirectSelect();         
   
   }
   
   public static testMethod void testAccountrecordTypeSelect6(){
    RecordType r6 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'Prospect'];
    Account a6;
   
    a6 =  new Account(Name='test6',ShippingState = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r6.Id);
   
        
   ApexPages.standardController controller6 = new ApexPages.standardController(a6);
   AccountRecordTypeSelect extension6 = new AccountRecordTypeSelect(controller6);  
   
    Profile p = [SELECT id, name from profile WHERE name = 'System Admin - non-SSO'];
    
    User u3 = [SELECT Id, ProfileId FROM User WHERE ProfileId =:p.Id and IsActive=True LIMIT 1];
    System.runAs(u3) {

    //call redirectSelect method in AccountRecordTypeSelect
    
    PageReference pageRef6 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef6);
    ApexPages.currentPage().getParameters().put('id', a6.id);  
    pageRef6 = extension6.redirectSelect();         
   }
   }
   
   //GSE Test
      public static testMethod void testAccountrecordTypeSelect7(){
    RecordType r7 = [Select Id, DeveloperName From RecordType WHERE DeveloperName = 'GS_E'];
    Account a7;
   
    a7 =  new Account(Name='test7',ShippingState = 'WA',ShippingPostalCode ='98052', ShippingCity='Redmond',RecordTypeId= r7.Id);
   
        
   ApexPages.standardController controller7 = new ApexPages.standardController(a7);
   AccountRecordTypeSelect extension7 = new AccountRecordTypeSelect(controller7);  
   
    Profile p = [SELECT id, name from profile WHERE name = 'System Admin - non-SSO'];
    
    User u3 = [SELECT Id, ProfileId FROM User WHERE ProfileId =:p.Id and IsActive=True LIMIT 1];
    System.runAs(u3) {

    //call redirectSelect method in AccountRecordTypeSelect
    
    PageReference pageRef7 = Page.AccountRedirect;
    Test.setCurrentPage(pageRef7);
    ApexPages.currentPage().getParameters().put('id', a7.id);  
    pageRef7 = extension7.redirectSelect();         
   }
  }
   
   
    
       
          
    
}