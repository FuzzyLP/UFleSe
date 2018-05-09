
<%@page import="constants.KUrls"%>
<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="managers.FilesManagerAux"%>
<%@page import="auxiliar.LocalUserInfo"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>

<%
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
	ProgramFileInfo[] filesList = resultsStoreHouse.getFilesList();


	LocalUserInfo localUserInfo = requestStoreHouse.getSession().getLocalUserInfo();
	String urlFileView = KUrls.Files.View.getUrl(true);
	String urlListFuzzifications = KUrls.Fuzzifications.List.getUrl(true);
	String urlReloadPage = KUrls.User.Options.getUrl(true);
	String urlFileRemoval = KUrls.Files.Remove.getUrl(true);
	String urlChangeState = KUrls.Files.ChangeState.getUrl(true);
	
	if ((filesList.length > 0)&&(FilesManagerAux.sharedfiles(localUserInfo.getLocalUserName()))) {
%>

<!DOCTYPE html>
<html>
<body>

<div class='filesListTableRow'>

	<div class='filesListTableCell'> <h6>
	UPLOADED DATA FILES</h6></div>
	<div class='filesListTableCell'><h6>PRIVACITY</h6></div>
	<div class='filesListTableCell'><h6>REMOVE FILE</h6></div>
	<div class='filesListTableCell'><h6>CREATE/MODIFY</h6></div>
</div> 
<%	}
	else {
%>
<!-- You do not owe any program file. Upload one by using the facility below. -->
<%	
	}
	for(int i=0; i<filesList.length; i++) { 
		String params = "&" + KConstants.Request.fileOwnerParam + "=" + filesList[i].getFileOwner() +
								"&" + KConstants.Request.fileNameParam + "=" + filesList[i].getFileName() + 
								"&" + KConstants.Request.mode + "=" + KConstants.Request.modeAdvanced;
%>
<div class='filesListTableRow'>
	<div class='filesListTableCell'>
		<a href='#'
			onclick='fileViewAction("<%=KConstants.JspsDivsIds.fileViewContentsDiv %>", "<%=urlFileView%>", "<%=params %>", "<%=filesList[i].getFileName() %>");'
			title='view program file <%= filesList[i].getFileName() %>'><%=filesList[i].getFileName() %></a>
	</div>
	<% 
	String s = "";
	String buttonValue = "";
	if (filesList[i].getSharingState()){
		 s = "images/okk.png";
		 buttonValue = "PUBLIC";
		} else {
			 s = "images/cross.png";
			 buttonValue = "PRIVATE";
		}
		%>
	<div class='filesListTableCell'>
		<img src=<%=s %> width='20em'>
	<button id='sharingButon' onclick='changeSharingState("<%= urlChangeState %>", "<%= params %>");'><%= buttonValue %></button>
	<p id="demo"></p>
	</div>
	<div class='filesListTableCell'>
		<a href='#'
			onclick='removeFileAction("<%= urlFileRemoval %>", "<%= params %>");'
			title='remove program file <%= filesList[i].getFileName() %>'>
			<img src='images/bin.png' width='30em'> </a>
	</div>
	<div class='filesListTableCell'>
		<a href='#'
			onclick='return personalizeProgramFile("<%=urlListFuzzifications%>", "<%= params %>", "<%=filesList[i].getFileName() %>");'
			title='personalize program file <%= filesList[i].getFileName() %>'> <label>PERSONALIZE</label>
			<!-- <img src='images/edit.png' width='20em'>  -->
		</a>
	</div>
</div>
<%  }  %>

<div id='<%=KConstants.JspsDivsIds.fileViewContentsDiv %>'
	class='filesListTable' style='display: none;'></div>
	
	</body>
</html>

<!-- END -->

