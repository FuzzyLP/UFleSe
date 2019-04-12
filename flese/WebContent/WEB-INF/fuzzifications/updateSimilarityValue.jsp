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

	ProgramPartAnalysis[][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	String[][] data = resultsStoreHouse.getProgramPartData();
	
	String columnValue1 = requestStoreHouse.getRequestParameter(KConstants.Request.value1Index);
	String columnValue2 = requestStoreHouse.getRequestParameter(KConstants.Request.value2Index);
	String value = requestStoreHouse.getRequestParameter(KConstants.Request.similarityValue);

	String databaseIndex = requestStoreHouse.getRequestParameter(KConstants.Request.databaseIndex);
	String columnIndex = requestStoreHouse.getRequestParameter(KConstants.Request.columnIndex);
	int colIndex = Integer.parseInt(columnIndex);
	String[] values = new HashSet<String>(Arrays.asList(data[colIndex])).toArray(new String[0]);
	ProgramPartAnalysis[] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis[] othersFuzzifications = null;
	String[] keyValues = null;
	String predDefined = "", predNecessary = "";
	int x, y;
	
	String modeSimilarity = KConstants.Request.modeUpdateExitingSimilarity;
%>


<div>
	<hr />
</div>

<script type="text/javascript">
	$(function() {
		var columnValue1 = '<%= columnValue1 %>';
		var columnValue2 = '<%= columnValue2 %>';
		$("select#value1").val(columnValue1);
		$("select#value2").val(columnValue2);
		var value = '<%= value %>';
		$("#defaultValueResult").val(value);
		$("input[type='range'][name='defaultValue']").val(value);
		$("span#similarityMsg").html(getSimilarityState(value));
		$("span#similarityMsg").removeAttr("class");
		$("span#similarityMsg").addClass(getSimilarityStyle(value));
	});
</script>

<%
	String updateUrl = KUrls.Fuzzifications.CheckSimilarity.getUrl(true) + "&" + KConstants.Request.fileNameParam
			+ "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "=" + fileOwner + "&"
			+ KConstants.Request.mode + "=" + mode + "&" + KConstants.Request.databaseIndex + "="
			+ databaseIndex + "&" + KConstants.Request.columnIndex + "=" + columnIndex;
	JspsUtils.getValue(updateUrl);
	
%>
<div class="personalizationDivFuzzificationFunctionValuesTableRow">
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		CHOOSE THE ITEMS FOR DEFINING THEIR SIMILARITIES:</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<select id='value1' onchange='reloadOtherCombo()'>
			<option selected="selected" value="---" />
			<%
				for (int i = 0; i < values.length; i++) {
			%><option value='<%=values[i]%>'><%=values[i]%></option>

			<%
				}
			%>
		</select>
	</div>

	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<select id='value2' onchange="checkIfSimilarityExist('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=updateUrl%>', value1, value2, defaultValueResult)">
			<option selected="selected" value="---" />
			<%
				for (int i = 0; i < values.length; i++) {
			%><option value='<%=values[i]%>'><%=values[i]%></option>

			<%
				}
			%>
		</select>
	</div>
</div>
<div class="personalizationDivFuzzificationFunctionValuesTableRow">
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		DEFINE THE DEGREE OF SIMILARITY BETWEEN THE BOTH ITEMS:</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<input type="range" name="defaultValue" min="0" max="1" step="0.01"
			value="0.5" width="150px" id="defaultValue" onchange="setSlider()" oninput="setSlider()">
	</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<input type="text" id="defaultValueResult" value="0.5">
		<span id="similarityMsg">Similar</span>
	</div>
</div>

<%
	String saveUrl = KUrls.Fuzzifications.SaveSimilarity.getUrl(true) + "&" + KConstants.Request.fileNameParam
		+ "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "=" + fileOwner + "&"
		+ KConstants.Request.mode + "=" + modeSimilarity + "&" + KConstants.Request.databaseIndex + "="
		+ databaseIndex + "&" + KConstants.Request.columnIndex + "=" + columnIndex;
	JspsUtils.getValue(saveUrl);
%>
<div class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
	<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
		<div class='personalizationDivSaveButtonAndMsgTable'>
			<div class='personalizationDivSaveButtonAndMsgTableRow'>
				<div class='personalizationDivSaveButtonAndMsgTableCell'>
					<INPUT type='submit' value='Save modifications'
						<%-- onclick="saveSimilarity('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=saveUrl%>', value1, value2, defaultValueResult)"> --%>
						onclick="updateSimilarity('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=saveUrl%>', value1.value, value2.value, defaultValueResult, '<%=columnValue1%>', '<%=columnValue2%>')">
				</div>
				<%-- <div class='personalizationDivSaveButtonAndMsgTableCell'>
					<INPUT type='submit' value='Add Default Similarity'
						onclick="saveSimilarity('<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>', '<%=saveDefaultUrl%>', value1, value2, defaultValueResult)">
				</div> --%>
				<div class='personalizationDivSaveButtonAndMsgTableCell'>
					&nbsp;&nbsp;&nbsp;&nbsp;</div>
				<div class='personalizationDivSaveButtonAndMsgTableCell'
					id='<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId%>'>
				</div>
			</div>
		</div>
	</div>
</div>