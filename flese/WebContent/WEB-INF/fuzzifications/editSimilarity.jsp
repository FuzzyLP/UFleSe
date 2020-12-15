<%@page import="programAnalysis.FunctionPoint"%>
<%@page import="programAnalysis.ProgramPartAnalysis"%>
<%@page import="constants.KUrls"%>
<%@page import="auxiliar.LocalUserInfo"%>
<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>

<%
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);

	LocalUserInfo localUserInfo = requestStoreHouse.getSession().getLocalUserInfo();
	String mode = requestStoreHouse.getRequestParameter(KConstants.Request.mode);
	String fileName = requestStoreHouse.getRequestParameter(KConstants.Request.fileNameParam);
	String fileOwner = requestStoreHouse.getRequestParameter(KConstants.Request.fileOwnerParam);

	String databaseIndex = requestStoreHouse.getRequestParameter(KConstants.Request.databaseIndex);
	String columnIndex = requestStoreHouse.getRequestParameter(KConstants.Request.columnIndex);
	String columnValue1 = requestStoreHouse.getRequestParameter(KConstants.Request.value1Index);
	String columnValue2 = requestStoreHouse.getRequestParameter(KConstants.Request.value2Index);
	String value = requestStoreHouse.getRequestParameter(KConstants.Request.similarityValue);
	
%>


<div>
	<hr />
</div>

<div class="personalizationDivFuzzificationFunctionValuesTableRow">
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		DEGREE OF SIMILARITY BETWEEN <%=columnValue1%> AND <%=columnValue2%>:</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<input type="range" name="defaultValue" min="0" max="1" step="0.01"
			value='<%=value%>' width="150px" id="defaultValue" onchange="setSlider()">
	</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<input type="text" id="defaultValueResult">
	</div>
</div>

<script type="text/javascript">
setSlider();
</script>


<%
	String saveUrl = KUrls.Fuzzifications.SaveSimilarity.getUrl(true) + "&" + KConstants.Request.fileNameParam
			+ "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "=" + fileOwner + "&"
			+ KConstants.Request.mode + "=" + mode + "&" + KConstants.Request.databaseIndex + "="
			+ databaseIndex + "&" + KConstants.Request.columnIndex + "=" + columnIndex;
	JspsUtils.getValue(saveUrl);
%>
<div class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
	<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
		<div class='personalizationDivSaveButtonAndMsgTable'>
			<div class='personalizationDivSaveButtonAndMsgTableRow'>
				<div class='personalizationDivSaveButtonAndMsgTableCell'>
					<%-- <INPUT type='submit' value='Save modifications'
						onclick="updateSimilarity('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=saveUrl%>', '<%=columnValue1%>', '<%=columnValue2%>', defaultValueResult)"> --%>
					<button type="button" class="btn btn-dark" 
						onclick="updateSimilarity('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=saveUrl%>', '<%=columnValue1%>', '<%=columnValue2%>', defaultValueResult)">Save modifications</button>
				</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell'>
					&nbsp;&nbsp;&nbsp;&nbsp;</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell'
					id='<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>'>
				</div>
			</div>
		</div>
	</div>
</div>