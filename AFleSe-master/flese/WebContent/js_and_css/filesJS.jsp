/*! * auxiliarJS Library v1 * auxiliar javascript code * Author: Victor
Pablos Ceruelo */ /*
----------------------------------------------------------------------------------------------------------------
*/ /*
----------------------------------------------------------------------------------------------------------------
*/ /*
----------------------------------------------------------------------------------------------------------------
*/

<%@page import="constants.KUrls"%>
<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%
	
 if (JspsUtils.getStringWithValueS().equals("N")) { %>
<script type="text/javascript">
<% } 
%>
/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */

var fuzzyTypes = null; //variable to keep the values of the columns



function removeFileAction (urlRemove, params) {
	var divId = "<%=KConstants.JspsDivsIds.auxAndInvisibleSection %>";
	
	loadAjaxIn(divId, urlRemove + params);
}

function changeSharingState (urlRemove, params) {
	var divId = "<%=KConstants.JspsDivsIds.auxAndInvisibleSection %>";
	
	loadAjaxIn(divId, urlRemove + params);
}

/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------- */

function fileViewAction(fileViewContentsDivId, urlFileView, params, fileName) {
	
	var containerId = fileViewContentsDivId;
	
	loadAjaxInDialog(containerId, urlFileView + params, 'Contents of data file ' + fileName);
	
	//prevent the browser to follow the link
	return false;
}

function myFunction(val) {
    document.getElementById("demo").innerHTML = val + "Hello World";
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function insertiFrameWindowEvaluationOfJS(uploadFormTargetiFrameId) {
	
	// This does not work on google chrome: "src='#' " 
    	
	$('#' + uploadFormTargetiFrameId).load(function() {
		// document.getElementById('#' + submitiFrameId);
		var responseHtmlText = null;
		var iFrameWindow = getIframeWindow(this);
		if ((notNullNorUndefined(iFrameWindow)) && (notNullNorUndefined(iFrameWindow.document)) && (notNullNorUndefined(iFrameWindow.document.body))) {
			
			// Save html received in iFrameWindow
			responseHtmlText = iFrameWindow.document.body.innerHTML;
			
			// Empty iFrameWindow html text.
			if (notNullNorUndefined(responseHtmlText)) {
				iFrameWindow.document.body.innerHTML="";
				debug.info(responseHtmlText);
				if (typeof(executeAjaxLoadedPageJS) == "function") {
					executeAjaxLoadedPageJS(responseHtmlText);
				}
				if (typeof(window.parent.executeAjaxLoadedPageJS) == "function") {
					window.parent.executeAjaxLoadedPageJS(responseHtmlText);
				}
			}
			
			// Clear the content of the iframe.
			// this.contentDocument.location.href = '/images/loading.gif';
			// alert("responseText: " + responseHtmlText);
			
			// var container = getContainer(uploadStatusDivId);
			// container.style.visibility = 'visible';
			// container.innerHTML = responseHtmlText;
		}
		  
	});	
}

function fileUploadAutomaticSendActionOnChange(formId, uploadStatusDivId) {
	// alert("Upload Submit Action started ...");
	var uploadStatusDiv = getContainer(uploadStatusDivId);
	uploadStatusDiv.style.visibility = 'visible';
	uploadStatusDiv.innerHTML = "";
	uploadStatusDiv.innerHTML = loadingImageHtml(true);

	var form = document.getElementById(formId);
	form.submit();
}

/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/
/* ----------------------------------------------------------------------------------------------------------------------------*/

function initializeTypes(numberOfTypes)
{
	fuzzyTypes = new Array(numberOfTypes);
	var i;
	for(i=0; i<fuzzyTypes.length;i++)
		fuzzyTypes[i] = 1;
}


function setType(type, position)
{
	try{
		fuzzyTypes[position] = type.options[type.selectedIndex].value;
	}catch(Exception){}
	console.log(fuzzyTypes[position]);
}

function createPL(convertToPrologDivId, saveUrl)
{
	var convertToPrologDiv = getContainer(convertToPrologDivId);
	convertToPrologDiv.innerHTML = loadingImageHtml(false);
	var i;
	if(fuzzyTypes){
	for (i=0;i<fuzzyTypes.length;i++)
		{
	if(fuzzyTypes[i] == 1 || fuzzyTypes[i] == "1")
			saveUrl+="&type["+i+"]=string"; 
	if(fuzzyTypes[i] == 2 || fuzzyTypes[i] == "2")
			saveUrl+="&type["+i+"]=integer"; 
	if(fuzzyTypes[i] == 3 || fuzzyTypes[i] == "3")
			saveUrl+="&type["+i+"]=float"; 
	if(fuzzyTypes[i] == 4 || fuzzyTypes[i] == "4")
			saveUrl+="&type["+i+"]=boolean"; 
	if(fuzzyTypes[i] == 5 || fuzzyTypes[i] == "5")
			saveUrl+="&type["+i+"]=enum";
	if(fuzzyTypes[i] == 6 || fuzzyTypes[i] == "6")
			saveUrl+="&type["+i+"]=datetime";
		}
	}
	loadAjaxIn(convertToPrologDivId, saveUrl);
}

<% if (JspsUtils.getStringWithValueS().equals("N")) { %>
</script>
<%
	}
%>