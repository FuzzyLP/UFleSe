<%@page import="storeHouse.SessionStoreHouse"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>
<jsp:include page="commonHtmlHead.jsp" />
<%@page import="auxiliar.JspsUtils"%>
<%@page import="constants.KConstants"%>
<%@page import="constants.KUrls"%>
<%@page import="java.util.*"%>

<body>
<script type="text/javascript">
    $("body").keypress(function(evt){
        var keyCode = (evt.which?evt.which:(evt.keyCode?evt.keyCode:0));
        if (keyCode == 113) {
        	debug.info("Pressed key: " + keyCode);
			// alert(keyCode);
			launchCallsRegistry();
        }
    });

	// $("body").attachEvent('keydown', function (e) { alert(e.keyCode); }, false);
	/*$("body").onkeypress=function(evt){
		var keyCode = (evt.which?evt.which:(evt.keyCode?evt.keyCode:0))
		alert(keyCode);
	}*/
	
	$("body").onkeydown=function(evt){
		var keyCode = (evt.which?evt.which:(evt.keyCode?evt.keyCode:0));
		alert(keyCode);
	}
</script>

	<header>
		<div id="bodyHeadTable" class="bodyHeadTable">
			<div id="bodyHeadTitle" class="bodyHeadTable">
				FleSe : <span class="underline">Fle</span>xible <span
					class="underline">Se</span>arches in Databases
			</div>
			<div id="bodyHeadLogged" class="bodyHeadTable">
				<%  
				RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
				SessionStoreHouse sessionStoreHouse = JspsUtils.getSessionStoreHouse(requestStoreHouse);
				String localUserInfoName = JspsUtils.getLocalUserInfoName(sessionStoreHouse);
				ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
				List<ProgramFileInfo> plFilesList = resultsStoreHouse.getPLFilesList(requestStoreHouse);
				String urlListFuzzifications = KUrls.Fuzzifications.List.getUrl(true);
				if ("".equals(localUserInfoName)) {
					%>Not logged in<%
				}
				else {
					%>
				logged as <br />
				<%= localUserInfoName %>
				<br/> 
					<ul id="nav">
						<li><a id='userOptions' title='user options' href='#' onclick="return loadUserOptions();">user options</a> | </li>
						<li><a id='searchQuery' title='search query' href='#' onclick="">Search query</a>
						<% if (plFilesList.size() > 0) { %>
							<ul>
							<% for (ProgramFileInfo programFileInfo : plFilesList) { 
								String params = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() +
										"&" + KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + 
										"&" + KConstants.Request.mode + "=" + KConstants.Request.modeAdvanced;
							%>
								<li><b><a href="#"
										onclick='return personalizeProgramFile("<%=urlListFuzzifications%>", "<%= params %>", "<%=programFileInfo.getFileName() %>", "Modify the existing criterion");'
										title="personalize program file"
									> <%=programFileInfo.getFileName() %></a></b></li>
							<% } %>
							</ul>
						<% } %>
						 | 
						</li>
						<li><a id='newQuery' title='new query' href='#' onclick="return loadNewQuery();">new query</a></li>
					</ul>
					<% } %>
			</div>
			<div id="bodyHeadLogout" class="bodyHeadTable">
				<a id="signOut" title="Sign out"
					href="<%=KUrls.Auth.SignOut.getUrl(false)%>">Sign out</a>
			</div>
		</div>
	</header>

	<section id="<%=KConstants.JspsDivsIds.msgsSecDivId %>"
		class="bodyToUserMsgs"></section>
	<section id="<%=KConstants.JspsDivsIds.auxAndInvisibleSection %>"
		style='display: none;'></section>

	

	<section id="<%= KConstants.JspsDivsIds.mainSecDivId %>" class="">
	</section>
	

	<div id="footer"></div>

	

	<!--  <-/-body>  -->
	<!--  <-/-html>  -->