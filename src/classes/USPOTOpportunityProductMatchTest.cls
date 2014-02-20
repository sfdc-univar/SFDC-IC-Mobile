@isTest
public with sharing class USPOTOpportunityProductMatchTest
{
	public static testmethod void matchOpportunityProductBySKUTest()
	{
		Product2 upsotNoProduct = new Product2
		(
			Name = 'USPOT No-Product',
			USPOT__c = true
		);
		database.insert(upsotNoProduct);
		
		Product2 product1 = new Product2
		(
			Name = 'testProduct1'
		);
		database.insert(product1);
		
		SKU_Level_Product__c skuProduct1 = new SKU_Level_Product__c
		(
			Name = 'testSKUProduct',
			SFDC_Product__c = product1.Id,
			Product_SKU__c = '123456'
		);
		database.insert(skuProduct1);
		
		Product2 product2 = new Product2
		(
			Name = 'testProduct2'
		);
		database.insert(product2);
		
		SKU_Level_Product__c skuProduct2 = new SKU_Level_Product__c
		(
			Name = 'testSKUProduct',
			SFDC_Product__c = product2.Id,
			Product_SKU__c = '112233'
		);
		database.insert(skuProduct2);
		
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			Product_Code__c = '123456'
		);
		
		Opportunity opp2 = new Opportunity
		(
			Name = 'testOpp2',
			LeadSource = 'USPOT',
			Product_Code__c = '112233'
		);
		
		List<Opportunity> oppsNew = new List<Opportunity>();
		oppsNew.add(opp1);
		oppsNew.add(opp2);
		USPOTOpportunityProductMatch.matchOpportunityProductBySKU(oppsNew, null, false);
		
		system.assertEquals(product1.Id, opp1.Product__c);
		system.assertEquals(product2.Id, opp2.Product__c);
	}
	
	public static testmethod void noMatchOpportunityProductBySKUTest()
	{
		Product2 upsotNoProduct = new Product2
		(
			Name = 'USPOT No-Product',
			USPOT__c = true
		);
		database.insert(upsotNoProduct);
		
		Product2 product = new Product2
		(
			Name = 'testProduct'
		);
		database.insert(product);
		
		SKU_Level_Product__c skuProduct = new SKU_Level_Product__c
		(
			Name = 'testSKUProduct',
			SFDC_Product__c = product.Id,
			Product_SKU__c = '123456'
		);
		database.insert(skuProduct);
		
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			Product_Code__c = '998877'
		);
		
		List<Opportunity> oppsNew = new List<Opportunity>();
		oppsNew.add(opp1);
		USPOTOpportunityProductMatch.matchOpportunityProductBySKU(oppsNew, null, false);
		
		system.assertEquals(upsotNoProduct.Id, opp1.Product__c);
	}
	
	public static testmethod void noMatchAdHocCreateUSPOTProductOpportunityProductBySKUTest()
	{
		Product2 product = new Product2
		(
			Name = 'testProduct'
		);
		database.insert(product);
		
		SKU_Level_Product__c skuProduct = new SKU_Level_Product__c
		(
			Name = 'testSKUProduct',
			SFDC_Product__c = product.Id,
			Product_SKU__c = '123456'
		);
		database.insert(skuProduct);
		
		Opportunity opp1 = new Opportunity
		(
			Name = 'testOpp1',
			LeadSource = 'USPOT',
			Product_Code__c = '998877'
		);
		
		List<Opportunity> oppsNew = new List<Opportunity>();
		oppsNew.add(opp1);
		USPOTOpportunityProductMatch.matchOpportunityProductBySKU(oppsNew, null, false);
		
		Product2 USPOTProduct = [SELECT Id, USPOT__c FROM Product2 WHERE Id = :opp1.Product__c LIMIT 1];
		
		system.assertEquals(true, USPOTProduct.USPOT__c);
	}
}