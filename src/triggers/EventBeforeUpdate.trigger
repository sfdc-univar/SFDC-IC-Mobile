trigger EventBeforeUpdate on Event (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        EventMethods.EventBeforeUpdate(trigger.new, trigger.oldMap);
    }
}