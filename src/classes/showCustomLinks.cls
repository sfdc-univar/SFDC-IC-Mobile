public with sharing class showCustomLinks{
 

   public list<hLinks> getLinks() {
    Homepage_Links__c L;
     list<hLinks> list_ch = new list<hLinks>();
   try{  
     // Return all link and text fields
     L = [SELECT
      id, Link_1__c,
      Link_2__c,
      Link_3__c,
      Link_4__c,
      Link_5__c,
      Link_6__c,
      Link_7__c,
      Link_8__c,
      Link_9__c,
      Link_10__c,
      Link_11__c,
      Link_12__c,
      Link_13__c,
      Link_14__c,
      Link_15__c,
    X1_Bookmark__c,
    X10_Bookmark__c,    
    X11_Bookmark__c,            
    X12_Bookmark__c,        
    X13_Bookmark__c,        
    X14_Bookmark__c,        
    X15_Bookmark__c,        
    X2_Bookmark__c,     
    X3_Bookmark__c,     
    X4_Bookmark__c,     
    X5_Bookmark__c,         
    X6_Bookmark__c,         
    X7_Bookmark__c,         
    X8_Bookmark__c,         
    X9_Bookmark__c from Homepage_Links__c LIMIT 1];
   
  
      // Create a new wrapper object
        hLinks hL = new hLinks();
     
  
             hL.link1 = String.valueOf(L.Link_1__c);
            hL.link2 = String.valueOf(L.Link_2__c);
            hL.link3 = String.valueOf(L.Link_3__c);
             hL.link4 = String.valueOf(L.Link_4__c);
              hL.link5 = String.valueOf(L.Link_5__c);
               hL.link6 = String.valueOf(L.Link_6__c);
                hL.link7 = String.valueOf(L.Link_7__c);
                 hL.link8 = String.valueOf(L.Link_8__c);
                  hL.link9 = String.valueOf(L.Link_9__c);
                   hL.link10 = String.valueOf(L.Link_10__c);
                    hL.link11 = String.valueOf(L.Link_11__c);
                     hL.link12 = String.valueOf(L.Link_12__c);
                      hL.link13 = String.valueOf(L.Link_13__c);
                       hL.link14 = String.valueOf(L.Link_14__c);
                        hL.link15 = String.valueOf(L.Link_15__c);
                        
                        System.debug('************************value of hL link1 : ' + hl.link1);
           
        hL.url1 = String.valueOf(L.X1_Bookmark__c);
     hL.url10 = String.valueOf(L.X10_Bookmark__c);    
     hL.url11 = String.valueOf(L.X11_Bookmark__c);            
     hL.url12 = String.valueOf(L.X12_Bookmark__c);        
     hL.url13 = String.valueOf(L.X13_Bookmark__c);
     hL.url14 = String.valueOf(L.X14_Bookmark__c);
     hL.url15 = String.valueOf(L.X15_Bookmark__c);        
     hL.url2 = String.valueOf(L.X2_Bookmark__c);     
     hL.url3 = String.valueOf(L.X3_Bookmark__c);
     hL.url4 = String.valueOf(L.X4_Bookmark__c);
     hL.url5 = String.valueOf(L.X5_Bookmark__c);
     hL.url6 = String.valueOf(L.X6_Bookmark__c);
     hL.url7 = String.valueOf(L.X7_Bookmark__c);         
     hL.url8 = String.valueOf(L.X8_Bookmark__c);
     hL.url9 = String.valueOf(L.X9_Bookmark__c);
     
     System.debug('************************value of hL url1: ' + hl.url1);
     
            
      list_ch.add(hL); 
  
     //send list to page
      } catch (QueryException q){
   }
     return list_ch;

   }
   
     public class hLinks{
     
     // Class properties
        public String link1 {get; set;}
        public String link2 {get; set;}
        public String link3 {get; set;}
        public String link4 {get; set;}
        public String link5 {get; set;}
        public String link6 {get; set;}
        public String link7 {get; set;}
        public String link8 {get; set;}
        public String link9 {get; set;}
        public String link10 {get; set;}
        public String link11 {get; set;}
        public String link12 {get; set;}
        public String link13 {get; set;}
        public String link14 {get; set;}
        public String link15 {get; set;}
        public String url1 {get; set;}
        public String url2 {get; set;}
        public String url3 {get; set;}
        public String url4 {get; set;}
        public String url5 {get; set;}
        public String url6 {get; set;}
        public String url7 {get; set;}
        public String url8 {get; set;}
        public String url9 {get; set;}
        public String url10 {get; set;}
        public String url11 {get; set;}
        public String url12 {get; set;}
        public String url13 {get; set;}
        public String url14 {get; set;}
        public String url15 {get; set;}
        
        
    }

}