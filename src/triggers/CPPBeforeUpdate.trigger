trigger CPPBeforeUpdate on CPP__c (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        CPPMethods.CPPBeforeUpdate(trigger.new, trigger.oldMap);
    }
}