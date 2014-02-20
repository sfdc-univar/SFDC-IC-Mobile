dojo.addOnLoad(function acct_R() { 
//Require Address fields on account Object
var rtProsp = false;
//only for Prospect Accounts
var recordTypeLabel = "Account Record Type";
var rtNodes = document.getElementsByTagName("label");
 	for (var rtN = 0; rtN < rtNodes.length; rtN++){
  		if(rtNodes[rtN].innerHTML == recordTypeLabel){
  		rtProsp = true;
  		break;
 	}
} 
if(rtProsp){ 
var labelArray = ["Shipping City" , "Shipping State/Province" ];
var eLabelNodes = document.getElementsByTagName("label");
 for (var iLNodes = 0; iLNodes < eLabelNodes.length; iLNodes++){
        var e_in = eLabelNodes[iLNodes];
       
        var redChild = e_in.childNodes;
        	for (var n = 0;n < redChild.length;n++){
        		//call external scalable function that uses an array to set any read only fields
        		var redField = getFieldIds(redChild[n],labelArray);	
        		if(redField){
        		//we have a handle on the field ID
        		//alert("theField:\n" + redField);
        		document.getElementById(redField).style.borderLeft="3px solid #c00";
           		}
           	}	
      }
   }

});