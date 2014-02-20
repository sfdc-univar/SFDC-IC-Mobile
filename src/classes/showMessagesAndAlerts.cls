public with sharing class showMessagesAndAlerts{
 String messageText;
 Messages_Alerts__c m;
 
    public String getMessageText() {
    try{
    m = [SELECT id, Message__c from Messages_Alerts__c LIMIT 1];
    messageText = String.valueOf(m.Message__c);
    System.debug(messageText);
    }catch (QueryException q){
    	//error here
    }
    return messageText;
   }   
}