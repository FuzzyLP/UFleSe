<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
	$(document).ready(function(){
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
			
			$(".dropdown").hover(function(){
		        var dropdownMenu = $(this).children(".dropdown-menu");
		        if(dropdownMenu.is(":visible")){
		            dropdownMenu.parent().toggleClass("open");
		        }
		    });
	});
</script>
	<header>
		<%
			String logged_suffix = "_2_0";
			RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
			SessionStoreHouse sessionStoreHouse = JspsUtils.getSessionStoreHouse(requestStoreHouse);
			String localUserInfoName = JspsUtils.getLocalUserInfoName(sessionStoreHouse);
			if(StringUtils.endsWith(localUserInfoName, logged_suffix)) localUserInfoName = StringUtils.substringBeforeLast(localUserInfoName, logged_suffix);
			ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
			List<ProgramFileInfo> plFilesList = resultsStoreHouse.getPLFilesList(requestStoreHouse);
			String urlListFuzzifications = KUrls.Fuzzifications.List.getUrl(true);
			request.setAttribute("plFilesListSize",plFilesList.size());
		%>
		<div class="container-fluid bg-light rounded border" style="text-align: center;">
			<div class="row pb-2 pt-2 bg-light align-items-center">
				<div class="col-3 pr-0 bodyHeadTitle">UFleSe : <span class="underline">U</span>sable 
				<span class="underline">Fle</span>xible <span
					class="underline">Se</span>arches in Databases</div>
				<div class="col-6 p-0 <c:if test="${ plFilesListSize ne 0 }"></c:if>"> <!-- border -->
					<% if (!"".equals(localUserInfoName)) {
						%>
						<nav class="navbar navbar-expand-lg navbar-light bg-light">
							<button class="navbar-toggler" type="button"
								data-toggle="collapse" data-target="#navbarNav"
								aria-controls="navbarNav" aria-expanded="false"
								aria-label="Toggle navigation">
								<span class="navbar-toggler-icon"></span>
							</button>
							<div class="collapse navbar-collapse justify-content-center" id="navbarNav">
								<ul class="navbar-nav">
									<li class="nav-item active"><a class="nav-link" id='userOptions' title='user options' href='#' onclick="return loadUserOptions();">user options
											<span class="sr-only">(current)</span></a>
									</li>
									<c:choose>
										<c:when test="${ plFilesListSize eq 0 || plFilesListSize eq null }">
											<li class="nav-item active"><a class="nav-link" id='searchQuery' title='search options' href='#'>search options</a></li>
										</c:when>
										<c:otherwise>
											<li class="nav-item active dropdown"><a id='searchQuery' title='search options'
												class="nav-link dropdown-toggle" href="#"
												role="button" data-toggle="dropdown" aria-haspopup="true"
												aria-expanded="false">search options</a>
												<div class="dropdown-menu" aria-labelledby="navbarDropdown">
													<%
														for (ProgramFileInfo programFileInfo : plFilesList) { 
															String params = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() +
																	"&" + KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + 
																	"&" + KConstants.Request.mode + "=" + KConstants.Request.modeAdvanced;
													%>
														<a class="dropdown-item bg-light" href="#" onclick='return personalizeProgramFile("<%=urlListFuzzifications%>", "<%= params %>", "<%=programFileInfo.getFileName() %>", "Modify the existing criterion");'
														title="personalize program file"><%=programFileInfo.getFileName() %></a>
													<% } %>
												</div>
											</li>
										</c:otherwise>
									</c:choose>
									<li class="nav-item active"><a class="nav-link" id='newQuery' title='new query' href='#' onclick="return loadNewQuery();">new query</a></li>
								</ul>
							</div>
						</nav>
					<%
						}
					%>
				</div>
				<div class="col-3 p-0">
					<%
						if (!"".equals(localUserInfoName)) {
					%>
						logged as <br/>
					<%= localUserInfoName %> <br/> 
						<a id="signOut" title="Sign out"
							href="<%=KUrls.Auth.SignOut.getUrl(false)%>">Sign out</a>
					<% } else {
						%>Not logged in<%
						} %>
				</div>
			</div>
		</div>
	</header><br>

	<section id="<%=KConstants.JspsDivsIds.msgsSecDivId %>"
		class="bodyToUserMsgs"></section>
	<%-- <section id="<%=KConstants.JspsDivsIds.auxAndInvisibleSection %>"
		style='display: none;'></section> --%>
		
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
				<div id="<%=KConstants.JspsDivsIds.auxAndInvisibleSection %>" class="modal-body">...</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">Exit</button>
					<!-- <button type="button" class="btn btn-primary">Save modifications</button> -->
				</div>
			</div>
		</div>
	</div>

	

	<section id="<%= KConstants.JspsDivsIds.mainSecDivId %>" class="">
	</section>
	

	<div id="footer"></div>
	

	<!--  <-/-body>  -->
	<!--  <-/-html>  -->