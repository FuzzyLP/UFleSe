<%@page import="programAnalysis.ProgramPartAnalysis"%>
<%@page import="constants.KUrls"%>
<%@page import="filesAndPaths.ProgramFileInfo"%>
<%@page import="constants.KConstants"%>
<%@page import="auxiliar.JspsUtils"%>
<%@page import="storeHouse.RequestStoreHouse"%>
<%@page import="storeHouse.ResultsStoreHouse"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="functionUtils.SimilarityFunction"%>

<%
	RequestStoreHouse requestStoreHouse = JspsUtils.getRequestStoreHouse(request);
	ResultsStoreHouse resultsStoreHouse = JspsUtils.getResultsStoreHouse(requestStoreHouse);
	ProgramFileInfo programFileInfo = resultsStoreHouse.getProgramFileInfo();

	List<SimilarityFunction> similarityFunctions = resultsStoreHouse.getSimilarityFnctions();

	ProgramPartAnalysis[][] fuzzifications = resultsStoreHouse.getProgramPartAnalysis();
	String mode = requestStoreHouse.getRequestParameter(KConstants.Request.mode);
	String urlEditFuzzification = KUrls.Fuzzifications.Edit.getUrl(true);
	String urlNewFuzzification = KUrls.Fuzzifications.New.getUrl(true);
	String urlDefineSimilarity = KUrls.Fuzzifications.NewSimilarity.getUrl(true);
	String urlEditSimilarity = KUrls.Fuzzifications.EditSimilarity.getUrl(true);
	String urlAddModifier = KUrls.Fuzzifications.AddModifier.getUrl(true);
	String urlUpdateFuzz = KUrls.Fuzzifications.UpdateFuzz.getUrl(true);
	String urlUpdateSimilarity = KUrls.Fuzzifications.UpdateSimilarity.getUrl(true);
	String urlRemoveFuzzy = KUrls.Fuzzifications.RemoveFuzzy.getUrl(true);
	String urlRemoveSimilarity = KUrls.Fuzzifications.RemoveSimilarity.getUrl(true);
	String urlDefineSynAnt = KUrls.Fuzzifications.DefineSynAnt.getUrl(true);
	String urlDefineFuzzyRule = KUrls.Fuzzifications.DefineFuzzyRule.getUrl(true);
	
	String modeSimilarity = "update";
	
	String textMode = "";
	String textMode2 = "";
	if (mode.equals(KConstants.Request.modeAdvanced)) {
		textMode = "Default";
	}
	if (resultsStoreHouse.getProgramFileInfo().getFileName().endsWith(".pl")) {
%>
<!--  <center><br> Select the <strong> <%=textMode%> </strong> fuzzification you want to personalize: </center> -->

<style>
	/* #auxAndInvisibleSection {
	    min-width: 800px;
	    min-height: 450px;
	} */
</style>

<div class="tab">
  <button id="defaultOpen" class="tablinks" onclick="showDiv(1, 'modifyExisting')" data-index="1">Modify the existing criterion</button>
  <button class="tablinks" onclick="showDiv(2, 'defineNew')" data-index="2">Defining New</button>
  <button class="tablinks" onclick="showDiv(3, 'removeCriteria')" data-index="3">Remove the existing criterion</button>
</div>

<div id="modifyExisting" class="tabcontent">
	<br>
	<div class='personalizationDivMainTable1'>
		<div class='personalizationDivMainTableRow1'>
			<div class='personalizationDivMainTableCell1'>
				<div class='personalizationDivSelectFuzzificationTable1'>
					
					<div class='personalizationDivSelectFuzzificationTableRow'>
						<div class='personalizationDivSelectFuzzificationTableCell customLabel'>
							Modify the existing criterion &nbsp;</div>
						<div class='personalizationDivSelectFuzzificationTableCell'>
							<select name="personalizationSelectComboBoxId1"
								id="personalizationSelectComboBoxId1"
								onchange="modificationFunctionChanged(this, '<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"1"%>', '<%=urlEditFuzzification%>', '<%=urlNewFuzzification%>', '<%=urlDefineSimilarity%>', '<%=urlAddModifier%>', '<%=urlEditSimilarity%>', '<%=urlUpdateFuzz%>', '<%=urlUpdateSimilarity%>');">
								<%-- onchange="personalizationFunctionChanged(this, '<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"1"%>', '<%=urlEditFuzzification%>', '<%=urlNewFuzzification%>', '<%=urlDefineSimilarity%>', '<%=urlAddModifier%>', '<%=urlEditSimilarity%>', '<%=urlUpdateFuzz%>');"> --%>
								<%=JspsUtils.comboBoxDefaultValue()%>
								<%
									for (int i = 0; i < fuzzifications.length; i++) {
											if ((fuzzifications[i] != null) && (fuzzifications[i].length > 0)) {
												ProgramPartAnalysis fuzzification = fuzzifications[i][0];
												/* String desc = JspsUtils.getFromFuzzificationNameOf(fuzzification,
														KConstants.Fuzzifications.database, true)
														+ " is "
														+ JspsUtils.getFromFuzzificationNameOf(fuzzification,
																KConstants.Fuzzifications.predDefined, true)
														+ " from the value it has for " + JspsUtils.getFromFuzzificationNameOf(fuzzification,
																KConstants.Fuzzifications.predNecessary, true); */
												
												String desc = fuzzification.getPredDefined();
																
												String id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
														+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&"
														+ KConstants.Fuzzifications.predDefined + "=" + fuzzification.getPredDefined() + "&"
														+ KConstants.Fuzzifications.predNecessary + "=" + fuzzification.getPredNecessary() + "&"
														+ KConstants.Request.mode + "=" + mode;
								%>
								<option id='<%=desc%>' title='<%=desc%>' value='<%=id%>' data-type="fuzzy"><%=desc%></option>
								<%
									}
										}
	
										for (int i = 0; i < similarityFunctions.size(); i++) {
											if (similarityFunctions.get(i) != null) {
												/* String desc = "For " + similarityFunctions.get(i).getDatabaseName() + " "
														+ similarityFunctions.get(i).getTableName() + ", "
														+ similarityFunctions.get(i).getColumnValue1() + " is similar to "
														+ similarityFunctions.get(i).getColumnValue2(); */
												
												String desc = "Similarity " + similarityFunctions.get(i).getTableName() + "(" + similarityFunctions.get(i).getDatabaseName() + ")";
												String label = "Similarity " + similarityFunctions.get(i).getTableName() + "(" + similarityFunctions.get(i).getDatabaseName() + ") (" + similarityFunctions.get(i).getColumnValue1() + ", " + similarityFunctions.get(i).getColumnValue2() + ")";
												
												String id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
														+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&"
														+ KConstants.Request.databaseIndex + "=" + similarityFunctions.get(i).getDatabaseName()
														+ "&" + KConstants.Request.columnIndex + "=" + similarityFunctions.get(i).getTableName()
														+ "&" + KConstants.Request.value1Index + "="
														+ similarityFunctions.get(i).getColumnValue1() + "&" + KConstants.Request.value2Index
														+ "=" + similarityFunctions.get(i).getColumnValue2() + "&"
														+ KConstants.Request.similarityValue + "="
														+ similarityFunctions.get(i).getSimilarityValue() + "&" + KConstants.Request.mode + "="
														+ modeSimilarity + "&"+ "update";
												
												%>
												<option id='<%=desc%>' title='<%=desc%>' value='<%=id%>' data-type="similarity"><%=label%></option>
												<%
												i += 2; //skip duplicated similarities
											}
										}
										String id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
												+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&" + "new";
								%>
	
							</select>
						</div>
					</div>
	
				</div>
			</div>
		</div>
		<div class='personalizationDivMainTableRow'>
			<div class='personalizationDivMainTableCell'
				id='<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"1"%>'>
				<%=textMode2%></div>
		</div>
	</div>
	<br>
</div>

<div id="defineNew" class="tabcontent">
	<br>
	<div class='personalizationDivMainTable'>
		<div class='personalizationDivMainTableRow'>
			<div class='personalizationDivMainTableCell'>
				<div class='personalizationDivSelectFuzzificationTable'>
					
					<div class='personalizationDivSelectFuzzificationTableRow'>
						<div class='personalizationDivSelectFuzzificationTableCell'>
							Define new &nbsp;</div>
						<div class='personalizationDivSelectFuzzificationTableCell'>
							<select name="personalizationSelectComboBoxId2"
								id="personalizationSelectComboBoxId2"
								onchange="personalizationFunctionChanged(this, '<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"2"%>', '<%=urlEditFuzzification%>', '<%=urlNewFuzzification%>', '<%=urlDefineSimilarity%>', '<%=urlAddModifier%>', '<%=urlDefineSynAnt%>', '<%=urlDefineFuzzyRule%>');">
								<%=JspsUtils.comboBoxDefaultValue()%>
	
								<option id='<%=id%>' title='New fuzzification' value='<%=id%>' data-type="fuzzy">Fuzzy search criterion</option>
	
								<%
									id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
												+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&" + "define";
								%>
								<option id='<%=id%>' title='Define Similarity' value='<%=id%>' data-type="similarity">
									Similarity relation</option>
								<%
									id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
												+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&" + "add";
								%>
								
								<%
									id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
												+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&" + "fuzzyRule";
								%>
								<option id='<%=id%>' title='Fuzzy rule' value='<%=id%>' data-type="fuzzyRule">Fuzzy rule</option>
								<%
									id = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
												+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&" + "synAnt";
								%>
								<option id='<%=id%>' title='Synonyms and antonyms' value='<%=id%>' data-type="synonymsAntonyms">Synonyms and antonyms</option>
							</select>
						</div>
					</div>
					
				</div>
			</div>
		</div>
		<div class='personalizationDivMainTableRow'>
			<div class='personalizationDivMainTableCell'
				id='<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"2"%>'>
				<%=textMode2%></div>
		</div>
	</div>
	<br>
</div>

<div id="removeCriteria" class="tabcontent">
	<br>
	<div class='personalizationDivMainTable3'>
		<div class='personalizationDivMainTableRow3'>
			<div class='personalizationDivMainTableCell1'>
				<div class='personalizationDivSelectFuzzificationTable3'>
					
					<div class='personalizationDivSelectFuzzificationTableRow'>
						<div class='personalizationDivSelectFuzzificationTableCell'>
							Remove the existing criterion &nbsp;</div>
						<div class='personalizationDivSelectFuzzificationTableCell'>
							<select name="personalizationSelectComboBoxId3"
								id="personalizationSelectComboBoxId3"
								onchange="removeExistingCriteria(this, '<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"1"%>', '<%=urlRemoveFuzzy%>', '<%=urlRemoveSimilarity%>');">
								<%-- onchange="personalizationFunctionChanged(this, '<%=KConstants.JspsDivsIds.personalizationFunctionUnderModificationDivId+"1"%>', '<%=urlEditFuzzification%>', '<%=urlNewFuzzification%>', '<%=urlDefineSimilarity%>', '<%=urlAddModifier%>', '<%=urlEditSimilarity%>', '<%=urlUpdateFuzz%>');"> --%>
								<%=JspsUtils.comboBoxDefaultValue()%>
								<%
									for (int i = 0; i < fuzzifications.length; i++) {
											if ((fuzzifications[i] != null) && (fuzzifications[i].length > 0)) {
												ProgramPartAnalysis fuzzification = fuzzifications[i][0];
												/* String desc = JspsUtils.getFromFuzzificationNameOf(fuzzification,
														KConstants.Fuzzifications.database, true)
														+ " is "
														+ JspsUtils.getFromFuzzificationNameOf(fuzzification,
																KConstants.Fuzzifications.predDefined, true)
														+ " from the value it has for " + JspsUtils.getFromFuzzificationNameOf(fuzzification,
																KConstants.Fuzzifications.predNecessary, true); */
												
												String desc = fuzzification.getPredDefined();
																
												String idToRemove = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
														+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&"
														+ KConstants.Fuzzifications.predDefined + "=" + fuzzification.getPredDefined() + "&"
														+ KConstants.Fuzzifications.predNecessary + "=" + fuzzification.getPredNecessary() + "&"
														+ KConstants.Request.mode + "=" + mode;
								%>
								<option id='<%=desc%>' title='<%=desc%>' value='<%=idToRemove%>' data-type="fuzzy"><%=desc%></option>
								<%
									}
										}
	
										for (int i = 0; i < similarityFunctions.size(); i++) {
											if (similarityFunctions.get(i) != null) {
												/* String desc = "For " + similarityFunctions.get(i).getDatabaseName() + " "
														+ similarityFunctions.get(i).getTableName() + ", "
														+ similarityFunctions.get(i).getColumnValue1() + " is similar to "
														+ similarityFunctions.get(i).getColumnValue2(); */
	
												String desc = "Similarity " + similarityFunctions.get(i).getTableName() + "(" + similarityFunctions.get(i).getDatabaseName() + ")";
														
												String idToRemove = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
														+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&"
														+ KConstants.Request.databaseIndex + "=" + similarityFunctions.get(i).getDatabaseName()
														+ "&" + KConstants.Request.columnIndex + "=" + similarityFunctions.get(i).getTableName()
														+ "&" + KConstants.Request.value1Index + "="
														+ similarityFunctions.get(i).getColumnValue1() + "&" + KConstants.Request.value2Index
														+ "=" + similarityFunctions.get(i).getColumnValue2() + "&"
														+ KConstants.Request.similarityValue + "="
														+ similarityFunctions.get(i).getSimilarityValue() + "&" + KConstants.Request.mode + "="
														+ modeSimilarity + "&"+ "update";
								%>
								<option id='<%=desc%>' title='<%=desc%>' value='<%=idToRemove%>' data-type="similarity"><%=desc%></option>
								<%
									}
										}
										String idToRemove = "&" + KConstants.Request.fileOwnerParam + "=" + programFileInfo.getFileOwner() + "&"
												+ KConstants.Request.fileNameParam + "=" + programFileInfo.getFileName() + "&" + "new";
								%>
	
							</select>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>
	<br>

	<div id="dialog-confirm" class="hiddenDefault"
		title="Confirmation" style="padding: 25px 0 3px 15px !important;">
		<p style="text-align: left;">
			<span class="ui-icon ui-icon-alert"
				style="float: left; margin: 12px 12px 0 0;"></span>
				<!-- The criterion <b id="criterionName"></b> will be permanently deleted and cannot be recovered. Are you sure? -->
				Do you want to remove the criteria ?
		</p>
	</div>

</div>

<%
	} else {
%>
<div class='personalizationDivMainTable'>
	<div class='personalizationDivMainTableRow'>
		<div class='personalizationDivMainTableCell'>You cannot
			personalize this program file.</div>
	</div>
</div>

<%
	}
%>
<script type="text/javascript">
	function hide() {
		var earrings = document.getElementById('earringstd');
		earrings.style.visibility = 'hidden';
	}

	function show() {
		var earrings = document.getElementById('earringstd');
		earrings.style.visibility = 'visible';
	}
	
	/* $(".tab button").css("width",parseInt($(".tab").css("width").split("px")[0])/2); */
	/* $("#auxAndInvisibleSection").dialog({
		resize: function(event, ui) {
			$(".tab button").css("width",parseInt($(".tab").css("width").split("px")[0])/2);
		}
	 }); */
	
	// Get the element with id="defaultOpen" and click on it
	document.getElementById("defaultOpen").click();
	 
	 if($("#removeCriteria select#personalizationSelectComboBoxId3 option").length == 1) {
		 $("div.tab button.tablinks[data-index='3']").hide();
		 $("#removeCriteria").hide();
	 }
</script>



<!-- END -->