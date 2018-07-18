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
	
	loadAjaxIn(divId, urlRemove + params, function() {
		if(getParamFromGivenUrl(urlRemove, "fileName").indexOf(".pl") >= 0)
			setTimeout(function(){ location.reload(); }, 1000);
	});
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
	sessionStorage.reloadAfterPageLoad = true;
	form.submit();
	if($("#uploadForm #file").val().indexOf(".pl") >= 0)
		setTimeout(function(){ location.reload(); }, 1000);
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
	loadAjaxIn(convertToPrologDivId, saveUrl, function() {
					//Add modifiers
					var modifiers = "define_modifier(rather/2, TV_In, TV_Out) :- TV_Out .=. TV_In * TV_In </br>define_modifier(very/2, TV_In, TV_Out) :- TV_Out .=. TV_In * TV_In * TV_In </br>define_modifier(little/2, TV_In, TV_Out) :- TV_Out * TV_Out .=. TV_In </br>define_modifier(very_little/2, TV_In, TV_Out) :- TV_Out * TV_Out * TV_Out .=. TV_In";
					var newSaveUrl = "Servlet?manager=Fuzzifications&op=saveModifier&ajax=true"
						+ "&fileName="
						+ getParamFromGivenUrl(saveUrl, "fileName").split(".")[0].toLowerCase() + ".pl"
						+ "&fileOwner="
						+ getParamFromGivenUrl(saveUrl, "fileOwner")
						+ "&mode=";
					saveModifier(convertToPrologDivId, newSaveUrl,
							modifiers);
				});
	}

	function getParamFromGivenUrl(url, name) {
		return decodeURI((RegExp(name + '=' + '(.+?)(&|$)').exec(url) || [ ,
				null ])[1]);
	};
<% if (JspsUtils.getStringWithValueS().equals("N")) { %>
</script>
<%
	}
%>