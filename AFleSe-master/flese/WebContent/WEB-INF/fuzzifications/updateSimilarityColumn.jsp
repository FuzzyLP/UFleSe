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
	int dbIndex = Integer.parseInt(databaseIndex);
	String columnIndex = requestStoreHouse.getRequestParameter(KConstants.Request.columnIndex);
	String columnValue1 = requestStoreHouse.getRequestParameter(KConstants.Request.value1Index);
	String columnValue2 = requestStoreHouse.getRequestParameter(KConstants.Request.value2Index);
	String value = requestStoreHouse.getRequestParameter(KConstants.Request.similarityValue);
	ProgramPartAnalysis[][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis[] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis[] othersFuzzifications = null;
	String[] keyValues = null;
	String predDefined = "", predNecessary = "";
	int x, y;

	String url1 = KUrls.Fuzzifications.UpdateSimilarityValue.getUrl(true) + "&"
			+ KConstants.Request.fileNameParam + "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "="
			+ fileOwner + "&" + KConstants.Request.databaseIndex + "=" + databaseIndex + "&"
			+ KConstants.Request.value1Index + "=" + columnValue1 + "&" + KConstants.Request.value2Index + "="
			+ columnValue2 + "&" + KConstants.Request.similarityValue + "=" + value;
%>

<script type="text/javascript">
	$(function() {
		var columnIndex = '<%= columnIndex %>';
		$("select#field option[data-value='"+columnIndex+"']").attr('selected', true);
		$("select#field").trigger('change');
		$("select#field").attr('disabled','disabled');
	});
</script>

	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		SELECT THE FIELD FOR DEFINING SIMILARITY:</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<select id='field'
			onchange="selectedColumnChanged('<%=KConstants.JspsDivsIds.fuzzificationSimilarityValueId%>',this, '<%=url1%>');">
			<%
				for (int i = 0; i < programFields[0][dbIndex].getProgramFields().length; i++) {

					if (programFields[0][dbIndex].getProgramFields()[i][1].contains("rfuzzy_enum_type")
							&& programFields[0][dbIndex].getProgramFields()[i][0] != null) {
			%><option value='<%=i%>' data-value='<%=programFields[0][dbIndex].getProgramFields()[i][0]%>'><%=programFields[0][dbIndex].getProgramFields()[i][0]%></option>

			<%
				}
				}
			%>
		</select>
	</div>
	
	
