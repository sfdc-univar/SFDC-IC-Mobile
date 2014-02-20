public class showMessagesAndAlertsTest{


@isTest
public static void getMessageTextTest(){

showMessagesAndAlerts controller = new showMessagesAndAlerts();

String messageText = controller.getMessageText();

    System.debug(messageText);
    System.AssertNotEquals(messageText,'');  
  
    }

}