trigger UserAfterUpdate on User (after update) {
    
    system.debug('in userafterupdate');
        if(trigger.isAfter && trigger.isUpdate)
    {
        system.debug('says after update');
        UserMethods.UserAfterUpdate(trigger.new, trigger.oldMap);     
    }

}