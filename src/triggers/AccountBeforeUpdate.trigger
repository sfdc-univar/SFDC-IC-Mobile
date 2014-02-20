trigger AccountBeforeUpdate on Account (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        AccountMethods.AccountBeforeUpdate(trigger.new, trigger.oldMap);
    }
}