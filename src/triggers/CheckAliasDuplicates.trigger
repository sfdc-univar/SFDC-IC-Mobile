trigger CheckAliasDuplicates on User (after insert, after update) {
//check the Trigger Controls custom setting first
Trigger_Controls__c TC = Trigger_Controls__c.getInstance();
System.debug('************************* GIAM **********************');
if (TC.Giam_Trigger__c == true) {
    System.debug('**********************  Giam_Trigger: ' + TC.Giam_Trigger__c);
for (User u : Trigger.new)
      {
          //check for xxxxx alias created from Ping
          if(u.Alias != 'xxxxx'){
         //If count is greater than 1 there is a duplicate.  After insert includes the current User alias
         Integer i = [ select count() from User where Alias = :u.Alias];
         if (i > 1)
           {
                u.alias.addError('A User with this Alias already exists!');
           }   
        }
        
        if(Trigger.isUpdate){
        String userEmail = u.Email;
        
        //get the old and new role to compare
        Id oldRole = String.valueOf(System.Trigger.oldMap.get(u.Id).UserRoleId);
        Id newRole = u.UserRoleId;
        System.debug('************ OLD: ' + oldRole + ' *************** NEW: ' + newRole);
        
        //test users parking lot UserRole
         if (oldRole == '00E30000000rcfF'){
         System.debug('************************** OLD ROLE MATCH ********************');
             if(newRole != '00E30000000rcfF') {
        //brand new user, send the welcome email letter
        System.debug('XXXXXXXXXXXXX New User Send Email');
        
        EmailTemplate templateId = [Select id from EmailTemplate where DeveloperName = 'New_User_Welcome'];
        Messaging.reserveSingleEmailCapacity(2);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail}; 
        mail.setTargetObjectID(u.Id);
        mail.setTemplateID(templateId.Id);
        mail.setSaveAsActivity(false);
       
        mail.setToAddresses(toAddresses);
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSenderDisplayName('Univar Salesforce.com Support Team ');
        mail.setReplyTo('salesforcecom@univarusa.com');

        System.debug('********* SENDING ************* ' + toAddresses);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        else {
        System.debug('XXXXXXXXXXXXXXXXXXXXXXXXX No Email Sent XXXXXXXXXXXXXXXXX');
        }
     }   
   }
}

}