trigger UpdateEmailResultSummaryTotals on xtma_Individual_Email_Result__c (after insert, after update) {

    // Add IER records to ERS records
    if( Trigger.isInsert ) {
                        
        EmailSummaryController.updateEmailResultSummaryRecord( Trigger.newMap.keySet() );
        
    }
    
    // Create set of unique ERS records to update
    Set<Id> ersIds = new Set<Id>();
    for( xtma_Individual_Email_Result__c emailResult : Trigger.new ) {
        
        if( emailResult.emailResultSummary__c != null ) ersIds.add( emailResult.emailResultSummary__c );
        
    }
    
    if( ersIds.size() > 0 ) {
        
        List<Id> ids = new List<Id>();
        for( Id ersId : ersIds ) {
            ids.add( ersId );
        }
        
        EmailSummaryController.updateEmailResultSummaryTotals( ids );
        
    }

}