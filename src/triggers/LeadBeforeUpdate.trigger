trigger LeadBeforeUpdate on Lead (before update) {
    
 if(trigger.isBefore && trigger.isUpdate)
    {
        LeadMethods.LeadBeforeUpdate(trigger.new, trigger.oldMap);     
    }

}