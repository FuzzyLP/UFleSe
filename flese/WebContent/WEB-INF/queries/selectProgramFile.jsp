<%@page import="auxiliar.LocalUserInfo"%>
<%@page import="constants.KConstants"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="constants.KUrls"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="java.util.Iterator"%>
<%@page import="managers.FilesManagerAux"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>
<%@page import="java.util.*"%>

<div class="defaultTable">
	<div id="selectDatabaseContainerDiv" class="selectDatabaseTable">
		<%
		RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
		ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
		List<ProgramFileInfo> plFilesList = resultsStoreHouse.getPLFilesList(null);

		String urlSelectQueryStartType = KUrls.Queries.SelectQueryStartType.getUrl(true);
		String urlProgramFileActions = KUrls.Queries.ProgramFileActions.getUrl(true); 
		String urlListFuzzifications = KUrls.Fuzzifications.Update.getUrl(true);
		
		String updateUrl = KUrls.Fuzzifications.Update.getUrl(true);
		JspsUtils.getValue(updateUrl);

		LocalUserInfo localUserInfo = requestStoreHouse.getSession().getLocalUserInfo();
	
		if (plFilesList.size() == 0) {
	%>
		<div class="selectDatabaseTableRow">
			<div class="selectDatabaseTableCell">No configuration files available. Please
				upload one via your user options.</div>
		</div>
		<%
		} else {
	%>
		<div class="selectDatabaseTableRow">
			<div class="selectDatabaseTableCell1">Please, select a file:</div>
			<div class="selectDatabaseTableCell2">
				<select name="<%=KConstants.Request.programParam %>"
					id="<%=KConstants.Request.programParam %>"
					onchange="selectedProgramDatabaseChanged(this, '<%=urlSelectQueryStartType %>', '<%=urlProgramFileActions %>', '<%=KConstants.JspsDivsIds.fuzzificationUpdateStatusDivId %>','<%=updateUrl%>')">
					<%=JspsUtils.comboBoxDefaultValue()%>
					<%
					ArrayList<String> descList = new ArrayList<String>();
					ArrayList<String> valueList = new ArrayList<String>();
		for (ProgramFileInfo programFileInfo : plFilesList) { 
			if ((programFileInfo.getSharingState())||(programFileInfo.getFileOwner()).equals(localUserInfo.getLocalUserName()))
			{
				String value = programFileInfo.getInfoForUrls();
				String desc = programFileInfo.getFileName() + " ( owned by " + programFileInfo.getFileOwner() + " ) ";
				descList.add(desc);
				valueList.add(value);
			}
		}
		for (int j = 0 ; j < descList.size() ; j++)
		{
			
	%>
					<option id='<%=valueList.get(j)%>' title='<%=valueList.get(j)%>' value='<%=valueList.get(j)%>'><%=descList.get(j)%></option>
					<%
		}
	%>
				</select>
			</div>
			<div class='selectDatabaseTableCell3'
				id='<%=KConstants.JspsDivsIds.programFileActionsContainerId%>'>
			</div>
		</div>
		<%
		}
	%>
	</div>
</div>

<div id="<%=KConstants.JspsDivsIds.selectQueryDivId%>"
	class="defaultTable"></div>

<div id="<%=KConstants.JspsDivsIds.runQueryDivId%>" class="defaultTable">
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


<!--  EOF -->