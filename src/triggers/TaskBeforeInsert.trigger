trigger TaskBeforeInsert on Task (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		TaskMethods.TaskBeforeInsert(trigger.new, trigger.oldMap);
	}
}