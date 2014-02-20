public with sharing class capHistoryContactList{

     
     public String strAccount;
     public Customer_Account_Plan_History__c ch;
     
       public capHistoryContactList(ApexPages.StandardController controller) {
        ch = (Customer_Account_Plan_History__c) controller.getRecord();
        strAccount = ch.Account__c;
        initAccountContacts();
        }
     public List<Contact> accountContacts{get;set;}
         
     public void initAccountContacts(){

     accountContacts = [Select Id, FirstName, LastName, Title, 
               Stakeholder_Profile__c, Economic_Outcome__c, Demand_Driver__c,State_of_Relationship__c, AccountId
                FROM Contact Where AccountId = :strAccount Limit 100];
      }
}