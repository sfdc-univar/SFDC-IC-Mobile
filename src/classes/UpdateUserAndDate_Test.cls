@isTest (SeeAllData=true)
public class UpdateUserAndDate_Test 
{
//2013-11-11 Country/State Picklists - K Miller - change to update ShippingStateCode instead of ShippingState
   static testmethod void testUserFields_as_SysAdmin() 
   {
   
        //First run as a SysAdmin
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u1 = [SELECT Id FROM User WHERE ProfileId = :p1.Id LIMIT 1];
      
        System.runAs(u1) 
        {
            Product2 prod = new Product2(Name='testprod', IsActive=true);
            insert prod;
            
        //0.ACCOUNT - Creates new account that this user can view, at same time as testing
            Account acct_u1 = new Account(Name = 'Test Account 1', OwnerId = u1.id, ShippingCity ='Seattle', ShippingStateCode='WA');
            insert acct_u1;
            
            // Test values after initial insert: s/b values from the "u1" SysAdmin User we're running as
            Account a1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Account where Id = :acct_u1.Id];
            System.assertEquals(a1.UserLastModifiedBy__c, null);
            System.assertEquals(a1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed 
            a1.UserLastModifiedDate__c = datetime.now();           
            update a1;
            Account a2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Account where Id = :a1.Id];
            System.assertEquals(a2.UserLastModifiedBy__c, null);
            System.assertEquals(a2.UserLastModifiedDate__c, null);
            
        //1. CONTACT
            Contact c = new Contact(AccountId = acct_u1.id, LastName = 'tester', Email='Test@univarusa.com', Phone='555-555-5555');
            //insert record to start beforeInsert trigger - this first one should work
            try{insert c;} 
                catch(System.DMLException e){ } 
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            Contact c1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Contact where Id = :c.Id];
            System.assertEquals(c1.UserLastModifiedBy__c, null);
            System.assertEquals(c1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            c1.UserLastModifiedDate__c = datetime.now();
            update c1;
            Contact c2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Contact where Id = :c1.Id];
            System.assertEquals(c2.UserLastModifiedBy__c, null);
            System.assertEquals(c2.UserLastModifiedDate__c, null);
            
        //2. OPPORTUNITY
            Opportunity opp = new Opportunity(AccountId = acct_u1.Id, Name = 'SysAdmin Test Opp', 
            CloseDate = System.today(),StageName = 'Negotiation/Review');
            //insert record to start beforeInsert trigger - this first one should work
            try{insert opp;}
                catch(System.DMLException e){ } 
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            Opportunity opp1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Opportunity where Id = :opp.Id];
            System.assertEquals(opp1.UserLastModifiedBy__c, null);
            System.assertEquals(opp1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            opp1.UserLastModifiedDate__c = datetime.now();
            update opp1;
            Opportunity opp2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Opportunity where Id = :opp1.Id];
            System.assertEquals(opp2.UserLastModifiedBy__c, null);
            System.assertEquals(opp2.UserLastModifiedDate__c, null);   
            
         //3. CPP 
            CPP__c cpp = new CPP__c(AccountId__c = acct_u1.id, Product2Id__c = prod.Id, Supplier__c = 'testsupp', Source__c='Other');   
            //insert record to start beforeInsert trigger - this first one should work
            try{insert cpp;}
              catch(System.DMLException e){}
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            CPP__c cpp1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from CPP__c where Id = :cpp.Id];
            System.assertEquals(cpp1.UserLastModifiedBy__c, null);
            System.assertEquals(cpp1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            cpp1.UserLastModifiedDate__c = datetime.now();
            update cpp1;
            CPP__c cpp2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from CPP__c where Id = :cpp1.Id];
            System.assertEquals(cpp2.UserLastModifiedBy__c, null);
            System.assertEquals(cpp2.UserLastModifiedDate__c, null);         
   
         //4. WasteStreams (ChemCare__c)
            ChemCare__c cppc = new ChemCare__c(AccountId__c = acct_u1.Id, EventOnGoingBusiness__c = 'Ongoing Business', 
             WasteStreamName__c = '111 Spent pickle liquor', PhysicalState__c = 'Gas', ContainerType__c = 'Dump Truck', DisposalTechnology__c = 'Treatment');    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert cppc;}
              catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            ChemCare__c cppc1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from ChemCare__c where Id = :cppc.Id];
            System.assertEquals(cppc1.UserLastModifiedBy__c, null);
            System.assertEquals(cppc1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            cppc1.UserLastModifiedDate__c = datetime.now();
            update cppc1;
            ChemCare__c cppc2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from ChemCare__c where Id = :cppc1.Id];
            System.assertEquals(cppc2.UserLastModifiedBy__c, null);
            System.assertEquals(cppc2.UserLastModifiedDate__c, null);
             
         //5. SAMPLE REQUEST
            SampleRequest__c sample = new SampleRequest__c(AccountId__c = acct_u1.id, ContactId__c = c.id,ShipUrgency__c = 'testurg',
            RequestDate__c = system.today(),Producer_NAME__c = 'testproducer',product2ID__c=prod.id,
            ProductDescription__c = 'testproddesc',IndustryApplication__c='testind',
            SpecificApplicationUse__c='testspecapp');    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert sample;}
              catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            SampleRequest__c sample1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from SampleRequest__c where Id = :sample.Id];
            System.assertEquals(sample1.UserLastModifiedBy__c, null);
            System.assertEquals(sample1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            sample1.UserLastModifiedDate__c = datetime.now();
            update sample1;
            SampleRequest__c sample2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from SampleRequest__c where Id = :sample1.Id];
            System.assertEquals(sample2.UserLastModifiedBy__c, null);
            System.assertEquals(sample2.UserLastModifiedDate__c, null);         

        //6. EVENT
            Event ev = new Event(WhatId = acct_u1.id, OwnerId = u1.id,Subject = 'test',
             StartDateTime = system.now(),EndDateTime = system.now());    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert ev;}
              catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            Event ev1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Event where Id = :ev.Id];
            System.assertEquals(ev1.UserLastModifiedBy__c, null);
            System.assertEquals(ev1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            ev1.UserLastModifiedDate__c = datetime.now();
            update ev1;
            Event ev2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Event where Id = :ev1.Id];
            System.assertEquals(ev2.UserLastModifiedBy__c, null);
            //System.assertEquals(ev2.UserLastModifiedDate__c, null);   
            
        //7. TASK
            Task tsk = new Task(WhatId = acct_u1.id, OwnerId = u1.id,Subject = 'test',
            Status = 'test status',Priority = 'normal');    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert tsk;}
                catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b null since SysAdmin did the insert
            Task tsk1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Task where Id = :tsk.Id];
            System.assertEquals(tsk1.UserLastModifiedBy__c, null);
            System.assertEquals(tsk1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            tsk1.UserLastModifiedDate__c = datetime.now();
            update tsk1;
            Task tsk2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Task where Id = :tsk1.Id];
            System.assertEquals(tsk2.UserLastModifiedBy__c, null);
            System.assertEquals(tsk2.UserLastModifiedDate__c, null);    
        } // end run as u1 (sysadmin)
    }

    static testmethod void testUserFields_as_nonSysAdmin() 
    {
   
       // Create a non-sysAdmin user & run tests as that user
       // We'll use Champions profile because it's the least likely to change to disallow access to the objects we're updating here
        Profile p2 = [SELECT Id FROM Profile WHERE Name='ID / TDM']; 
        User u2 = [SELECT Id, FirstName, LastName FROM User WHERE ProfileId = :p2.Id AND IsActive = true LIMIT 1];
       
        System.runAs(u2) 
        {
            // The following code runs as user 'u2', a non-SysAdmin      
      
            Product2 prod = new Product2(Name='testprod', IsActive=true);
            insert prod;
           
        //0.ACCOUNT - Creates new account that this user can view, at same time as testing
            Account acct_u2 = new Account(Name = 'Test Account 2', OwnerId = u2.Id, ShippingCity ='Seattle', ShippingStateCode='WA');
            insert acct_u2;
            
            // Test values after initial insert: s/b values from the "u2" non-SysAdmin User we're running as
            Account a1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Account where Id = :acct_u2.Id];
            System.assertEquals(a1.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(a1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed            
            update a1;
            Account a2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Account where Id = :a1.Id];
            System.assertEquals(a2.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(a2.UserLastModifiedDate__c, null);
            
     
         //1. CONTACT
            Contact c3 = new Contact(AccountId = acct_u2.id, LastName = 'Tester', Email='Test@univar.com', Phone='555-555-5555');
            //insert record to start beforeInsert trigger - this first one should work
            try{insert c3;}
                catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b values from the "u2" User we're running as
            Contact c4 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Contact where Id = :c3.Id];
            System.assertEquals(c4.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(c4.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed            
            update c4;
            Contact c5 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Contact where Id = :c4.Id];
            System.assertEquals(c5.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(c5.UserLastModifiedDate__c, null);
            
         //2. OPPORTUNITY
            Opportunity opp3 = new Opportunity(AccountId = acct_u2.Id, Name = 'NonAdmin Test Opp', 
            CloseDate = System.today(),StageName = 'Negotiation/Review');
            //insert record to start beforeInsert trigger - this first one should work
            try{insert opp3;}
                catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b values from the "u2" User we're running as
            Opportunity opp4 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Opportunity where Id = :opp3.Id];
            System.assertEquals(opp4.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(opp4.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed            
            update opp4;
            Opportunity opp5 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Opportunity where Id = :opp4.Id];
            System.assertEquals(opp5.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(opp5.UserLastModifiedDate__c, null);
        
        
        //3. CPP
            CPP__c cpp = new CPP__c(AccountId__c = acct_u2.id, Product2Id__c = prod.Id, Supplier__c = 'testsupp', Source__c='Other');
                         
            //insert record to start beforeInsert trigger - this first one should work
            try{insert cpp;}
                catch(System.DMLException e){} 
            // Test values after initial insert: s/b values from the "u2" User we're running as
            CPP__c cpp1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from CPP__c where Id = :cpp.Id];
            System.assertEquals(cpp1.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(cpp1.UserLastModifiedDate__c, null);           
            // Update the record & confirm values haven't changed
            update cpp1;
            CPP__c cpp2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from CPP__c where Id = :cpp1.Id];
            System.assertEquals(cpp2.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(cpp2.UserLastModifiedDate__c, null);  
              
         //4. WasteStreams (ChemCare__c)
            ChemCare__c cppc3 = new ChemCare__c(AccountId__c = acct_u2.Id, EventOnGoingBusiness__c = 'Ongoing Business', 
             WasteStreamName__c = '111 Spent pickle liquor', PhysicalState__c = 'Gas', ContainerType__c = 'Dump Truck', DisposalTechnology__c = 'Treatment');    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert cppc3;}
                catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b values from the "u2" User we're running as
            ChemCare__c cppc4 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from ChemCare__c where Id = :cppc3.Id];
            System.assertEquals(cppc4.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(cppc4.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            update cppc4;
            ChemCare__c cppc5 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from ChemCare__c where Id = :cppc4.Id];
            System.assertEquals(cppc5.UserLastModifiedBy__c, u2.Id);
            System.assertnotEquals(cppc5.UserLastModifiedDate__c, null);      
            
         //5. SAMPLE REQUEST
            SampleRequest__c sample = new SampleRequest__c(AccountId__c = acct_u2.id, ContactId__c = c3.id,ShipUrgency__c = 'testurg',
            RequestDate__c = system.today(),Producer_NAME__c = 'testproducer',product2ID__c=prod.id,
            ProductDescription__c = 'testproddesc',IndustryApplication__c='testind',
            SpecificApplicationUse__c='testspecapp');    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert sample;}
                catch(System.DMLException e){} 
        
             // Test values after initial insert: s/b values from the "u2" User we're running as
            SampleRequest__c sample1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from SampleRequest__c where Id = :sample.Id];
            System.assertEquals(sample1.UserLastModifiedBy__c, u2.id);
            System.assertnotEquals(sample1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            update sample1;
            SampleRequest__c sample2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from SampleRequest__c where Id = :sample1.Id];
            System.assertEquals(sample2.UserLastModifiedBy__c, u2.id);
            System.assertnotEquals(sample2.UserLastModifiedDate__c, null);   
            
        //6. EVENT
            Event ev = new Event(WhatId = acct_u2.id, OwnerId = u2.id,Subject = 'test',
            StartDateTime = system.now(),EndDateTime = system.now());    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert ev;}
              catch(System.DMLException e){} 
                      
             // Test values after initial insert: s/b values from the "u2" User we're running as
            Event ev1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Event where Id = :ev.Id];
            System.assertEquals(ev1.UserLastModifiedBy__c, u2.FirstName + ' ' + u2.LastName);
            System.assertnotEquals(ev1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            ev1.UserLastModifiedDate__c = datetime.now();
            update ev1;
            Event ev2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Event where Id = :ev1.Id];
            System.assertEquals(ev2.UserLastModifiedBy__c, u2.FirstName + ' ' + u2.LastName);
            System.assertnotEquals(ev2.UserLastModifiedDate__c, null);            

        //7. TASK
            Task tsk = new Task(WhatId = acct_u2.id, OwnerId = u2.id,Subject = 'test',
             Status = 'test status',Priority = 'normal');    
            //insert record to start beforeInsert trigger - this first one should work
            try{insert tsk;}
                catch(System.DMLException e){} 
        
            // Test values after initial insert: s/b values from the "u2" User we're running as
            Task tsk1 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Task where Id = :tsk.Id];
            System.assertEquals(tsk1.UserLastModifiedBy__c, u2.FirstName + ' ' + u2.LastName);
            System.assertnotEquals(tsk1.UserLastModifiedDate__c, null);   
        
            // Update the record & confirm values haven't changed
            tsk1.UserLastModifiedDate__c = datetime.now();
            update tsk1;
            Task tsk2 = [select id, UserLastModifiedBy__c, UserLastModifiedDate__c from Task where Id = :tsk1.Id];
            System.assertEquals(tsk2.UserLastModifiedBy__c, u2.FirstName + ' ' + u2.LastName);
            System.assertnotEquals(tsk2.UserLastModifiedDate__c, null);   
       }  //end RunAs    
   }
 }