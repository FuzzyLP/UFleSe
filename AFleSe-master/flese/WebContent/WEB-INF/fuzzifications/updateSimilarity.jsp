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
	System.out.println("=================================================================");
	System.out.println(databaseIndex);
	System.out.println("=================================================================");
	System.out.println(columnIndex);
	System.out.println("=================================================================");
	System.out.println(columnValue1);
	System.out.println("=================================================================");
	System.out.println(columnValue2);
	System.out.println("=================================================================");
	System.out.println(value);
	System.out.println("=================================================================");

	ProgramPartAnalysis[][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis[] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis[] othersFuzzifications = null;
	String[] keyValues = null;
	String predDefined = "", predNecessary = "";
	int x, y;

	String url1 = KUrls.Fuzzifications.UpdateSimilarityColumn.getUrl(true) + "&"
			+ KConstants.Request.fileNameParam + "=" + fileName + "&" + KConstants.Request.fileOwnerParam + "="
			+ fileOwner + "&" + KConstants.Request.columnIndex + "=" + columnIndex + "&"
			+ KConstants.Request.value1Index + "=" + columnValue1 + "&" + KConstants.Request.value2Index + "="
			+ columnValue2 + "&" + KConstants.Request.similarityValue + "=" + value;
%>

<script type="text/javascript">
	$(function(){
		var database = '<%= databaseIndex %>';
		$("select#database option[data-value='"+database+"']").attr('selected', true);
		$("select#database").trigger('change');
		$("select#database").attr('disabled','disabled');
		
		<%-- $("select#field").trigger('change');
		
		var value = '<%= value %>';
		$("#defaultValueResult").val(value); --%>
	});
</script>


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
									SELECT THE DATA FILE FOR DEFINING SIMILARITY:</div>
								<div
									class="personalizationDivFuzzificationFunctionValuesTableCell">
									<select id='database'
										onchange="selectedDatabaseChanged('<%=KConstants.JspsDivsIds.fuzzificationSimilarityColumnDivId%>',this, '<%=url1%>');">
										<%
											for (int i = 0; i < programFields[0].length; i++) {
										%><option value='<%=i%>' data-value='<%=programFields[0][i].getDatabaseName()%>'><%=programFields[0][i].getDatabaseName()%></option>

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