trigger EventBeforeInsert on Event (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		EventMethods.EventBeforeInsert(trigger.new, trigger.oldMap);
	}
}