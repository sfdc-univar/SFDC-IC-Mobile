trigger UserBeforeInsert on User (before insert) {
    
 if(trigger.isBefore && trigger.isInsert)
    {
        UserMethods.UserBeforeInsert(trigger.new, trigger.oldMap);     
    }


}