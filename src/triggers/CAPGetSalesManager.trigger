Trigger CAPGetSalesManager on Customer_Account_Plan__c (before insert, before update) {

//2013-06-05 K Miller - created

    // Loop through the incoming records    
    for (Customer_Account_Plan__c cap : Trigger.new) {
            
        string SMId = cap.Sales_Manager_Id__c;
        
        if (string.isBlank(SMId) ) {
           cap.SMLink__c = null;
           cap.SMName__c = '';        
        } 
        else {
            
            SMId = 'i' + cap.Sales_Manager_Id__c;                        
            try {
                List <User> SM = [select id, name from User where alias = :SMId];  
                if (SM.isempty()) {
                    cap.SMLink__c = null; 
                    cap.SMName__c = cap.Sales_Manager__c + ' (' + SMId + ') - alias not in SFDC';
                    //cap.SMName__c = cap.Sales_Manager__c;
                } 
                else {
                    cap.SMLink__c = SM[0].Id; 
                    cap.SMName__c = SM[0].Name;
                }
           // } catch (DMLException e){
            } finally {
                  //exception
            }
        }     
    }
}