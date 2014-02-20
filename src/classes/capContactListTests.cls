public class capContactListTests{

@isTest(SeeAllData=true)

 public static void testCapContactList() {
 //set up a CAP to use for tests
 Customer_Account_Plan__c c=[SELECT ID, Account__c,Last_Updated__c,IsClone__c FROM Customer_Account_Plan__c Limit 1];
 
 //define the controller
  ApexPages.standardController controller = new ApexPages.standardController(c); 
  capContactList extension = new capContactList(controller);
  //set up pageref
   PageReference pageRef = new ApexPages.StandardController(c).view();
   Test.setCurrentPage(pageRef);  
Contact cont = [Select Id, Email From Contact Limit 1];   
cont.Email = 'evatest@univarusa.com';
  //start calling methods
  extension.initAccountContacts();
  extension.getIsSalesManager();
  
  //referrer?
  String frameURL = ApexPages.currentPage().getHeaders().put('Referer','tabbedaccounts');
  
  extension.save();
  extension.review();

}


}