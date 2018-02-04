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

	ProgramPartAnalysis[][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis[] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis[] othersFuzzifications = null;
	String[] keyValues = null;
	String predDefined = "", predNecessary = "";
	int x, y;

	String url1 = KUrls.Fuzzifications.SimilarityValue.getUrl(true) + "&" + KConstants.Request.fileNameParam
			+ "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "=" + fileOwner + "&"
			+ KConstants.Request.databaseIndex + "=" + databaseIndex;
%>

	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		Select Column for defining Similarity:</div>
	<div class="personalizationDivFuzzificationFunctionValuesTableCell">
		<select id='predNecessary'
			onchange="selectedColumnChanged('<%=KConstants.JspsDivsIds.fuzzificationSimilarityValueId%>',this, '<%=url1%>');">
			<option selected="selected" value="---" />
			<%
				for (int i = 0; i < programFields[0][dbIndex].getProgramFields().length; i++) {

					if (programFields[0][dbIndex].getProgramFields()[i][1].contains("rfuzzy_enum_type")
							&& programFields[0][dbIndex].getProgramFields()[i][0] != null) {
			%><option value='<%=i%>'><%=programFields[0][dbIndex].getProgramFields()[i][0]%></option>

			<%
				}
				}
			%>
		</select>
	</div>
	
	
