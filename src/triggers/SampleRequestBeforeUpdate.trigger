trigger SampleRequestBeforeUpdate on SampleRequest__c (before update) 
{
    if(trigger.isBefore && trigger.isUpdate)
    {
        SampleRequestMethods.SampleRequestBeforeUpdate(trigger.new, trigger.oldMap);
    }
}