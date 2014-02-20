/**Test Trigger
** Also should run into the AccountStructure class to test changes there used by the Trigger
 */
@isTest(SeeAllData=true)
private class RelateAccountHierarchyTest {
 
    static testMethod void RelateAccountHierarchyTrue() {
RecordType rt = [SELECT Id, DeveloperName from RecordType WHERE DeveloperName = 'Bid_Campaigns'];
RecordType rp = [SELECT Id, DeveloperName from RecordType WHERE DeveloperName = 'Bid_Master'];
RecordType ra = [SELECT Id, DeveloperName from RecordType WHERE DeveloperName = 'Corporate'];
List<Account> a = [SELECT Id, RecordTypeId, Name, GroupAccountNumber__c FROM Account WHERE RecordTypeId =:ra.Id LIMIT 1];    	
Campaign parent = new Campaign();
parent.RecordTypeId = rp.Id;
parent.Name='Test';
parent.Account__c = a[0].Id;
try {
        insert parent;
       } catch (DMLException e){
        //exception
       } 	
       Campaign c = new Campaign();
       c.RecordTypeId = rt.Id;
       c.Name = a[0].Name;
       c.Account__c = a[0].Id;
       c.ParentId = parent.Id;
       
       try {
        insert c;
       } catch (DMLException e){
        //exception
       }
       
    }
}