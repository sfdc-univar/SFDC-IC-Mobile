 //Array helper function disables the fields
 //calling js sends the childNode and labelArray 
 //see; setRequiredAddressFields_js.resource
function getFieldIds(childNode,labelArray){
var childVal = childNode.nodeValue;
if(childVal){

   for(var jNode=0;jNode<labelArray.length;jNode++){ 
   		var labelMatch = labelArray[jNode];
      	var pos = childVal.indexOf(labelMatch);
   		if(pos > -1){
   		var htmlForAtt = childNode.parentNode.htmlFor;
   		return htmlForAtt;
   } 
   }
   }
}