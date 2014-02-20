trigger SampleRequestBeforeInsert on SampleRequest__c (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		SampleRequestMethods.SampleRequestBeforeInsert(trigger.new, trigger.oldMap);
	}
}