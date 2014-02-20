global class AvailableLicenseScheduler implements Schedulable{
	
	
global void execute(SchedulableContext SC){

User u = [select id, Name from User WHERE IsActive=true AND Name LIKE 'Admin%' Limit 1];
//uid is the target object required - so pick an admin
String uid = u.id;

String[] toAddresses = new String[]{'sfdcapplicationteam@univarusa.com'};
String[] userEmail = new String[] {'UnivarIdentityManagement@univarusa.com'};
	
 EmailTemplate templateId = [Select id from EmailTemplate where DeveloperName = 'License_Alert'];
        Messaging.reserveSingleEmailCapacity(2);

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(userEmail);
        mail.setTargetObjectID(uid);
        mail.setTemplateID(templateId.Id);
        mail.setSaveAsActivity(false);
       
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSenderDisplayName('Univar Salesforce.com Support Team ');
        mail.setReplyTo('salesforcecom@univarusa.com');

        System.debug('********* SENDING ************* ' + toAddresses);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}