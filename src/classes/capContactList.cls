public with sharing class capContactList{

   
     public Customer_Account_Plan__c c;
     public Id acctId;
     public String currentId = System.currentPageReference().getParameters().get( 'currentId' );
     public Id capID = currentId;
      
     public capContactList(ApexPages.StandardController controller) {
        c = (Customer_Account_Plan__c) controller.getRecord();
       if(c.Id!= null){
       currentId = c.Account__c;
        }  else {
        currentId = System.currentPageReference().getParameters().get( 'currentId' );
        }
       if(c.Id == null){
        c.Account__c = currentId;
        }
       initAccountContacts();
      }
          
    public List<Contact> accountContacts{get;set;}
      
    public void initAccountContacts(){
   // System.debug('^^^^^^^^^^^^^^^^ capContactList currentID: ' + currentId);
    accountContacts = [Select Id, FirstName, LastName, Title, 
               Stakeholder_Profile__c, Economic_Outcome__c, Demand_Driver__c,State_of_Relationship__c, AccountId
                FROM Contact Where AccountId = :currentId Limit 100];
      }
                   
    public Boolean getIsSalesManager(){
    //don't render 'Review' button is current user is not the Manager
    Id isSalesMan = UserInfo.getUserId();
    Customer_Account_Plan__c sm = [SELECT Sales_Manager_Id__c, Id FROM Customer_Account_Plan__c WHERE Id = :c.Id];
       
    string smID = sm.Sales_Manager_Id__c;
    smId = 'i' + smId;
 //   System.debug('xxxxxxxxxxxxxxxxx Sales Manager ID: ' + smId);
    
    User u = [Select Id, Alias From User WHERE Id =: isSalesMan];
    
    
    String salesmanId = u.Alias;
 //   System.debug('oooooooooooooooooooooooo User ID: ' + salesmanId);
    
    //check for matching aliases
    if(salesmanId.capitalize() == smID.capitalize()){
    return true;
    } else {
    return false;
    }
 } 
          
      //SAVE
     public PageReference save(){
      String capId = c.Account__c;
      c.setReadOnly__c = true;
      upsert c;
      
         if(accountContacts.size()>0){
         List<Database.upsertResult> uResults = Database.upsert(accountContacts,false);
         for(Database.upsertResult result:uResults) {
         if (result.isSuccess() ) {
        }  
        }  
        } 
    // returning from Trigger that created the history for this CAP
         List<Customer_Account_Plan__c> newcap = [Select Id, Name, Account__c, Sales_Manager__c, 
     Main_Competitor__c, Last_Reviewed__c, CreatedDate, IsClone__c  
     FROM Customer_Account_Plan__c WHERE Account__c =: currentId order by CreatedDate desc];
            
      Customer_Account_Plan__c cplan = newcap[0];
      PageReference cpage= new ApexPages.StandardController(cplan).view();
      cpage.getParameters().put('currentId',currentId); 
      cpage.getParameters().put('tabName','customerplan');
      cpage.setRedirect(true);
      
     return cpage;
     }
     
     public PageReference review(){
     String accountId = c.id;
     String managerDate = c.Last_Updated__c.format();
     // c.Manager_Review__c = String.valueOf(c.Last_Updated__c);
     //system.debug('***** HERE!!! ******  in capContactList review code before upsert ***************');
     c.Manager_Review__c = managerDate;
      upsert c;     
     List<Customer_Account_Plan__c> reviewcap = [Select Id, Name, Account__c, SMLink__c, 
     Main_Competitor__c, Last_Reviewed__c, CreatedDate, IsClone__c  
     FROM Customer_Account_Plan__c WHERE Account__c =: currentId order by CreatedDate desc];
            
      Customer_Account_Plan__c revcplan = reviewcap[0];
      PageReference revcpage= new ApexPages.StandardController(revcplan).view();
      revcpage.getParameters().put('currentId',currentId); 
      revcpage.getHeaders().put('Referer','tabbedaccounts');
      revcpage.getParameters().put('tabName','customerplan');

      revcpage.setRedirect(true);
      
      return revcpage;

     }
     
}