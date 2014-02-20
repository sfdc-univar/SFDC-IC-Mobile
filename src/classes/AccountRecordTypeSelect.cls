public with sharing class AccountRecordTypeSelect{


     Account a;
     PageReference pageRef;
        
     public AccountRecordTypeSelect(ApexPages.StandardController controller) {
        a = (Account) controller.getRecord();
   
      } 
         Public PageReference redirectSelect() {
          RecordType recType = [Select Id, DeveloperName From RecordType WHERE id = :a.RecordTypeId];
          
          Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
          
          if (p.name == 'System Admin - non-SSO'){              
              PageReference pageRef = new Pagereference('/' + a.Id +  '?nooverride=1');
    
              pageRef.setRedirect(true);
              return pageRef; 
          }
          
        else if ( recType.DeveloperName == 'Prospect'){
             PageReference pageRef = Page.ProspectsAccounts;
              pageRef.getParameters().put('id', a.id);
              pageRef.getParameters().put('sfdc.override','1');
              pageRef.setRedirect(true);
              return pageRef; 
             }
             else if ( recType.DeveloperName == 'GS_E'){
             PageReference pageRef = new Pagereference('/' + a.Id +  '?nooverride=1');
              pageRef.getParameters().put('id', a.id);
             // pageRef.getParameters().put('sfdc.override','1');
              pageRef.setRedirect(true);
              return pageRef; 
             }
              else if ( recType.DeveloperName == 'Corporate'){
             PageReference pageRef = Page.CorporateAccounts;
              pageRef.getParameters().put('id', a.id);
              pageRef.getParameters().put('sfdc.override','1');
              pageRef.setRedirect(true);
              return pageRef; 
             }
       
             else if ( recType.DeveloperName == 'CorporateChemCare'){
             PageReference pageRef = Page.ChemCareAccounts;
              pageRef.getParameters().put('id', a.id);
              pageRef.getParameters().put('sfdc.override','1');
              pageRef.setRedirect(true);
              return pageRef; 
             }
             else if ( recType.DeveloperName == 'Consultant_Marketing'){
             PageReference pageRef = Page.MarketAccounts;
              pageRef.getParameters().put('id', a.id);
              pageRef.getParameters().put('sfdc.override','1');
              pageRef.setRedirect(true);
              return pageRef; 
             }
             else if ( recType.DeveloperName == 'ShipTo'){                 
              PageReference pageRef = Page.TabbedAccounts;
              pageRef.getParameters().put('id', a.id);
              pageRef.getParameters().put('sfdc.override','1');
              pageRef.setRedirect(true);
              return pageRef; 
             } 
        return null;
     }
              
 }