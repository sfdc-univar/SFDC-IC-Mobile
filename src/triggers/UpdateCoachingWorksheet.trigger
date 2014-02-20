trigger UpdateCoachingWorksheet on CoachingWorksheet__c (before update,before insert) {

//2012-08-29 K Miller - created

    // Loop through the incoming records
    for (CoachingWorksheet__c c : Trigger.new) {
    
        // New record - we assume the manager is the owner
        if (Trigger.isInsert) {
               c.Manager__c = c.OwnerID;
        }
        
        // After draft, ownership moves to the Direct Report
        if (c.Status__c != 'Draft') {
              c.OwnerID = c.DirectReport__c;
        }
        
        // Has Owner changed?  If so update the link
        if (c.OwnerID != c.OwnerLink__c) {
         c.OwnerLink__c = c.OwnerId;
        }
      
    }
}