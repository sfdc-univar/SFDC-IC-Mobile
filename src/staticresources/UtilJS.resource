/*************************
JavaSript Library for Univar
Utility functions
************************/

 //Array helper function finds field ID
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

//sandbox frame color
/*********************** 
To Do:
Lookup the color instead of hard code
**************************/

function getSandboxStatus(){
var u = document.domain;
var cpos = u.indexOf('cs');
if(cpos > -1){
//should be sandbox
document.body.style.backgroundColor="green";
var appB = document.getElementById("AppBodyHeader");
var phB = document.getElementById("phHeader");
appB.style.backgroundColor="green";
phB.style.backgroundColor="green";
}
}
/******************************
Set default focus to none
Cancels out annoying calendar popup when page first loads
********************************/
 function setFocusOnLoad() {}