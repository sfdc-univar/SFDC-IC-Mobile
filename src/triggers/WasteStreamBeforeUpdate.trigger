trigger WasteStreamBeforeUpdate on ChemCare__c (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        WasteStreamMethods.WasteStreamBeforeUpdate(trigger.new, trigger.oldMap);
    }
}