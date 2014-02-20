@isTest
private class TestAccountMerge {
    static Account account;
    static List<Account> accounts;
    static List<Id> fixedSearchResults;
    static final Integer NUM_OF_ACCOUNTS = 5; 
    
    static void setup() {
        account = TestingUtil.createAccount('testAccount', true);
        accounts = TestingUtil.createAccounts(NUM_OF_ACCOUNTS, 'accountTest', true);
        
        fixedSearchResults = new List<Id>();
        fixedSearchResults.add(account.Id);
        for(Account a:accounts) {
            fixedSearchResults.add(a.Id);
        }
    }
    
    static testMethod void testFindAccounts() {
        final String KEYWORD = 'test';
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
            AccountMerge controller = new AccountMerge();
            controller.searchText = KEYWORD;
            controller.findAccounts();      
        Test.stopTest();
        
        System.assertEquals(NUM_OF_ACCOUNTS+1,controller.results.size(),'The number of accounts found by the query should be the 1 account made and '+NUM_OF_ACCOUNTS+' made');
        
        List<AccountMerge.AccountWrapper> actualAccountWrappers = controller.results;
        
        for(AccountMerge.AccountWrapper aw : actualAccountWrappers) {
            System.assert(aw.account.Name.containsIgnoreCase(KEYWORD),'Each of the accounts pulled back should have ' +KEYWORD+' in their names');
        }
        
    }
    
    static testMethod void testFindAccountsThenFindAccountsAgain() {
        final String KEYWORD = 'test';
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        AccountMerge controller = new AccountMerge();
        controller.searchText = KEYWORD;
        controller.findAccounts();      
        System.assertEquals(NUM_OF_ACCOUNTS+1,controller.results.size(),'The number of accounts found by the query should be the 1 account made and '+NUM_OF_ACCOUNTS+' made');
        List<AccountMerge.AccountWrapper> actualAccountWrappers = controller.results;
        for(AccountMerge.AccountWrapper aw : actualAccountWrappers) {
            System.assert(aw.account.Name.containsIgnoreCase(KEYWORD),'Each of the accounts pulled back should have ' +KEYWORD+' in their names');
        }
        
        Test.startTest();
            controller.findAccounts();
        Test.stopTest();
        
        System.assertEquals(NUM_OF_ACCOUNTS+1,controller.results.size(),'The number of accounts found by the query should be the 1 account made and '+NUM_OF_ACCOUNTS+' made');
    }
    
    static testMethod void testFindAccountsOnLessThan2SearchText() {
        final String BAD_KEYWORD = 't';
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
            AccountMerge controller = new AccountMerge();
            controller.searchText = BAD_KEYWORD;
            controller.findAccounts();      
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),'There should be an error message');
        System.assertEquals(1,ApexPages.getMessages().size(),'There should be an error message');
        System.assertEquals(Label.String_Too_Short,ApexPages.getMessages()[0].getSummary(),'The error message should match the label');
        System.assert(controller.results.isEmpty(),'The search should not have run');       
    }
    
    static testMethod void testFindAccountsOnBlankSearchText() {
        final String BLANK_KEYWORD = ' ';
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        Test.startTest();
            AccountMerge controller = new AccountMerge();
            controller.searchText = BLANK_KEYWORD;
            controller.findAccounts();      
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),'There should be an error message');
        System.assertEquals(1,ApexPages.getMessages().size(),'There should be an error message');
        System.assertEquals(Label.String_Too_Short,ApexPages.getMessages()[0].getSummary(),'The error message should match the label');
        System.assert(controller.results.isEmpty(),'The search should not have run');       
    }
    
    static testMethod void testNextWithTwoAccountsSelected() {
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        AccountMerge controller = new AccountMerge();
        controller.searchText = 'test';
        controller.findAccounts();      
        
        Test.startTest();
            controller.results[0].isChecked = true;
            controller.results[1].isChecked = true;
            
            controller.next();
        Test.stopTest();
        
        String expectedPageUrl = Url.getSalesforceBaseUrl().toExternalForm()+'/merge/accmergewizard.jsp?&goNext=+Next+&cid='+controller.results[0].account.Id+'&cid='+controller.results[1].account.Id;
        
        System.assertEquals(expectedPageUrl, controller.nextUrl,'The page should go to the standard merge page with those selected accounts');
    }
    
    static testMethod void testNextWithThreeAccountsSelected() {
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        AccountMerge controller = new AccountMerge();
        controller.searchText = 'test';
        controller.findAccounts();      
        
        Test.startTest();
            controller.results[0].isChecked = true;
            controller.results[1].isChecked = true;
            controller.results[2].isChecked = true;
            
            controller.next();
        Test.stopTest();
        
        String expectedPageUrl = Url.getSalesforceBaseUrl().toExternalForm()+'/merge/accmergewizard.jsp?&goNext=+Next+&cid='+controller.results[0].account.Id+'&cid='+controller.results[1].account.Id+'&cid='+controller.results[2].account.Id;
        System.assertEquals(expectedPageUrl, controller.nextUrl,'The page should go to the standard merge page with those selected accounts');
    }
    
    static testMethod void testNextWithFourAccountsSelected() {
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        AccountMerge controller = new AccountMerge();
        controller.searchText = 'test';
        controller.findAccounts();      
        
        Test.startTest();
            controller.results[0].isChecked = true;
            controller.results[1].isChecked = true;
            controller.results[2].isChecked = true;
            controller.results[3].isChecked = true;
            
            controller.next();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),'There should be an error message');
        System.assertEquals(1,ApexPages.getMessages().size(),'There should be an error message');
        System.assertEquals(Label.Too_Many_Accounts_Selected,ApexPages.getMessages()[0].getSummary(),'The error message should match the label');
        System.assert(String.isBlank(controller.nextUrl),'The next url should not be set');
    }
    
    static testMethod void testNextWithOneAccountSelected() {
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        AccountMerge controller = new AccountMerge();
        controller.searchText = 'test';
        controller.findAccounts();      
        
        Test.startTest();
            controller.results[0].isChecked = true;
            
            controller.next();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),'There should be an error message');
        System.assertEquals(1,ApexPages.getMessages().size(),'There should be an error message');
        System.assertEquals(Label.Select_More_Accounts,ApexPages.getMessages()[0].getSummary(),'The error message should match the label');
        System.assert(String.isBlank(controller.nextUrl),'The next url should not be set');
    }
    
    static testMethod void testNextWithNoAccountsSelected() {
        setup();
        
        Test.setFixedSearchResults(fixedSearchResults);
        AccountMerge controller = new AccountMerge();
        controller.searchText = 'test';
        controller.findAccounts();      
        
        Test.startTest();
            controller.next();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR),'There should be an error message');
        System.assertEquals(1,ApexPages.getMessages().size(),'There should be an error message');
        System.assertEquals(Label.Select_More_Accounts,ApexPages.getMessages()[0].getSummary(),'The error message should match the label');
        System.assert(String.isBlank(controller.nextUrl),'The next url should not be set');
    }
    
   
}