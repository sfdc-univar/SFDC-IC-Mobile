/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 *
 *
 * This class is a helper class for creating unit test data. 
 * The purpose of this class is to centralize record creation, deletion and updates for tests, so that
 * any changes in validation rules, workflows, triggers and other things that might break the tests,
 * can be fixed in one place. 
 * As we make changes to the Unit tests over time, we will migrate DML statements to this class.
 */

@isTest
public class UnitTestHelper 
{
    
    public static boolean userSaveSuccess = false;
    public static User createUser(string alias, string lastName, Id ProfileId) 
    {
        User user = new User(Alias = alias, lastname = lastname, Email = 'abc9@univarusa.com' ,
         emailencodingkey = 'UTF-8', languagelocalekey = 'en_US', localesidkey = 'en_US',
         profileid = ProfileId , timezonesidkey = 'America/Los_Angeles', username = alias + Math.ROUND(Math.Random()*10) + '@univarusa.com',
         UserRoleId=UserInfo.getUserRoleId()) ;
        Database.Saveresult saveResult = Database.insert (user);
        userSaveSuccess = saveResult.isSuccess();
        return user;
    }  

    
    public static boolean accountSaveSuccess = false;
    public static Account createAccount(string accName) 
    //2013-11-11 Country/State Picklists - K Miller - change to update State & Country 'Code' fields
    {
        Account account = new Account();
        account.Type = 'Customer';
        account.Industry = 'Consumer Services';
        account.Name = accName;
        account.phone = '206 999 9999';
        account.website = 'www.testdatawebsite.com';
        account.BillingStreet = '101 Main St';
        account.BillingCity = 'Seattle';
        account.BillingStateCode = 'WA';
        account.BillingPostalCode = '98101';
        account.BillingCountryCode = 'US';
        account.ShippingStreet = '101 Main St';
        account.ShippingCity = 'Seattle';
        account.ShippingStateCode = 'WA';
        account.ShippingPostalCode = '98101';
        account.ShippingCountryCode = 'US';
        Database.Saveresult saveResult = Database.insert (account);
        accountSaveSuccess = saveResult.isSuccess();
        return account;

    }   
    
    public static boolean leadSaveSuccess = false;
    public static Lead createLead(string companyName, string firstName, string lastName) 
    {
        Lead lead = new Lead();
        lead.FirstName = firstName;
        lead.LastName = lastName;
        lead.Company = companyName;
        Database.Saveresult saveResult = Database.insert (lead);
        leadSaveSuccess = saveResult.isSuccess();
        return lead;

    }  

    public static boolean opportunitySaveSuccess = false;
    public static Opportunity createOpportunity(Account account, String oppName, String oppType) 
    {
        Opportunity opportunity = new Opportunity();
        opportunity.accountId = account.Id;
        opportunity.Name = oppName;
        opportunity.CloseDate = system.today() + 30;
        opportunity.StageName = 'Build';
        opportunity.Type = oppType;
        Database.Saveresult saveResult = Database.insert (opportunity);
        opportunitySaveSuccess = saveResult.isSuccess();
        return opportunity;
    }

    public static boolean capSaveSuccess = false;
    public static Customer_Account_Plan__c createCap(Account account) 
    {
        Customer_Account_Plan__c cap = new Customer_Account_Plan__c();
        cap.Account__c= account.Id;
        cap.What_changes_are_happening__c = 'Test';
        Database.Saveresult saveResult = Database.insert (cap);
        capSaveSuccess = saveResult.isSuccess();
        return cap;
    }    
}