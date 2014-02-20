public with sharing class USPOTOpportunityProductMatch
{
	public static void matchOpportunityProductBySKU(List<Opportunity> opportunityNew, Map<Id,Opportunity> opportunityOldMap, Boolean isUpdate)
	{
		Set<String> skuNumbers = new Set<String>();
		
		for (Opportunity opp : opportunityNew)
		{
			if (opp.Product_Code__c != null)
			{
				skuNumbers.add(opp.Product_Code__c);
			}
		}
		
		List<SKU_Level_Product__c> skuProducts = null;
		Map<String,Id> productIdsBySKU = new Map<String,Id>();
		Product2 productNotFoundProduct = SetUSPOTNoProduct();

		if (skuNumbers.size() > 0)
		{
			skuProducts = [SELECT Id, Product_SKU__c, SFDC_Product__c FROM SKU_Level_Product__c WHERE Product_SKU__c IN :skuNumbers];
			
			for (SKU_Level_Product__c skuProduct : skuProducts)
			{
				productIdsBySKU.put(skuProduct.Product_SKU__c, skuProduct.SFDC_Product__c);
			}
		}
		
		for (Opportunity opp : opportunityNew)
		{
			Boolean attemptPopulateOpportunityProduct = false;
			Opportunity oldOpportunity = null;
			if (isUpdate)
			{
				oldOpportunity = opportunityOldMap.get(opp.Id);
			}
			
			//  If is UPSOT
			//  And 
			//	Is Create OR Update and Opportunity Product Code is being Changed
			if (opp.LeadSource != null && opp.LeadSource == 'USPOT'
				&&
				(!isUpdate || (isUpdate && oldOpportunity != null && oldOpportunity.Product_Code__c != opp.Product_Code__c)))
			{
				attemptPopulateOpportunityProduct = true;
			}
			
			if (attemptPopulateOpportunityProduct)
			{
				// Product Code is being set on insert/update. Look for a Product Match
				if (opp.Product_Code__c != null)
				{
					Id productId = productIdsBySKU.get(opp.Product_Code__c);
					
					if (productId != null)
					{
						opp.Product__c = productId;
					}
					else //populate with default productNotFound?
					{
						if (productNotFoundProduct != null && productNotFoundProduct.Id != null)
						{
							opp.Product__c = productNotFoundProduct.Id;
						}
					}
				}
				// Product code is being set to null on insert/update.
				else if (opp.Product_Code__c == null)
				{
					if (productNotFoundProduct == null)
					{
						productNotFoundProduct = SetUSPOTNoProduct();
					}
					
					opp.product__c = productNotFoundProduct.Id;
				}
			}
		}
	}
	
	private static Product2 SetUSPOTNoProduct()
	{
		Product2 productNotFoundProduct = null;
		
		List<Product2> productNotFoundProductList = [SELECT Id FROM Product2 WHERE USPOT__c = true LIMIT 1];
						
		if (productNotFoundProductList.size() == 1)
		{
			productNotFoundProduct = productNotFoundProductList[0];
		}
		
		if (productNotFoundProduct ==  null)
		{
			productNotFoundProduct = new Product2
			(
				Name = 'USPOT No-Product',
				USPOT__c = true
			);
			database.insert(productNotFoundProduct);
		}
		
		return productNotFoundProduct;
	}
}