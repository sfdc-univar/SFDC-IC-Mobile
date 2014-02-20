trigger OpportunityBeforeUpdate on Opportunity (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        OpportunityMethods.OpportunityBeforeUpdate(trigger.new, trigger.oldMap);
    }
}