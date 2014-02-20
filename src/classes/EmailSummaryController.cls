global class EmailSummaryController {

    
    private static Map<Id,Id> contactToAccountMap = null;

    public static void updateEmailResultSummaryRecord( Set<Id> ierIds ) {
        
        Map<Id,xtma_Individual_Email_Result__c> emailResults = new Map<Id,xtma_Individual_Email_Result__c>( [select id, contact__r.account.id, date_bounced__c, date_time_opened__c, date_time_sent__c, date_unsubscribed__c, emailResultSummary__c, name, number_of_total_clicks__c, number_of_unique_clicks__c, opened__c, subject_line__c from xtma_individual_email_result__c where id in :ierIds and contact__r.accountId != null] );

        // Add IER records to existing ERS records
        addIERToERS( emailResults );
        
    }
    
    public static void addIERToERS( Map<Id,xtma_Individual_Email_Result__c> emailResults ) {
        
        long i=1;
        Set<Id> accountIds = new Set<Id>();
        Set<String> ersNames = new Set<String>();
        
        // Build maps that will be used in following SOQL
        for( xtma_Individual_Email_Result__c ier : emailResults.values() ) {
            
            accountIds.add( ier.contact__r.accountId );
            ersNames.add( ier.name );
            
        }
        
        // Compile list of Accounts and related Email Result Summaries
        Map<Id,Account> accountsWithERS = new Map<Id,Account>( [select id, ( select id, emailSubject__c, name from EmailResultSummaries__r where name in :ersNames ) from Account where id in :accountIds] );
        
        // Create a map of Account Id to map of child ERS name to ERS
        Map<Id,Map<String,EmailResultSummary__c>> accountToERSMap = new Map<Id,Map<String,EmailResultSummary__c>>();
        
        // Iterate over all Accounts that have ERS records
        for( Account account : accountsWithERS.values() ) {
            
            // Create a map of ERS name to ERS which will be added to the accountToERSMap
            Map<String,EmailResultSummary__c> ersMap = new Map<String,EmailResultSummary__c>();
            
            // Populate map of ERS name to ERS
            for( EmailResultSummary__c ers : account.emailResultSummaries__r ) {
                
                ersMap.put( ers.Name, ers );
                
            }
            
            // Add newly created ersMap to accountToERSMap
            accountToERSMap.put( account.id, ersMap );
            
        }

        // Create map of AccountId to map of ERS name to ERS
        Map<Id,Map<String,EmailResultSummary__c>> pendingERS = new Map<Id,Map<String,EmailResultSummary__c>>();
        
        // Create list of IER records that will be updated after all processing has been finished
        List<xtma_Individual_Email_Result__c> ierToUpdate = new List<xtma_Individual_Email_Result__c>();
        
        // Create map of IER Id to ERS that will be used to associate ERS parent to IER child
        Map<Id,EmailResultSummary__c> ierIdToERSMap = new Map<Id,EmailResultSummary__c>();
        
        // Create list of new ERS that will be inserted into SFDC
        List<EmailResultSummary__c> ersToInsert = new List<EmailResultSummary__c>();

        // Loop through all IER records and attach to existing ERS records
        for( xtma_Individual_Email_Result__c emailResult : emailResults.values() ) {
            
            // If the IER is already associated with an ERS, there is no need to continue processing
            if( emailResult.emailResultSummary__c == null ) {

                // Grab the relavent ERS record
                EmailResultSummary__c thisERS = accountToERSMap.get( emailResult.contact__r.accountId ).get( emailResult.Name );
                
                if( thisERS != null ) {     // If an ERS already exists on the appropriate Account
                    
                    // Assign ERS to IER
                    emailResult.emailResultSummary__c = thisERS.id;
                
                    // Add IER to list of records to update
                    ierToUpdate.add( emailResult );
                    
                } else {        // If there is no appropriate ERS on the Account
                    
                    // Grab the ERS out of the map of pending ERS records
                    Map<String,EmailResultSummary__c> currentERS = pendingERS.get( emailResult.contact__r.accountId );
                    
                    // If no pending ERS record exists, assign an empty one
                    if( currentERS == null ) {
                        
                        currentERS = new Map<String,EmailResultSummary__c>();
                        
                        pendingERS.put( emailResult.contact__r.accountId, currentERS );
                        
                    }
                    
                    // Assign either existing ERS or empty ERS to variable
                    EmailResultSummary__c nowERS = currentERS.get( emailResult.name );
                    
                    // If requested ERS is null
                    if( nowERS == null ) {
                        
                        // Create a new ERS record
                        nowERS = createNewERS( emailResult.contact__r.accountId, emailResult );
                        
                        // Add to currentERS map
                        currentERS.put( emailResult.name, nowERS );
                        
                        // Add ERS to list of ERS to insert
                        ersToInsert.add( nowERS );
                        
                    }
                    
                    // map Id of IER to corresponding ERS
                    ierIdToERSMap.put( emailResult.id, nowERS );
    
                }
                
            }

        }
        
        // Insert new ERS records
        if( ersToInsert.size() > 0 ) {
            
            insert ersToInsert;
            
        }
        
        // Update remaining IER records with ERS Id
        for( Id ierId : ierIdToERSMap.keySet() ) {
            
            xtma_Individual_Email_Result__c thisIER = emailResults.get( ierId );
            
            EmailResultSummary__c correspondingERS = ierIdToERSMap.get( ierId );
            
            thisIER.emailResultSummary__c = correspondingERS.id;
            
            // Add IER to list of IERs to update
            ierToUpdate.add( thisIER );
            
        }
        
        // Update appropriate IER records
        if( ierToUpdate.size() > 0 ) {
            
            update ierToUpdate;
            
        }
        
    }
    
    private static EmailResultSummary__c createNewERS( Id parentAccountId, xtma_Individual_Email_Result__c emailResult ) {

        // Create new ERS record
        EmailResultSummary__c ers = new EmailResultSummary__c();
        ers.account__c = parentAccountId;
        ers.name = emailResult.name;
        ers.emailSubject__c = emailResult.subject_line__c;

        return ers;

    }
    

    /*
     * Updates various rollup-style fields on ERS records
     */
    webservice static void updateEmailResultSummaryTotals( List<Id> ersIds ) {
        
        List<EmailResultSummary__c> updatedERSList = new List<EmailResultSummary__c>();
        
        for( EmailResultSummary__c currentERS : [select id, emailSubject__c, totalBounced__c, totalOpened__c, totalSent__c, totalUnsubscribed__c, ( select id, date_bounced__c, date_time_sent__c, date_unsubscribed__c, opened__c, subject_line__c from IndividualEmailResults__r ) from EmailResultSummary__c where id in :ersIds] ) {
            
            DateTime dateFirstSent = null;
            String emailSubject = null;
            Integer totalSent = 0;
            Integer totalBounced = 0;
            Integer totalOpened = 0;
            Integer totalUnsubscribed = 0;
            
            for( xtma_Individual_Email_Result__c ier : currentERS.individualEmailResults__r ) {
                
                if( ier.date_time_sent__c != null ) {
                
                    if( dateFirstSent == null ) {
                        
                        dateFirstSent = ier.date_time_sent__c;
                        
                    } else if( ier.date_time_sent__c.getTime() < dateFirstSent.getTime() ) {
                        
                        dateFirstSent = ier.date_time_sent__c;
                        
                    }
                    
                }
                
                if( ier.subject_line__c != null && !ier.subject_line__c.equals( '' ) ) emailSubject = ier.subject_line__c;
                
                totalSent++;
                
                if( ier.date_bounced__c != null ) totalBounced++;
                
                if( ier.opened__c == true ) totalOpened++;
                
                if( ier.date_unsubscribed__c != null ) totalUnsubscribed++;
                
            }
            
            currentERS.dateFirstSent__c = dateFirstSent;
            currentERS.emailSubject__c = emailSubject;
            currentERS.totalBounced__c = totalBounced;
            currentERS.totalOpened__c = totalOpened;
            currentERS.totalSent__c = totalSent;
            currentERS.totalUnsubscribed__c = totalUnsubscribed;
            
            updatedERSList.add( currentERS );
            
        }
        
        update updatedERSList;
        
    }

}