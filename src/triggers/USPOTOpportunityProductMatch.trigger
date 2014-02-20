trigger USPOTOpportunityProductMatch on Opportunity (before insert, before update)
{
	USPOTOpportunityProductMatch.matchOpportunityProductBySKU(trigger.new, trigger.oldMap, trigger.isUpdate);
}