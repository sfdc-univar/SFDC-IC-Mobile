trigger cloneCAP on Customer_Account_Plan__c (before update) {

    Map<String, Schema.SObjectField> capFieldMap = Schema.SObjectType.Customer_Account_Plan__c.fields.getMap(); 
    Map<String, Schema.SObjectField> historyFieldMap = Schema.SObjectType.Customer_Account_Plan_History__c.fields.getMap();        
    Customer_Account_Plan_History__c[] clonedCapList = new Customer_Account_Plan_History__c[] {};     
    for(Customer_Account_Plan__c oldCap : Trigger.old)
    {
    Integer rh = [SELECT COUNT() FROM Customer_Account_Plan_History__c WHERE Customer_Account_Plan__c = :oldCap.Id];
    String rev = String.valueOf(rh +1);
    
      Customer_Account_Plan_History__c clonedCap = new Customer_Account_Plan_History__c();
      
      clonedCap.Name = 'Revision: ' + rev;
      clonedCap.Customer_Account_Plan__c = oldCap.Id;
      clonedCap.Owner_Name__c = oldCap.Owner_Name__c;
      clonedCap.Net_Readiness__c = oldCap.Net_Readiness_Score__c;
      
      for(String capFieldName : capFieldMap.keySet())
      {
        for(String historyFieldName : historyFieldMap.keySet())
        {
        String strHist = historyFieldName.substringBeforeLast('__');
        
            if(capFieldName.startsWith(strHist) && capFieldName != 'Id' && capFieldName != 'Name')
            {            	
                //System.debug('****** MATCH!!!   HISTORY: ' + historyFieldName + ' ~~~~~~~~~~~~~~ CAPFIELD: ' + capFieldName);
               // Check if history field is actually writeable (controlled by field security)   
                Schema.SObjectField field = historyFieldMap.get(historyFieldName);                                                      
                Schema.DescribeFieldResult fieldResult = field.getDescribe();  
                if(fieldResult.isUpdateable())
                {
                  //system.debug('***** UPDATEABLE FIELD!! *****');
                  clonedCap.put(historyFieldName, oldCap.get(capFieldName));                 
                } //else system.debug(' **** NOT updateable **** ');
            }
        }
      }
      clonedCapList.add(clonedCap);
    }
    insert clonedCapList;	

}