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


<%
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
	LocalUserInfo localUserInfo = requestStoreHouse.getSession().getLocalUserInfo();
	String mode = requestStoreHouse.getRequestParameter(KConstants.Request.mode);
	String fileName = requestStoreHouse.getRequestParameter(KConstants.Request.fileNameParam);
	String fileOwner = requestStoreHouse.getRequestParameter(KConstants.Request.fileOwnerParam);

	ProgramPartAnalysis[][] fuzzifications = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis [][] programFields = resultsStoreHouse.getProgramPartAnalysis();
	ProgramPartAnalysis [] thisFuzzification = null;
	ProgramPartAnalysis myFuzzification = null;
	ProgramPartAnalysis defaultFuzzification = null;
	ProgramPartAnalysis [] othersFuzzifications = null;
	String [] keyValues = null;

	String predDefined = "", predNecessary = "";
	int x, y;

	String saveUrl = KUrls.Fuzzifications.Define.getUrl(true) + 
			"&" + KConstants.Request.fileNameParam + "=" + fileName + 
			"&" + KConstants.Request.fileOwnerParam + "=" + fileOwner +
			"&" + KConstants.Request.mode + "=" + mode;
%>


<script type="text/javascript">
	var selectedFormat;
	$(function(){
		/* $("#predNecessary").change(function() {
			var predNecessary = $("#predNecessary").val();
			var synonymName = $("#synonymName").val();
			var antonymName = $("#antonymName").val();
			if(predNecessary !== "" && synonymName !== "") {
				var regExp = /\(([^)]+)\)/;
				var dbName = regExp.exec(predNecessary)[1];
				$("#previewSynonym").html(synonymName+"("+dbName+") :~ synonym_of("+predNecessary+",prod,1)");
			}
			if(predNecessary !== "" && antonymName !== "") {
				var regExp = /\(([^)]+)\)/;
				var dbName = regExp.exec(predNecessary)[1];
				$("#previewAntonym").html(antonymName+"("+dbName+") :~ antonym_of("+predNecessary+",prod,1)");
			}
		});
		$("#synonymName").keyup(function() {
			var predNecessary = $("#predNecessary").val();
			var synonymName = $("#synonymName").val();
			if(predNecessary !== "" && synonymName !== "") {
				var regExp = /\(([^)]+)\)/;
				var dbName = regExp.exec(predNecessary)[1];
				$("#previewSynonym").html(synonymName+"("+dbName+") :~ synonym_of("+predNecessary+",prod,1)");
			}
		});
		$("#antonymName").keyup(function() {
			var predNecessary = $("#predNecessary").val();
			var antonymName = $("#antonymName").val();
			if(predNecessary !== "" && antonymName !== "") {
				var regExp = /\(([^)]+)\)/;
				var dbName = regExp.exec(predNecessary)[1];
				$("#previewAntonym").html(antonymName+"("+dbName+") :~ antonym_of("+predNecessary+",prod,1)");
			}
		}); */
		$("#saveModification").click(function() {
			var synonymName = $("#synonymName").val();
			var antonymName = $("#antonymName").val();
			if(synonymName !== "" || antonymName !== "") {
				var fuzzificationSaveStatusId = '<%= KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>';
				var saveUrl	= '<%= saveUrl %>';
				var predNecessary = $("#predNecessary").val();
				var regExp = /\(([^)]+)\)/;
				var dbName = regExp.exec(predNecessary)[1];
				//
				if(synonymName !== "")
					synonymName = synonymName + "("+dbName+")";
				if(antonymName !== "")
					antonymName = antonymName + "("+dbName+")";
				dbName = $("#predNecessary").val();
				//
				defineNewSynAnt(fuzzificationSaveStatusId, saveUrl, dbName, synonymName, antonymName, function(){
					$("#auxAndInvisibleSection").dialog("close");
				});
			} else {
				$("#fuzzificationSaveStatus").html(validation.msg);
			}
		});
		
		/* $("#closeDialog").click(function() {
			$("#auxAndInvisibleSection").dialog("close");
		}); */
	});
</script>
<hr>
<div class='personalizationDivFuzzificationFunctionTable'>
	<div id='FuzzificationTable'>
		<div class='personalizationDivFuzzificationFunctionTableRow'>
			<div class='personalizationDivFuzzificationFunctionTableCell2'
				id='<%=KConstants.JspsDivsIds.fuzzificationValuesAndButtonDivId %>'>
				<div class='personalizationDivFuzzificationFunctionWithButtonTable'>
					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div
							class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class="personalizationDivFuzzificationFunctionValuesTableRow">
								<div class="personalizationDivFuzzificationFunctionValuesTableCell">
									Select the criterion for defining synonyms or antonyms:
								</div>
								<div class="personalizationDivFuzzificationFunctionValuesTableCell">
									<select id = 'predNecessary'>
									<%
										for (int i = 0; i < fuzzifications.length; i++) {
											if ((fuzzifications[i] != null) && (fuzzifications[i].length > 0)) {
												System.out.println(fuzzifications[i][0]);
									%>
									<option value='<%=fuzzifications[i][0].getPredDefined()%>'><%=fuzzifications[i][0].getPredDefined()%></option>
									<%
											}
										}
									%>
									</select>
								</div>
							</div>
							<hr>
							
							<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								Define Synonym <input type ='text' id = 'synonymName'></input> <!-- <label id="previewSynonym"></label> -->
							</div>
							
							<br>
							<div class="personalizationDivFuzzificationFunctionValuesTableCell">
								Define Antonym <input type ='text' id = 'antonymName'></input> <!-- <label id="previewAntonym"></label> -->
							</div>
							
						</div>
					</div>
					
					<!-- New Code For Default -->
					<div>
					<hr/>
					</div>
							 
        

<%
	JspsUtils.getValue(saveUrl); 
%>

					<div
						class='personalizationDivFuzzificationFunctionWithButtonTableRow'>
						<div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<div class='personalizationDivSaveButtonAndMsgTableRow'>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										<INPUT id="saveModification" type='submit' value='Save'>
									</div>
									<div class='personalizationDivSaveButtonAndMsgTableCell'>
										&nbsp;&nbsp;&nbsp;&nbsp;</div>
									<div class='personalizationDivSaveButtonAndMsgTableCell'
										id='<%=KConstants.JspsDivsIds.fuzzificationSaveStatusDivId %>'>
									</div>
								</div>
							</div>
						</div>
						<!-- <div class='personalizationDivFuzzificationFunctionWithButtonTableCell'>
							<div class='personalizationDivSaveButtonAndMsgTable'>
								<INPUT id="closeDialog" type="button" value='Exit'>
							</div>
						</div> -->
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- END -->