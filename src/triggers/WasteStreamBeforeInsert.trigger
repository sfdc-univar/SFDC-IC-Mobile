trigger WasteStreamBeforeInsert on ChemCare__c (before insert) 
{
	if(trigger.isBefore && trigger.isInsert)
	{
		WasteStreamMethods.WasteStreamBeforeInsert(trigger.new, trigger.oldMap);
	}
}