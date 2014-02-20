@isTest(SeeAllData=true)
public class opportunityTagContentTest{

    
 static testMethod void opportunityTagContentTestExisting(){
    String tagN;
    String fixTag;
    String oldTag;

    Opportunity o = [Select Id, Name FROM Opportunity Limit 1];
    o.StageName='Build';
    
      try {
          update o;
          } catch (DMLException e) {
          //exception
      }
      
      o = [Select Id, Name FROM Opportunity Where ID =: o.Id];   
       o.StageName='Learn/Identify';
       
      //update stage
                try {
          update o;
          } catch (DMLException e) {
          //exception
      }
         
     }    

  
 
     static testMethod void opportunityTagContentTestNew(){
    String tagN;
    String fixTag;
    String oldTag;
    
    Opportunity opnew = new Opportunity(Name='Test',Product__c='01t30000001Gpxs',Annual_LBs__c=1,
    Est_GMDollar__c=1,CloseDate=Date.today(),Opportunity_Type__c='Developmental',StageName='Learn/Identify');
    
    try {
    insert opnew ;
    } catch (DMLException r) {
    //exception
    }
  
    
 }
 
 }