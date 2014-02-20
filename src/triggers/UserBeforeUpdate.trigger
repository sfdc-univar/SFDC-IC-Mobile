trigger UserBeforeUpdate on User (before update) {
    
 if(trigger.isBefore && trigger.isUpdate)
    {
        UserMethods.UserBeforeUpdate(trigger.new, trigger.oldMap);     
    }

}