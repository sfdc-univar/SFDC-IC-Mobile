@istest(SeeAllData=true)

public class CoachingWorksheetTests{
    
 @istest public static void testCoachingStuff(){

    //Get a couple users, for Direct Report & Manager fields 
    User[] users = [select Id from User where Isactive= True limit 2];
    User u1 = users[0]; //Manager
    User u2 = users[1]; //Direct Report
 
    //setup first coaching record - status is Draft
    CoachingWorksheet__c cw = new CoachingWorksheet__c(OwnerId = u1.id, DirectReport__c = u2.id, 
      ObservationsAndNotes__c = 'test stuff', SessionDate__c = date.today(), Status__c = 'Draft');
    
    //insert record to start beforeInsert trigger - this first one should work
    try{
        insert cw;
    }
        catch(System.DMLException e){
    } 
           
    // Test values after initial insert: Owner & Ownerlink both = same as the Manager
    CoachingWorksheet__c cw1 = [select id, OwnerId, OwnerLink__c, Manager__c from CoachingWorksheet__c where Id = :cw.Id];
    System.assertEquals(u1.Id, cw1.OwnerId);
    System.assertEquals(u1.Id, cw1.OwnerLink__c);
    System.assertEquals(cw1.Manager__c, cw1.OwnerId);
    
    // Now Update Status to "Direct Report Review"
    cw1.Status__c = 'Direct Report Review';
    update cw1;
 
    // Test values after updating status: Owner & OwnerLink are both now = Direct Report
    CoachingWorksheet__c cw2 = [select id, OwnerId, OwnerLink__c, DirectReport__c from CoachingWorksheet__c where Id = :cw1.Id];
    System.assertEquals(u2.Id, cw2.OwnerId);
    System.assertEquals(u2.Id, cw2.OwnerLink__c);
    System.assertEquals(cw2.DirectReport__c, cw2.OwnerId);
    
    //And now try to create a duplicate record - same Direct Report & Session Date as the first one
    CoachingWorksheet__c cwDup = new CoachingWorksheet__c(OwnerId = u1.id, DirectReport__c = u2.id, 
      ObservationsAndNotes__c = 'test stuff', SessionDate__c = date.today(), Status__c = 'Draft');
    
    //insert record to start beforeInsert trigger - this first one should cause an error
    try{
        insert cwDup;
    }
        catch(System.DMLException e){
    } 
       
 }

}