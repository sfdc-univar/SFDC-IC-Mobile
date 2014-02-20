trigger ContactBeforeInsert on Contact (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		ContactMethods.ContactBeforeInsert(trigger.new, trigger.oldMap);
	}
}