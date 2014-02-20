trigger opportunityTagContent on Opportunity (after insert, after update) 
{

    String tagN;
    String fixTag;
    String prodTagFix;
    String oldTag;
    String prodTag;
    String industryTag;

   for(Opportunity o: Trigger.new)
   {
       //Add Stage to Tags List if StageName has changed
       if(Trigger.isInsert)
       {
          String StageTag = o.StageName;
          //Add new and fix new StageTag
          Boolean result = StageTag.containsAny('/*()');
          if(result = true)
          {
            fixTag = StageTag.replace('/',' ');
            fixTag = StageTag.replace('*',' ');
            fixTag = StageTag.replace('(',' ');
            fixTag = StageTag.replace(')',' ');
            //does this match the old tag(s)?
          }  
       } 
       else 
       {
            String StageTag = Trigger.newMap.get(o.Id).StageName;
            if (Trigger.oldMap.get(o.Id).StageName != Trigger.newMap.get(o.Id).StageName)
            {
                //get old Tag 
                Boolean oldResult = Trigger.oldMap.get(o.Id).StageName.contains('/');
                if(oldResult= true)
                {
                    oldTag = Trigger.oldMap.get(o.Id).StageName.replace('/',' ');
                    //remove old stage modified from Opportunity Tags list -
                    List<OpportunityTag> delTag = [Select ID, Name, ItemId FROM OpportunityTag WHERE ItemId = : o.Id AND Name = :
                    oldTag ];
                     Integer oldSize = delTag.size();
                     if(oldSize > 0)
                     {
                         OpportunityTag deleteTag = delTag[0];
                         try 
                         {
                           delete deleteTag;
                           System.debug('******** Record Deleted *********** ' );
                         } 
                         catch (DMLException e) 
                         {
                           //exception
                         }
                     }
                 }
                }
                //Add new and fix new StageTag
                Boolean result = StageTag.contains('/');
                if(result = true)
                {
                    fixTag = StageTag.replace('/',' ');
                    //does this match the old tag(s)?
                }  
            }  
            //add new OpportunityTag
           OpportunityTag oppStage = new OpportunityTag(ItemId = o.ID,Type = 'Public', Name = fixTag);
           OpportunityTag oppStage2 = new OpportunityTag(ItemId = o.ID,Type = 'Public', Name = 'Learn Identify');
          
           ID oRecType = o.RecordTypeId;
           RecordType rt = [SELECT Id,Name FROM RecordType WHERE Id = :oRecType LIMIT 1];
         
           String oppName = rt.Name;

           if(oppName != 'ChemCare Opportunity'){
           prodTag = o.Product__c;
           Product2 prod = [Select Name from Product2 WHERE ID = :prodTag];
           String prodName = prod.Name; 
           if(prodTag <> '')
           {
             //Add new and fix new StageTag
                Boolean result = prodTag.containsAny('/(*)');
                if(result = true)
                {
                    prodTagFix = prodTag.replace('/',' ');
                     prodTagFix = prodTag.replace('*',' ');
                      prodTagFix = prodTag.replace('(',' ');
                       prodTagFix = prodTag.replace(')',' ');
                    //does this match the old tag(s)?
                }  
                OpportunityTag oppStage3 = new OpportunityTag(ItemId = o.ID,Type = 'Public', Name = prodTagFix );
                Database.saveResult lsr3 = Database.insert(oppStage3);
           }
           }   
           
          
           Database.saveResult lsr = Database.insert(oppStage);
           Database.saveResult lsr2 = Database.insert(oppStage2);
                  
           if(!lsr.isSuccess())
           {
                Database.Error err = lsr.getErrors()[0];
           }
     
            //get all tags for this opportunity
            list<OpportunityTag> list_tags = new list<OpportunityTag>();
            for (OpportunityTag ot : [SELECT Id, Name, ItemId, Type FROM OpportunityTag WHERE ItemId = : o.Id ]){
            if(ot.Type == 'Public')
            {
                // Create a new wrapper object
                tagN = String.valueOf(ot.Name);
                //now we should have a list of Opportunity Tags to work with
                System.debug('********** TAGN ' + tagN);
                String searchquery='FIND\'' + tagN + '\'IN ALL FIELDS RETURNING ContentVersion(Id, ContentDocumentId, Origin WHERE Origin=\'C\')'; 
              
                List<List<ContentVersion>>searchList= search.query(searchquery);
                //ContentVersion[] is a list using searchList - first returned item in the searchQuery - id
                ContentVersion[] cv = ((List<ContentVersion>)searchList[0]);
                for(ContentVersion convers : cv)
                //Origin = H it's a Chatter File
                if(convers.Origin <> 'H'){
                System.debug('~~~~~~~~~~~~~~ ORIGIN ' + convers.Origin);
                {
                    convers.Opportunity__c = o.id;
                    try{
                 //   update convers;
                    } catch (DMLException e) {
                    //skip this one, probably not accessible or chatter
                    continue;
                    }
                }         
            }}
        }
    }
}