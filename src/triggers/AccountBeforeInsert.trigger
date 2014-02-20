trigger AccountBeforeInsert on Account (before insert) 
{
    if(trigger.isBefore && trigger.isInsert)
    {
        AccountMethods.AccountBeforeInsert(trigger.new, trigger.oldMap);
    }
}