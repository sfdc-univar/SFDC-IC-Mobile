public with sharing class USPOTOpportunityTypeWorkflowRuleTest
{
	public static testmethod void USPOTIntegrationSetOpportunityTypeToDevelopmentalTest()
	{
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			StageName = 'Qualify',
			CloseDate = system.today(),
			USPOT_Insight_Type__c = 'Prospects'
		);
		insert(opp1);
		
		Opportunity opp1PostWF = [SELECT Id, Opportunity_Type__c FROM Opportunity WHERE Id = :opp1.Id];
		
		system.assertEquals('Developmental', opp1PostWF.Opportunity_Type__c);
	}
	
	public static testmethod void USPOTIntegrationSetOpportunityTypeToVolumeChurnMaintainCurrentBusinessTest()
	{
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			StageName = 'Qualify',
			CloseDate = system.today(),
			USPOT_Insight_Type__c = 'Order at Risk'
		);
		insert(opp1);
		
		Opportunity opp2 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			StageName = 'Qualify',
			CloseDate = system.today(),
			USPOT_Insight_Type__c = 'Baskets at Risk'
		);
		insert(opp2);
		
		Opportunity opp1PostWF = [SELECT Id, Opportunity_Type__c FROM Opportunity WHERE Id = :opp1.Id];
		Opportunity opp2PostWF = [SELECT Id, Opportunity_Type__c FROM Opportunity WHERE Id = :opp2.Id];
		
		system.assertEquals('Volume Churn:Maintain Current Business', opp1PostWF.Opportunity_Type__c);
		system.assertEquals('Volume Churn:Maintain Current Business', opp2PostWF.Opportunity_Type__c);
	}
	
	public static testmethod void USPOTIntegrationSetOpportunityTypeToVolumeGrowthCompetitorCurrentBusinessTest()
	{
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			StageName = 'Qualify',
			CloseDate = system.today(),
			USPOT_Insight_Type__c = 'Next Product to Sell'
		);
		insert(opp1);
		
		Opportunity opp1PostWF = [SELECT Id, Opportunity_Type__c FROM Opportunity WHERE Id = :opp1.Id];
		
		system.assertEquals('Volume Growth:Competitor Current Business', opp1PostWF.Opportunity_Type__c);
	}
	
	public static testmethod void USPOTIntegrationSetOpportunityTypeToVolumeGrowthUnivarExistingBusinessTest()
	{
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			StageName = 'Qualify',
			CloseDate = system.today(),
			USPOT_Insight_Type__c = 'Dormant Quote'
		);
		insert(opp1);
		
		Opportunity opp1PostWF = [SELECT Id, Opportunity_Type__c FROM Opportunity WHERE Id = :opp1.Id];
		
		system.assertEquals('Volume Growth:Univar Existing Business', opp1PostWF.Opportunity_Type__c);
	}
}