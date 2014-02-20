trigger OpportunityBeforeInsert on Opportunity (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		OpportunityMethods.OpportunityBeforeInsert(trigger.new, trigger.oldMap);
	}
}