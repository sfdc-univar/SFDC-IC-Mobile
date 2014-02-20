trigger ContactBeforeUpdate on Contact (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        ContactMethods.ContactBeforeUpdate(trigger.new, trigger.oldMap);
    }
}