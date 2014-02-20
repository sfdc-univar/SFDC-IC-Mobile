trigger CPPBeforeInsert on CPP__c (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		CPPMethods.CPPBeforeInsert(trigger.new, trigger.oldMap);
	}
}