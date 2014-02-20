trigger PreventDuplicateCoachingWorksheets on CoachingWorksheet__c (after Insert,after Update) {

 //Check for duplicates - can only have one Session Date per Direct Report
 //If count is greater than 1 there is a duplicate.  Need to use "After" insert so it will include the current record.
 
 //2012-09-04 K Miller - created

    // Loop through the incoming records
    for (CoachingWorksheet__c c : Trigger.new) {
    
        system.debug('DR firstName: ' + c.DirectReportNm__c);
        
        Integer i = [ select count() from CoachingWorksheet__c where SessionDate__c = :c.SessionDate__c
                        and DirectReport__c = :c.DirectReport__c ];
        if (i > 1) {
            c.SessionDate__c.addError('' + c.DirectReportNm__c + ' already has a worksheet for this Session Date.');
        }
    }   

}