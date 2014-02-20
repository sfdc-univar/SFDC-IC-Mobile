public class EmailSummaryControllerTests {
    //2013-11-11 Country/State Picklists - K Miller - change to update ShippingStateCode instead of ShippingState
    
    @isTest
    public static void testEmailSummaryController() {
        
        List<xtma_Individual_Email_Result__c> iers = new List<xtma_Individual_Email_Result__c>();
        
        Account account = new Account();
        account.name = 'Acme Test Account 2';
        account.ShippingCity = 'Los Angeles';
        account.ShippingStateCode = 'CA';
        
        insert account;
        
        Contact contact = new Contact();
        contact.lastName = 'Doe';
        contact.AccountId = account.id;
        contact.Email = 'test.me@te4st.com';
        insert contact;
        
        xtma_Individual_Email_Result__c ier1 = new xtma_Individual_Email_Result__c();
        ier1.contact__c = contact.id;
        ier1.date_bounced__c = DateTime.newInstance( 2009, 1, 1 );
        ier1.date_time_sent__c = DateTime.newInstance( 2009, 1, 1 );
        ier1.date_unsubscribed__c = DateTime.newInstance( 2009, 1, 1 );
        ier1.from_address__c = 'test@test.com';
        ier1.from_name__c = 'jon doe';
        ier1.name = 'bulksend';
        ier1.number_of_total_clicks__c = 3;
        ier1.number_of_unique_clicks__c = 2;
        ier1.opened__c = true;
        ier1.subject_line__c = 'test bulk send';
        
        iers.add( ier1 );
        
        xtma_Individual_Email_Result__c ier2 = new xtma_Individual_Email_Result__c();
        ier2.contact__c = contact.id;
        ier1.date_time_sent__c = DateTime.newInstance( 2006, 1, 1 );
        ier2.from_address__c = 'test@test.com';
        ier2.from_name__c = 'jon doe';
        ier2.name = 'bulksend';
        ier2.number_of_total_clicks__c = 3;
        ier2.number_of_unique_clicks__c = 2;
        ier2.opened__c = true;
        ier2.subject_line__c = 'test bulk send';
                
        iers.add( ier2 );
        
        insert iers;
        
        Set<Id> ierIds = new Set<id>();
        for( xtma_Individual_Email_Result__c ier : iers ) ierIds.add( ier.id );
        
        EmailSummaryController.updateEmailResultSummaryRecord( ierIds );
        
        EmailResultSummary__c ers1 = new EmailResultSummary__c();
        ers1.name = 'test ers 1';
        insert ers1;
        
        ier2.emailResultSummary__c = ers1.id;
        update ier2;
    
    // Create set of unique ERS records to update
    Set<Id> ersIds = new Set<Id>();
    for( xtma_Individual_Email_Result__c emailResult : iers ) {
        
        if( emailResult.emailResultSummary__c != null ) ersIds.add( emailResult.emailResultSummary__c );
        
    }
    
    if( ersIds.size() > 0 ) {
        
        List<Id> ids = new List<Id>();
        for( Id ersId : ersIds ) {
            ids.add( ersId );
        }
        
        EmailSummaryController.updateEmailResultSummaryTotals( ids );
        
    }
        
        
        //addIERToERS( Map<Id,xtma_Individual_Email_Result__c> emailResults )
        //insert iers;
        
    }

}