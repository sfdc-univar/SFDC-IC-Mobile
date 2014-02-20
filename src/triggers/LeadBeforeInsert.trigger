trigger LeadBeforeInsert on Lead (before insert) {
    
          
      if(trigger.isBefore && trigger.isInsert)
  {
    LeadMethods.LeadBeforeInsert(trigger.new, trigger.oldMap);
  }

}