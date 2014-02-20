public with sharing class OpportunityMethods 
{
    public static void OpportunityProcess(List<Opportunity> objects, Map<Id, Opportunity> oldMap, Boolean bInsert) {
	
        // Prep for UserLastModified code
		Profile p = [SELECT id, name from profile WHERE id = :UserInfo.getProfileID()];
	    String ThisUser = UserInfo.getUserId();
        
        // Prep for Validate Bid Campaigns code
        List<Related_Account__c> ra = new List<Related_Account__c>();
		Campaign camp;
		Id campId;
		Id account;
		Boolean isRelated = false;
		Id rt = [SELECT Id FROM RecordType WHERE sObjectType='Campaign' AND DeveloperName ='Bid_Campaigns'].Id;
	          
	    // Loop through the incoming records
	    for (Opportunity obj : objects) 
	    {
      		//1. SAVE USER-LAST-MODIFIED INFO (When a non-SysAdmin updates a record)            
	        if (p.name.Contains('Sys'))  {   //SysAdmin
                if(bInsert) { //Blank out the fields in case the insert was caused by a clone, 	 	    	
	 	            obj.UserLastModifiedBy__c = null;
	                obj.UserLastModifiedDate__c = null;
                } else if (obj.UserLastModifiedDate__c <> oldMap.get(obj.id).UserLastModifiedDate__c)  {
                    // If SysAdmin inadvertently updated one of the fields, undo it
	          	    obj.UserLastModifiedBy__c = oldMap.get(obj.id).UserLastModifiedBy__c;
	                obj.UserLastModifiedDate__c = oldMap.get(obj.id).UserLastModifiedDate__c;
	            }            
		          
		      //Non-SysAdmin - always update the fields                                
	        } else {   
	            obj.UserLastModifiedBy__c = ThisUser;
	            obj.UserLastModifiedDate__c = datetime.now();
	        }
            
            //2. VALIDATE BID CAMPAIGNS
            campId = obj.CampaignId;
    		if(campID != null){
    			account = obj.AccountId;
    			//use campaign ID to find related accounts
    			camp = [SELECT Id, RecordTypeId FROM Campaign WHERE id = :campID];
    			if(camp!=null){
    				if(rt == camp.RecordTypeId){
        				//find related accounts equal to Primary Campaign Source
    					List<Related_Account__c> related = [SELECT Id, Account__c, Campaign__c FROM Related_Account__c WHERE Campaign__c =:campId ];
    					for(Related_Account__c c : related){
        					//check here to see if the Opportunity Account matches any of the related accounts on the campaign
        					if(c.Account__c == account){
            					isRelated = true;
        					}
    					}   
        				if(!isRelated){
        					obj.CampaignId.addError('When choosing a Bid Campaign as your Primary Campaign source, you must make sure the account is related to the Bid Campaign.');
        				}
      				}
    			}
   			}
        }
	}
	
	public static void OpportunityBeforeInsert(List<Opportunity> opportunities, Map<Id, Opportunity> oldMap)
	{
		OpportunityProcess(opportunities, oldMap, true);
	}
	
	public static void OpportunityBeforeUpdate(List<Opportunity> opportunities, Map<Id, Opportunity> oldMap)
	{
		OpportunityProcess(opportunities, oldMap, false);
	}
}