trigger TaskBeforeUpdate on Task (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        TaskMethods.TaskBeforeUpdate(trigger.new, trigger.oldMap);
    }
}