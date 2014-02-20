@isTest
private class F2Sell_ReportBuilder2Test {

    static testMethod void createInstanceOfController() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        System.Assert(f2s!=NULL, 'Controller should not be null');
    }
    
    static testMethod void testCallsData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_Activity_Snapshot__c[] callsData = getCallsData(runningUser, 'test', count);
        insert callsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshCallData();
        System.Assert(!f2s.filteredCallsDataList.isEmpty(), 'Call List should not be empty');
        System.Assert(f2s.filteredCallsDataList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count, f2s.filteredCallsData.get(runningUser.Id).totalCount, 'Total should be total rows per total calls');
		System.Assert(f2s.summaryRowMap.get('calls')!=NULL, 'Should have a calls summary row');
        System.AssertEquals(count*count, f2s.summaryRowMap.get('calls').totalCount, 'Total for the summary should match the one row total');
    }
    
    static testMethod void testOppsCountData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_Opportunity_Snapshot__c[] oppsData = getOppsData(runningUser, 'test', count, null);
        insert oppsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshOpportunityCountData();
        System.Assert(!f2s.filteredOppsDataList.isEmpty(), 'List should not be empty');
        System.Assert(f2s.filteredOppsDataList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count, f2s.filteredOppsData.get(runningUser.Id).totalCount, 'Total should be total rows per total');
		System.Assert(f2s.summaryRowMap.get('oppCounts')!=NULL, 'Should have a summary row');
        System.AssertEquals(count*count, f2s.summaryRowMap.get('oppCounts').totalCount, 'Total for the summary should match the one row total');
    }
	
	static testMethod void testOppsWonCountData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_Opportunity_Snapshot__c[] oppsData = getOppsData(runningUser, 'test', count, 'Closed Won');
        insert oppsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshOppsClosedWonData();
		f2s.refreshDistrictSummary();
        System.Assert(!f2s.filteredOppClosedWonList.isEmpty(), 'List should not be empty');
        System.Assert(f2s.filteredOppClosedWonList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count, f2s.filteredOppClosedWonData.get(runningUser.Id).totalCount, 'Total should be total rows per total');
		System.Assert(f2s.summaryRowMap.get('oppsWon')!=NULL, 'Should have a summary row');
        System.AssertEquals(count*count, f2s.summaryRowMap.get('oppsWon').totalCount, 'Total for the summary should match the one row total');
    }
    
    static testMethod void testOppsSalesData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_Opportunity_Snapshot__c[] oppsData = getOppsData(runningUser, 'test', count, null);
        insert oppsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshOpportunityDollarData();
        System.Assert(!f2s.filteredOppDollarDataList.isEmpty(), 'List should not be empty');
        System.Assert(f2s.filteredOppDollarDataList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count*100, f2s.filteredOppDollarData.get(runningUser.Id).totalCount, 'Total should be total rows per total');
		System.Assert(f2s.summaryRowMap.get('oppDollars')!=NULL, 'Should have a summary row');
        System.AssertEquals(count*count*100, f2s.summaryRowMap.get('oppDollars').totalCount, 'Total for the summary should match the one row total');
    }
	
	static testMethod void testOppsWonSalesData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_Opportunity_Snapshot__c[] oppsData = getOppsData(runningUser, 'test', count, 'Closed Won');
        insert oppsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshOppsClosesWonDollarData();
		f2s.refreshDistrictSummary();
        System.Assert(!f2s.filteredOppClosedWonDollarList.isEmpty(), 'List should not be empty');
        System.Assert(f2s.filteredOppClosedWonDollarList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count*100, f2s.filteredOppClosedWonDollarData.get(runningUser.Id).totalCount, 'Total should be total rows per total');
		System.Assert(f2s.summaryRowMap.get('oppsWonDollars')!=NULL, 'Should have a summary row');
        System.AssertEquals(count*count*100, f2s.summaryRowMap.get('oppsWonDollars').totalCount, 'Total for the summary should match the one row total');
    }
    
    static testMethod void testCppCountData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_CPP_Snapshot__c[] cppsData = getCppsData(runningUser, 'test', count);
        insert cppsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshCppCountData();
        System.Assert(!f2s.filteredCppDataList.isEmpty(), 'Call List should not be empty');
        System.Assert(f2s.filteredCppDataList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count, f2s.filteredCppData.get(runningUser.Id).totalCount, 'Total should be total rows per total calls');
		System.Assert(f2s.summaryRowMap.get('cppCounts')!=NULL, 'Should have a summary row');
        System.AssertEquals(count*count, f2s.summaryRowMap.get('cppCounts').totalCount, 'Total for the summary should match the one row total');
    }
    
    static testMethod void testCppLbsData() {
        F2Sell_ReportBuilder2 f2s = new F2Sell_ReportBuilder2();
        Integer count = 20;
        User runningUser = [SELECT Id, Name, UserRoleId FROM User WHERE Id = :UserInfo.getUserId()][0];
        F2S_CPP_Snapshot__c[] cppsData = getCppsData(runningUser, 'test', count);
        insert cppsData;
        f2s.selectedRoleId = String.valueOf(runningUser.UserRoleId);
        f2s.refreshCppLbsData();
        System.Assert(!f2s.filteredCppLbsDataList.isEmpty(), 'Call List should not be empty');
        System.Assert(f2s.filteredCppLbsDataList.size()>0, 'Should have many rows');
        System.AssertEquals(count*count*100, f2s.filteredCppLbsData.get(runningUser.Id).totalCount, 'Total should be total rows per total calls');
		System.Assert(f2s.summaryRowMap.get('cppLbs')!=NULL, 'Should have a summary row');
        System.AssertEquals(count*count*100, f2s.summaryRowMap.get('cppLbs').totalCount, 'Total for the summary should match the one row total');
    }
    
    static F2S_Activity_Snapshot__c[] getCallsData(User userOwner, String name, Integer count) {
    	F2S_Activity_Snapshot__c[] callsData = new List<F2S_Activity_Snapshot__c>();
    	for(integer i = 0; i < count; i++) {
    		String nameString = name + String.valueOf(i);
    		F2S_Activity_Snapshot__c callData = new F2S_Activity_Snapshot__c();
    		callData.Name = nameString;
      		callData.Count__c = count;
    		callData.Date__c = System.Today().addDays(-7-(i*7));
    		callData.Role_ID__c = String.valueOf(userOwner.UserRoleId).left(15);
    		callData.User_ID__c = String.valueOf(userOwner.Id).left(15);
    		callsData.add(callData);	
    	}
    	return callsData;	
    }
    
    static F2S_Opportunity_Snapshot__c[] getOppsData(User userOwner, String name, Integer count, String stage) {
    	F2S_Opportunity_Snapshot__c[] oppsData = new List<F2S_Opportunity_Snapshot__c>();
    	for(integer i = 0; i < count; i++) {
    		String nameString = name + String.valueOf(i);
    		F2S_Opportunity_Snapshot__c oppData = new F2S_Opportunity_Snapshot__c();
    		oppData.Name = nameString;
     		oppData.Count__c = count;
			oppData.Stage__c = stage;
    		oppData.Date__c = System.Today().addDays(-7-(i*7));
    		oppData.Est_Sales__c = count * 100;
    		oppData.Role_ID__c = String.valueOf(userOwner.UserRoleId).left(15);
    		oppData.User_ID__c = String.valueOf(userOwner.Id).left(15);
    		oppsData.add(oppData);	
    	}
    	return oppsData;	
    }
    
    static F2S_CPP_Snapshot__c[] getCppsData(User userOwner, String name, Integer count) {
    	F2S_CPP_Snapshot__c[] cppsData = new List<F2S_CPP_Snapshot__c>();
    	for(integer i = 0; i < count; i++) {
    		String nameString = name + String.valueOf(i);
    		F2S_CPP_Snapshot__c cppData = new F2S_CPP_Snapshot__c();
    		cppData.Name = nameString;
    		cppData.Count__c = count;
    		cppData.Date__c = System.Today().addDays(-7-(i*7));
    		cppData.Total_Annual_Lbs__c = count * 100;
    		cppData.Role_ID__c = String.valueOf(userOwner.UserRoleId).left(15);
    		cppData.User_ID__c = String.valueOf(userOwner.Id).left(15);
    		cppsData.add(cppData);	
    	}
    	return cppsData;	
    }
}