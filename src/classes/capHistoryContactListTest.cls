public class capHistoryContactListTest{

@isTest(SeeAllData=true)

 public static void testcapHistoryContactList() {
 //set up a CAP to use for tests
 Account a = [Select Id from Account Limit 1];
 Customer_Account_Plan__c cap = UnitTestHelper.createCap(a); 
 Customer_Account_Plan_History__c ch = New Customer_Account_Plan_History__c(Customer_Account_Plan__c = cap.Id, Account__c = a.Id,Name='Revision 1');
 insert ch;
 //Customer_Account_Plan_History__c ch=[SELECT ID, Account__c FROM Customer_Account_Plan_History__c Limit 1];
 
 //define the controller
  ApexPages.standardController controller = new ApexPages.standardController(ch); 
  capHistoryContactList extension = new capHistoryContactList(controller);
  //set up pageref
   PageReference pageRef = new ApexPages.StandardController(ch).view();
   Test.setCurrentPage(pageRef);  

  //start calling methods
  extension.initAccountContacts();
  }
  }