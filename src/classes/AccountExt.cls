public with sharing class AccountExt {


     Account a;
     String capID;
     Customer_Account_Plan__c cplan;
     String tabName;
                
     public AccountExt(ApexPages.StandardController controller) {
        a = (Account) controller.getRecord();
    }
    
    public String getSelectedTab(){
     String tabName = System.currentPageReference().getParameters().get('tabName');
     System.debug('TAB NAME: ' + tabName);
      if(tabName == null){
        tabName = 'AccDetails';
        }
    return tabName;
    }

 
     public void setTabName ( String s ) {
      this.tabName = s;
     }
       
     public String currentId{
         get{return currentId;}
         set{currentId = System.currentPageReference().getParameters().get( 'id' );}
         }
     
     public PageReference getCustomerAccountPlan(){
     currentId = System.currentPageReference().getParameters().get( 'id' );
       
     List<Customer_Account_Plan__c> newcap = [Select Id, Name, Account__c, Sales_Manager__c, 
     Main_Competitor__c, Last_Reviewed__c, CreatedDate, IsClone__c  
     FROM Customer_Account_Plan__c WHERE Account__c =: currentId order by CreatedDate asc];
     
     Integer mysize = newcap.size();
        if(mysize > 0){
        System.debug('*********** size? ' + mysize);
        Customer_Account_Plan__c cplan = newcap[0];
      PageReference cpage= new ApexPages.StandardController(cplan).view();
      cpage.getParameters().put('currentId',currentId); 
      cpage.setRedirect(true);
      
      return cpage;
              } else {
       
     PageReference cpage= new PageReference('/apex/CustomerAccountPlanEdit');
      cpage.getParameters().put('currentId',currentId );
      cpage.setRedirect(true);
      
      return cpage;
       }
        
      // return null;

    }
    
      public list<cHistories> getHistories() {
    
     // Initialize list to be returned
     list<cHistories> list_ch = new list<cHistories>();
     
     // Loop through all field history records
     for (AccountHistory fh: [select 
          AccountId, 
          OldValue, 
          NewValue, 
          IsDeleted, 
          Id, 
          Field, 
          CreatedDate, 
          CreatedById,
          CreatedBy.Name
          From AccountHistory
          where AccountId= :a.id
          order by CreatedDate desc
       Limit 100 ]) {

        String toText = '';
        String fromText = '';
        String skipthis = 'no';
          
        // Create a new wrapper object
        cHistories ch = new cHistories();
      
       // Set the Date datetime.valueOf(stringDate);
        ch.theDate = datetime.valueOf(fh.createddate).format();
       
       // Set who performed the action
        ch.who = fh.createdby.name;
         String fieldName;   
        fieldName = String.valueOf(fh.Field);
        //system.debug('********************FIELDNAME BEFORE TWEAKING IT: ' + fieldName);
        
        if (fieldName == 'DCSOwnerCode__c' ||
            fieldname == 'CCForecastSales__c' ||
            fieldname == 'GroupAccountNumber__c' ||
            fieldname == 'GroupAccountType__c' ||
            fieldname == 'CustomerNumber__c' ||
            fieldname == 'DepartmentCode__c' ||
            fieldname == 'SalesContactName__c' ||
            fieldname == 'ShipToNumber__c' ||
            fieldname == 'TotalChemicalSpend__c' ||
            fieldname == 'AcornTotSalesYTD__c' ||
            fieldname == 'Parent' ||
            fieldname == 'SICName2__c' ||
            fieldname == 'BillingCity' ||
            fieldname == 'BillingState' ||
            fieldname == 'BillingCountry' ||
            fieldname == 'BillingStreet' ||
            fieldname == 'BillingPostalCode') {        

            skipthis = 'yes';        
        }
        
        //Owner & recordtype changes have 2 sets of field history: 
        // First for the text name, then record id.  We only care about the name.
                     
        else if(fieldName == 'Owner'){
            String fieldOldV = String.valueOf(fh.OldValue).trim();
            Integer fieldLength = fieldOldV.length();
            if(fieldLength == 18 && fieldOldV.startsWith('00')==true){           
                //owner id field skip           
                skipthis = 'yes';            
            }        
        }
        
        else if(fieldName == 'RecordType' && fh.OldValue!=null){           
            String fieldOldV = String.valueOf(fh.OldValue).trim(); 
            Integer fieldLength = fieldOldV.length();
            if(fieldLength == 18 && fieldOldV.startsWith('012')==true){           
                //recordtype id field skip           
                skipthis = 'yes';            
            }        
        }
        
        
        if (skipthis == 'no') {        

        //get field label instead of API name - reset fieldName

            Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
    
            for(String gfieldName:fieldMap.keySet()) {
      
                if(gFieldName == fieldName){
                    Schema.DescribeFieldResult fieldDescribe = fieldMap.get(gfieldName).getDescribe();
                    fieldName = fieldDescribe.getLabel();
                    // System.debug('**************************** gField: ' + gfieldName);
                }
            }
      
            if (fh.OldValue != null) {
                try {
                    fromText =  Date.valueOf(fh.OldValue).format();
                } catch (Exception e) {
                    fromText = String.valueOf(fh.OldValue);
                }
            }
        
            try {
                toText =  Date.valueOf(fh.NewValue).format();
            } catch (Exception e) {
                toText = String.valueOf(fh.NewValue);
            }
            
            if (fieldName == 'TextName') fieldName = 'Name';
            else if(fieldname == 'created') fieldname = 'Created';
            else if(fieldname == 'accountCreatedFromLead' ||
                    fieldname == 'accountUpdatedByLead') fieldname = 'Lead Conversion';
            else if(fieldname == 'accountMerged') {
                fieldname = 'Account Merged with ' + fromText;
                fromText = '';
            }
                                    
            ch.FieldLabel = fieldName;
            ch.fromValue = fromText;
            ch.toValue = toText;
            //system.debug('******************** FINAL FIELDNAME: ' + fieldName);
            
      list_ch.add(ch);    
     }    
  }
  
  return list_ch;
}
    
    public class cHistories {
     
     // Class properties
        public String theDate {get; set;}
        public String who {get; set;}
        public String action {get; set;}
        public String fieldLabel {get; set;}
        public String fromValue {get; set;}
        public String toValue {get; set;}
        
        
    }
    

}