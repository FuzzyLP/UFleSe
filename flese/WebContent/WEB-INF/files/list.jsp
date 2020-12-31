<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<%@page import="com.google.common.base.Splitter"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>

<!DOCTYPE html>
<html>
<head>
	<!-- <style type="text/css">
		table th {
			font-size: 11pt !important;
		}
	</style> -->
</head>
<body>

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
		request.setAttribute("filesList",filesList);		
	} else {
		//You do not owe any program file. Upload one by using the facility below.
	}
	for(int i=0; i<filesList.length; i++) { 
		String params = "&" + KConstants.Request.fileOwnerParam + "=" + filesList[i].getFileOwner() +
								"&" + KConstants.Request.fileNameParam + "=" + filesList[i].getFileName() + 
								"&" + KConstants.Request.mode + "=" + KConstants.Request.modeAdvanced;
		
		
		if (filesList[i].getSharingState()){
			request.setAttribute("s","images/okk.png");
		 	request.setAttribute("buttonValue","PUBLIC");
		} else {
			request.setAttribute("s","images/cross.png");
	 		request.setAttribute("buttonValue","PRIVATE");
		}
		
	}
	
	request.setAttribute("fileOwnerParam",KConstants.Request.fileOwnerParam);
	request.setAttribute("fileNameParam",KConstants.Request.fileNameParam);
	request.setAttribute("mode",KConstants.Request.mode);
	request.setAttribute("modeAdvanced",KConstants.Request.modeAdvanced);
	request.setAttribute("urlFileView",urlFileView);
	request.setAttribute("fileViewContentsDiv",KConstants.JspsDivsIds.fileViewContentsDiv);
	
	String uploadedFile = "";
	if(StringUtils.contains(request.getQueryString(), "?")) {
		String query = request.getQueryString().split("\\?")[1];
	    final Map<String, String> map = Splitter.on('&').trimResults().withKeyValueSeparator('=').split(query);
	    if(map.containsKey("uploadedFile")) {
	    	uploadedFile = map.get("uploadedFile");
	    }
	}
	
%>	

<div class="container-fluid">
	<div class="row">
  		<div class="col-4">
  			<table class="table table-dark">
				<thead align="center">
				    <tr>
				      <th scope="col">Uploaded data files</th>
				      <th scope="col">Privacity</th>
				      <th scope="col">Remove file</th>
				      <!-- <th scope="col">CREATE/MODIFY</th> -->
				    </tr>
				 </thead>
				 <tbody>
				 	<c:forEach var="file" items="${filesList}">
				 		<c:set var="params" scope="page" value="&${fileOwnerParam}=${file.fileOwner}&${fileNameParam}=${file.fileName}&${mode}=${modeAdvanced}"/>
						<c:choose>
						    <c:when test="${file.getSharingState() ne null }">
						    	<c:set var="buttonValue" scope="page" value="PUBLIC" />
								<c:set var="s" scope="page" value="images/okk.png" />
						    </c:when>    
						    <c:otherwise>
						    	<c:set var="buttonValue" scope="page" value="PRIVATE" />
								<c:set var="s" scope="page" value="images/cross.png" />
						    </c:otherwise>
						</c:choose>
						<tr align="center">
							<td class="filesListTableCell">
								<a href='#'
									onclick='fileViewAction("${fileViewContentsDiv}", "${urlFileView}", "${params}", "${ file.fileName }");'
									title='view program file ${ file.fileName }'><c:out value="${file.fileName}"/></a>
							</td>
							<td class='filesListTableCell'>
								<img src="${s}" width='20em'>
								<button id='sharingButon' onclick='changeSharingState("<%= urlChangeState %>", "${params}");'>${buttonValue}</button>
								<p id="demo"></p>
							</td>
							<td class="filesListTableCell">
								<a href='#'
									onclick='removeFileAction("<%= urlFileRemoval %>", "${params}");'
									title='remove program file ${ file.fileName }'>
									<img src='images/bin.png' width='30em'> </a>
							</td>
							<%-- <div class='filesListTableCell'>
								<a href='#'
									onclick='return personalizeProgramFile("<%=urlListFuzzifications%>", "<%= params %>", "<%=filesList[i].getFileName() %>");'
									title='personalize program file <%= filesList[i].getFileName() %>'> <label>PERSONALIZE</label>
									<!-- <img src='images/edit.png' width='20em'>  -->
								</a>
							</div> --%>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<script type="text/javascript">
				var uploadedFile = '<%=uploadedFile%>';
				if(!uploadedFileOpened && uploadedFile != "") {
					var targetA = $(".filesListTableCell a:contains('"+uploadedFile+"')");
					if(targetA.length > 0) targetA.trigger("click");
					uploadedFileOpened = true;
				}
			</script>
    	</div>
	    <div class="col">
		</div>
		<div class="col">
    	</div>
  	</div>
</div>

<%-- <div id='<%=KConstants.JspsDivsIds.fileViewContentsDiv %>'
	class='filesListTable' style='display: none;'></div> --%>
	
	<!-- Modal -->
	<div class="modal fade bd-example-modal-lg" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Modal title</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div id="<%=KConstants.JspsDivsIds.fileViewContentsDiv %>" class="modal-body">...</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">Exit</button>
					<!-- <button type="button" class="btn btn-primary">Action</button> -->
				</div>
			</div>
		</div>
	</div>
	
	</body>
</html>

<!-- END -->

