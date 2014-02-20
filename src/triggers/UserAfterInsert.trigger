trigger UserAfterInsert on User (after insert) {
    
    if(trigger.isAfter && trigger.isInsert)
    {
        UserMethods.UserAfterInsert(trigger.new, trigger.oldMap);     
    }

}