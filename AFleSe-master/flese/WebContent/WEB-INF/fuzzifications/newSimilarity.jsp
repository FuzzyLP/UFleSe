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
	ProgramPartAnalysis[] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis[] othersFuzzifications = null;
	String[] keyValues = null;
	String predDefined = "", predNecessary = "";
	int x, y;

	String url1 = KUrls.Fuzzifications.SimilarityColumn.getUrl(true) + "&" + KConstants.Request.fileNameParam
			+ "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "=" + fileOwner;
%>


<div class='personalizationDivFuzzificationFunctionTable'>
	<div id='FuzzificationTable'>
		<div class='personalizationDivFuzzificationFunctionTableRow'>
			<div class='personalizationDivFuzzificationFunctionTableCell2'
				id='<%=KConstants.JspsDivsIds.fuzzificationValuesAndButtonDivId%>'>
				<div class='personalizationDivFuzzificationFunctionWithButtonTable'>
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div
								class="personalizationDivFuzzificationFunctionValuesTableRow">
								<div
									class="personalizationDivFuzzificationFunctionValuesTableCell">
									Select Database for defining Similarity:</div>
								<div
									class="personalizationDivFuzzificationFunctionValuesTableCell">
									<select id='predNecessary'
										onchange="selectedDatabaseChanged('<%=KConstants.JspsDivsIds.fuzzificationSimilarityColumnDivId%>',this, '<%=url1%>');">
										<option selected="selected" value="---" />
										<%
											for (int i = 0; i < programFields[0].length; i++) {
										%><option value='<%=i%>'><%=programFields[0][i].getDatabaseName()%></option>

										<%
											}
										%>
									</select>
								</div>
							</div>
							<div
								class='personalizationDivFuzzificationFunctionValuesTableRow'
								id='<%=KConstants.JspsDivsIds.fuzzificationSimilarityColumnDivId%>'>
							</div>





						</div>

					</div>
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'
							id='<%=KConstants.JspsDivsIds.fuzzificationSimilarityValueId%>'>
						</div>

						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'
							id='<%=KConstants.JspsDivsIds.fuzzificationSaveSimilarityId%>'>
						</div>
					</div>


				</div>
			</div>
		</div>
	</div>
</div>

<!-- END -->